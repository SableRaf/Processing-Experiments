
/* Rendering a shader in a PGraphics object */

PShader myShader;
PGraphics scene;

void setup() {
  size(800,600, P2D);
  myShader = loadShader("gradient.glsl");
  scene = createGraphics(width, height, P2D);
}

void draw() {
  myShader.set("resolution", float(width), float(height)); 
  myShader.set("time", millis() / 1000.0);
  
  // Be sure to call everything between beginDraw() and endDraw()
  scene.beginDraw();
  scene.background(0);
  scene.shader(myShader);
  scene.rect(0,0,width,height);
  scene.endDraw();
  
  image(scene, 0, 0, width, height); 
}
