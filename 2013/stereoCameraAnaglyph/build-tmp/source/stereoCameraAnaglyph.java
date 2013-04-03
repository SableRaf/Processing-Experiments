import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class stereoCameraAnaglyph extends PApplet {


// stereo viewing taken from http://wiki.processing.org/index.php?title=Stereo_viewing
// @author John Gilbertson
 
// Optimised anaglyph shader by John Einselen
// http://iaian7.com/quartz/AnaglyphCompositing

// Simple anaglyph shader by r3dux
// http://r3dux.org/2011/05/anaglyphic-3d-in-glsl/
 
// Adapted for Processing 2.0 by Rapha\u00ebl de Courville
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
Float contrast = 0.4f; // lets us adjust the apparent colour saturation (based on the contrast between channels) better left between 0.5 and 1.0
Float deghost = 0.6f;  // Amount of deghosting (via channel subtraction)
Float stereo = 0.0f;   // allows for small alignment adjustments to the images
 
public void setup() 
{
  size(500,500,P3D);
  //size(displayWidth,displayHeight,P3D);
  
  left = createGraphics(width, height, P3D);
  right = createGraphics(width, height, P3D);
  
  simple_anaglyph = loadShader("simple_anaglyph.glsl");
  optimised_anaglyph = loadShader("optimised_anaglyph.glsl");
  
  rotation=0;
}
 
public void draw()
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
  
  rotation+=0.01f; //you can vary the speed of rotation by altering this value
 
  // Left Eye
  // Using Camera gives us much more control over the eye position
  left.beginDraw();
  left.ambientLight(64,64,64); //some lights to aid the effect
  left.pointLight(128,128,128,0,20,-50);
  left.background(0);
  left.fill(255);
  left.noStroke();
  left.pushMatrix();
  left.rotateX(rotation);
  left.rotateY(rotation/2.3f);
  left.scale(height*.003f);
  left.box(30);
  left.translate(0,0,30);
  left.box(10);
  left.popMatrix();
  left.camera(eyeX-eyeDist/2, eyeY, eyeZ, 0,0,0,0,-1,0);
  left.endDraw();
 
  // Right Eye
  right.beginDraw();
  right.ambientLight(64,64,64); //some lights to aid the effect
  right.pointLight(128,128,128,0,20,-50);
  right.background(0);
  right.fill(255);
  right.noStroke();
  right.pushMatrix();
  right.rotateX(rotation);
  right.rotateY(rotation/2.3f);
  right.scale(height*.003f);
  right.box(30);
  right.translate(0,0,30);
  right.box(10);
  right.popMatrix();
  right.camera(eyeX+eyeDist/2, eyeY, eyeZ,0,0,0,0,-1,0);
  right.endDraw();
  
  if(isShader) 
   shader(s);
  
  image(left,0,0,width, height);  // Any image will do but we have to call the function
}


public void keyPressed() {
 if(key == ' ') { 
   isOptimised = !isOptimised; 
   println("isOptimised = "+ isOptimised);
 }
 else if (key == 'x' || key == 'X') { 
   isShader = !isShader; 
   println("isShader = "+ isShader);
 }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "stereoCameraAnaglyph" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
