PShader myShader;
PImage img;

void setup() {
  size(640, 360, P2D);
  frameRate(30);
  noStroke();
  
  img = loadImage("image.jpg");

  myShader = loadShader("shader.glsl");
  
  myShader.set("resolution", float(width), float(height));   
  myShader.set("iChannel0", img);
}

void draw() {
  background(0);
  
  myShader.set("time", millis() / 1000.0);
  
  shader(myShader);
  // This kind of effects are entirely implemented in the
  // fragment shader, they only need a quad covering the  
  // entire view area so every pixel is pushed through the 
  // shader.
  rect(0, 0, width, height);  
}

