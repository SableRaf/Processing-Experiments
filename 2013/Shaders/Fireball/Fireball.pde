PShader fireball;

void setup() {
  size(640, 360, P2D);
  noStroke();
 
  fireball = loadShader("fireball.glsl");
  fireball.set("resolution", float(width), float(height));   
}

void draw() {
  fireball.set("time", millis() / 1000.0);
  
  shader(fireball);
  // This kind of effects are entirely implemented in the
  // fragment shader, they only need a quad covering the  
  // entire view area so every pixel is pushed through the 
  // shader.   
  rect(0, 0, width, height);  
}

