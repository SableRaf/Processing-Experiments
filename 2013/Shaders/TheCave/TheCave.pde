PShader myShader;
PImage tex00, tex01, tex02;

void setup() {
  size(640, 360, P2D);
  noStroke();
  
  tex00 = loadImage("tex00.jpg");
  tex01 = loadImage("tex01.jpg");
  tex02 = loadImage("tex02.jpg");
 
  myShader = loadShader("shader.glsl");
  myShader.set("resolution", float(width), float(height));   
  
  myShader.set("iChannel0",tex00);
  myShader.set("iChannel1",tex01);
  myShader.set("iChannel2",tex02);
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

