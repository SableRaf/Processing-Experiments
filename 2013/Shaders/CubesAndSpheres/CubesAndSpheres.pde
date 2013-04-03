PShader myShader;

void setup() {
  size(640, 360, P2D);
  noStroke();
 
  myShader = loadShader("shader.glsl");
  myShader.set("resolution", float(width), float(height));   
}

void draw() {
  background(0);
  myShader.set("time", millis() / 1000.0);
  
  if(mousePressed) { // This doesn't work properly for some reason
    float x = map(mouseX, 0, width, 0, 1);
    float y = map(mouseY, 0, height, 1, 0);
    myShader.set("mouse", x, y);
    myShader.set("mousePressed", 1.0, 1.0)
  }
  else {
    myShader.set("mouse", 1.0, 0.5);
    myShader.set("mousePressed", 0.0, 0.0)
  }
  
  shader(myShader);
  // This kind of effects are entirely implemented in the
  // fragment shader, they only need a quad covering the  
  // entire view area so every pixel is pushed through the 
  // shader.   
  rect(0, 0, width, height);  
}

