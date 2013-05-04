import processing.video.*;

Capture video;
PImage img;
Boolean videoInit = false;

PShader myShader;

void setup() {
  size(640, 360, P2D);
  frameRate(30);
  noStroke();
  
  img = loadImage("image.jpg");
 
  
  // Uses the default video input, see the reference if this causes an error
  video = new Capture(this, width, height);
  video.start();
  
 
  myShader = loadShader("shader.glsl");
  
  myShader.set("resolution", float(width), float(height));   
  myShader.set("iChannel0", img);

  // Wait until the camera feed becomes available
  while ( !video.available() ) {}
}

void draw() {
  background(0);
  
  myShader.set("time", millis() / 1000.0);
  
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

