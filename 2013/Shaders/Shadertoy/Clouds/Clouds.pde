PShader myShader;

void setup() {
  size(640, 360, P2D);
  noStroke();
  
  frameRate(-1);
 
  myShader = loadShader("shader.glsl");
  myShader.set("resolution", float(width), float(height));   
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
  resetShader();
 
 text("fps: " + round(frameRate), 10, 10); 
}

