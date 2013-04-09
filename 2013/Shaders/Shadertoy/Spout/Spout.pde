PShader myShader;
PImage tex00;

void setup() {
  size(640, 360, P2D);
  noStroke();
  
  tex00 = loadImage("tex00.jpg");
 
  myShader = loadShader("shader.glsl");
  myShader.set("resolution", float(width), float(height));  
  myShader.set("iChannel0",tex00); 
}

void draw() {
  background(0);
  myShader.set("time", millis() / 1000.0);
  myShader.set("mouse", float(mouseX), float(mouseY));
  
  if(mousePressed)
    myShader.set("mousePressed", 1.0, 1.0);
  else 
    myShader.set("mousePressed", 0.0, 0.0);
  
  shader(myShader);
  // This kind of effects are entirely implemented in the
  // fragment shader, they only need a quad covering the  
  // entire view area so every pixel is pushed through the 
  // shader.   
  rect(0, 0, width, height);  
}

