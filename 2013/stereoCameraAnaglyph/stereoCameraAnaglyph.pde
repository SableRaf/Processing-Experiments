
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
 
float rotation;

boolean isShader = true;
boolean isOptimised = true;

PShader simple_anaglyph, optimised_anaglyph;
PGraphics left, right;
 
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
  
  perspective(PI/3.0,1,0.1,1000); //this is needed ot stop the images being squashed
  noStroke();
  rotation=0;
}
 
void draw()
{
  PShader s;
  
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
 
  // Left Eye
  // Using Camera gives us much more control over the eye position
  left.beginDraw();
  left.ambientLight(64,64,64); //some lights to aid the effect
  left.pointLight(128,128,128,0,20,-50);
  left.background(0);
  left.fill(255);
  left.noStroke();
  left.camera(-5,0,-100,0,0,0,0,-1,0);
  left.pushMatrix();
  left.rotateX(rotation);
  left.rotateY(rotation/2.3);
  left.box(30);
  left.translate(0,0,30);
  left.box(10);
  left.popMatrix();
  left.endDraw();
 
  // Right Eye
  right.beginDraw();
  right.ambientLight(64,64,64); //some lights to aid the effect
  right.pointLight(128,128,128,0,20,-50);
  right.background(0);
  right.fill(255);
  right.noStroke();
  right.camera(5,0,-100,0,0,0,0,-1,0);
  right.pushMatrix();
  right.rotateX(rotation);
  right.rotateY(rotation/2.3);
  right.box(30);
  right.translate(0,0,30);
  right.box(10);
  right.popMatrix();
  right.endDraw();
  
  PImage scene;
  
  if(isShader) 
   shader(s);
  
  image(left,0,0,width, height);  // Any image will do but we have to call the function
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
