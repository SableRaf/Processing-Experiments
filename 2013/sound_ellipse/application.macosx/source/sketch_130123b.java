import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import ddf.minim.signals.*; 
import ddf.minim.*; 
import ddf.minim.analysis.*; 
import ddf.minim.effects.*; 
import ddf.minim.ugens.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class sketch_130123b extends PApplet {







float diameter = 100;

Minim minim;
AudioInput microphone;

public void setup() {
  background(255);
  size(550, 550);
  
  // We want to get the microphone input
  minim = new Minim(this);
  microphone = minim.getLineIn(Minim.STEREO, 512);
}

public void draw() {
  println(microphone.mix.level());
  float soundLevel = microphone.mix.level()*100;

  diameter = constrain(diameter + soundLevel, 100, 200);
  diameter -= 5;

  pushMatrix();
  translate(width/2, height/2);
  rotate(frameCount*.07f);
  ellipseMode(CORNER);
  noFill();
  stroke(0);
  ellipse(0, 0, diameter, diameter);
  popMatrix();
  
  if(frameCount%10 == 0) {
    noStroke();
    fill(255,50);
    rect(0,0,width,height);
  }
}

public void stop() {
  microphone.close();
  minim.stop();
  super.stop();
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "sketch_130123b" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
