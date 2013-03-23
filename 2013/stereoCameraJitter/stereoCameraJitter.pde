
// stereo viewing taken from http://wiki.processing.org/index.php?title=Stereo_viewing
// @author John Gilbertson
 
// Adapted for Processing 2.0 by Raphaël de Courville
// https://twitter.com/sableRaph
 
float rotation;

PGraphics left, right;
 
void setup() 
{
  size(500,300,P3D);
  
  left = createGraphics(width, height, P3D);
  right = createGraphics(width, height, P3D);
  
  perspective(PI/3.0,1,0.1,1000); //this is needed ot stop the images being squashed
  noStroke();
  rotation=0;
}
 
void draw()
{
  rotation+=0.01; //you can vary the speed of rotation by altering this value
 
  // Left Eye
  // Using Camera gives us much more control over the eye position
  left.beginDraw();
  left.ambientLight(64,64,64); //some lights to aid the effect
  left.pointLight(128,128,128,0,20,-50);
  left.background(0);
  left.noFill();
  left.stroke(255);
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
  right.noFill();
  right.stroke(255);
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
  
  // Switch between the two images to get the jitter effect.
  if(frameCount%8<4) scene=left;
  else scene=right;
  
  image(scene,0,0,width, height);
}
