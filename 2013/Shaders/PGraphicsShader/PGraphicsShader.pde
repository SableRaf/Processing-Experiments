
/* Rendering a shader in a PGraphics object */

PShader myShader;
PGraphics scene;

void setup() {
  size(800,600, P2D);
  
  // Add the shader to the sketch
  myShader = loadShader("gradient.glsl");
  
  scene = createGraphics(width, height, P2D);
}

void draw() {
  // Set the shader uniforms

  
  // Be sure to draw only between beginDraw() and endDraw()
  scene.beginDraw();
  shader(myShader);
  myShader.set("resolution", float(width), float(height)); 
  myShader.set("time", millis() / 1000.0);
  rect(0,0,width,height);
  resetShader();
  scene.endDraw();
  
  // Display the finished PGraphics
  image(scene, 0, 0, width, height); 
}
