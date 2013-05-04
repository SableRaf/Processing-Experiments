import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.video.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class ColorZebra extends PApplet {



Capture video;
PImage img;
Boolean videoInit = false;

PShader myShader;

public void setup() {
  size(640, 360, P2D);
  frameRate(30);
  noStroke();
  
  img = loadImage("image.jpg");
 
  
  // Uses the default video input, see the reference if this causes an error
  video = new Capture(this, width, height);
  video.start();
  
 
  myShader = loadShader("shader.glsl");
  
  myShader.set("resolution", PApplet.parseFloat(width), PApplet.parseFloat(height));   
  myShader.set("iChannel0", img);

  // Wait until the camera feed becomes available
  while ( !video.available() ) {}
}

public void draw() {
  background(0);
  
  myShader.set("time", millis() / 1000.0f);
  
  video.read();
  myShader.set("iChannel0", video);
  
  shader(myShader);
  // This kind of effects are entirely implemented in the
  // fragment shader, they only need a quad covering the  
  // entire view area so every pixel is pushed through the 
  // shader.
  rect(0, 0, width, height); 
  filter(THRESHOLD);
}

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "ColorZebra" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
