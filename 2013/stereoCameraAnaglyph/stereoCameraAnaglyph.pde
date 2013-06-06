
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
 
float rotation;

boolean isShader = true;
boolean isOptimised = true;

PVector cameraPosition;
PVector cameraTarget;

float eyeX = 0;
float eyeY = 0;
float eyeZ = -100; // position of the viewer
float eyeDist = 3; // distance between the two cameras, the higher, the more the graphics will "pop out"


PShader simple_anaglyph, optimised_anaglyph;
PGraphics left, right;

// Shader uniforms
Float contrast = 0.4; // lets us adjust the apparent colour saturation (based on the contrast between channels) better left between 0.5 and 1.0
Float deghost = 0.6;  // Amount of deghosting (via channel subtraction)
Float stereo = 0.0;   // allows for small alignment adjustments to the images
 
void setup() 
{
  size(500,500,P3D);
  //size(displayWidth,displayHeight,P3D);
  
  left = createGraphics(width, height, P3D);
  right = createGraphics(width, height, P3D);
  
  simple_anaglyph = loadShader("simple_anaglyph.glsl");
  optimised_anaglyph = loadShader("optimised_anaglyph.glsl");
  
  rotation=0;
}
 
void draw()
{
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
  
  s.set("Left", left);
  s.set("Right", right);
  
  resetShader();
  
  rotation+=0.01; //you can vary the speed of rotation by altering this value
 
  // Draw the scene for each eye
  drawScene(left, -eyeDist/2);
  drawScene(right, eyeDist/2);
  
  // Anything we draw after that will be affected by the shader
  if(isShader) 
   shader(s);
  
  // Any image will do but we have to call the function 
  // as we're using a TEXTURE shader
  image(left,0,0,width, height);  
  
  // Anything we draw after that will 
  // not be affected by the shader anymore
  resetShader();
}

/* All of your 3D drawing goes here */
void drawScene(PGraphics pg, float offset) {
  
  int w = pg.width;
  int h = pg.height;
  
  pg.beginDraw();  
  
  pg.background(0);

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
  
  // use custom camera
  pg.camera(eyeX + offset, eyeY, eyeZ, 0,0,0,0,-1,0);
  
  pg.endDraw();
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
}
