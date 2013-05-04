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

public class SinColor extends PApplet {

PShader myShader;

public void setup() {
  size(640, 360, P2D);
  //noStroke();
 
  myShader = loadShader("shader.glsl");
  //myShader.set("resolution", float(width), float(height)); 
  //myShader.set("resolution", float(3), float(3));   
}

public void draw() {
  //background(0);
  //myShader.set("time", millis() / 1000.0);
  
  shader(myShader);
  // This kind of effects are entirely implemented in the
  // fragment shader, they only need a quad covering the  
  // entire view area so every pixel is pushed through the 
  // shader.   
  rect(0, 0, width, height);  
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "SinColor" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
