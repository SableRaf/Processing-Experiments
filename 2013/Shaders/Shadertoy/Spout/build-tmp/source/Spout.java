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

public class Spout extends PApplet {

PShader myShader;
PImage tex00;

public void setup() {
  size(640, 360, P2D);
  noStroke();
  
  tex00 = loadImage("tex00.jpg");
 
  myShader = loadShader("shader.glsl");
  myShader.set("resolution", PApplet.parseFloat(width), PApplet.parseFloat(height));  
  myShader.set("iChannel0",tex00); 
}

public void draw() {
  background(0);
  myShader.set("time", millis() / 1000.0f);
  myShader.set("mouse", PApplet.parseFloat(mouseX), PApplet.parseFloat(mouseY));
  
  if(mousePressed)
    myShader.set("mousePressed", 1.0f, 1.0f);
  else 
    myShader.set("mousePressed", 0.0f, 0.0f);
  
  shader(myShader);
  // This kind of effects are entirely implemented in the
  // fragment shader, they only need a quad covering the  
  // entire view area so every pixel is pushed through the 
  // shader.   
  rect(0, 0, width, height);  
}

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Spout" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
