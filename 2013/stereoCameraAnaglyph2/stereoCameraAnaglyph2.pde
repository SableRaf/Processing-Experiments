
// stereo viewing taken from http://wiki.processing.org/index.php?title=Stereo_viewing
// @author John Gilbertson
 
// Optimised anaglyph shader by John Einselen
// http://iaian7.com/quartz/AnaglyphCompositing

// Simple anaglyph shader by r3dux
// http://r3dux.org/2011/05/anaglyphic-3d-in-glsl/
 
// Adapted for Processing 2.0 by Raphaël de Courville
// https://twitter.com/sableRaph

// SPACE: switch between the two anaglyph modes
// X: switch 3D on/off
// MouseY: traveling (Z axis)
// MouseX: 3D effect
 
float rotation = 0;

boolean isShader = true;
boolean isOptimised = true;
boolean isRight = true;

PVector cameraPosition;
PVector cameraTarget;

float eyeX = 0;
float eyeY = 0;
float eyeZ = -100; // position of the viewer
float eyeDist = 3; // distance between the two cameras, the higher, the more the graphics will "pop out"


PShader simple_anaglyph, optimised_anaglyph;

PGraphics pg; // offscreen buffer
PGraphics left, right; // result images for each eye

// Shader uniforms
Float contrast = 0.4; // lets us adjust the apparent colour saturation (based on the contrast between channels) better left between 0.5 and 1.0
Float deghost = 0.6;  // Amount of deghosting (via channel subtraction)
Float stereo = 0.0;   // allows for small alignment adjustments to the images

void setup() 
{
  size(500,500,P3D);
  //size(displayWidth,displayHeight,P3D);
  
  pg = createGraphics(width, height, P3D);
  left = createGraphics(width, height, P3D);
  right = createGraphics(width, height, P3D);
  
  simple_anaglyph = loadShader("simple_anaglyph.glsl");
  optimised_anaglyph = loadShader("optimised_anaglyph.glsl");
}
 
void draw()
{
  rotation+=0.01;   // rotation speed
  
  pg.beginDraw();
  
  // Create image for the left eye
  pg.beginCamera();
  pg.camera(eyeX - eyeDist/2, eyeY, eyeZ, 0,0,0,0,-1,0);
  pg.endCamera();
  
  left = pg;  // Save current state
  
  
  // Create image for the right eye
  pg.beginCamera();
  pg.camera(eyeX + eyeDist/2, eyeY, eyeZ, 0,0,0,0,-1,0);
  pg.endCamera();
  
  right = pg;  // Save current viewport
  
  
  PShader s;
  
  eyeZ = map(mouseY, 0, height, -100, -200);
  eyeDist = map(mouseX, 0, width, 0, 7);
  
  s = simple_anaglyph;
  
  if(isOptimised) { 
    s = optimised_anaglyph; 
    s.set("Contrast", contrast);
    s.set("Deghost", deghost);
    s.set("Stereo", stereo);
  }
  
  pg.background(100);

  //some lights to aid the effect
  pg.ambientLight(64,64,64);
  pg.pointLight(128,128,128,0,20,-50);
  
  pg.pushMatrix();
  pg.fill(255);
  pg.noStroke();
  pg.rotateX(rotation);
  pg.rotateY(rotation/2.3);
  pg.scale(height*.003);
  pg.box(30);
  pg.translate(0,0,30);
  pg.box(10);
  pg.popMatrix();
  
  pg.endDraw();
  
  
  s.set("Left", left);
  s.set("Right", right);
  
  //background(0);
  
  // Set the default camera back
  //camera(width/2.0, height/2.0, (height/2.0) / tan(PI*30.0 / 180.0), width/2.0, height/2.0, 0, 0, 1, 0);
  
  // Anything we draw after that will be affected by the shader
  if(isShader) {
   shader(s);
  }
  
  // Any image will do but we have to call the image()
  // function as we're using a TEXTURE shader
  if(isRight) image(right, 0, 0, width, height);
  else image(left, 0, 0, width, height);
  
  // Anything we draw after that will 
  // not be affected by the shader anymore
  resetShader();
}

void keyPressed() {
 if(key == ' ') { 
   isOptimised = !isOptimised; 
   println("isOptimised = "+ isOptimised);
 }
 else if (key == 'x' || key == 'X') { 
   isShader = !isShader; 
   println("isShader = "+ isShader);
 }
 else if (key == 'r' || key == 'R') { 
   isRight = !isRight; 
   println("isRight = "+ isRight);
 }
}
