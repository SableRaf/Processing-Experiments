import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.ugens.*;

float diameter = 100;

Minim minim;
AudioInput microphone;

void setup() {
  background(255);
  size(550, 550);
  
  // We want to get the microphone input
  minim = new Minim(this);
  microphone = minim.getLineIn(Minim.STEREO, 512);
}

void draw() {
  println(microphone.mix.level());
  
  float soundLevel = microphone.mix.level()*100;

  diameter = constrain(diameter + soundLevel, 100, 200);
  diameter -= 5;

  pushMatrix();
  translate(width/2, height/2);
  rotate(frameCount*.07);
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

void stop() {
  microphone.close();
  minim.stop();
  super.stop();
}
