/*
 * Inspiration: http://www.cntlsn.com/dev/pixpat/
 
 * Tested in Processing 2.0b7
 * Shader support is still beta in Processing at the moment 
 * so this sketch might not work anymore in the final release.
 
 * Arrow UP to enlarge the square module by 1 pixel
 * Arrow DOWN to reduce the square module by 1 pixel
 
 */

PShader myShader;
int side = 3; // default grid width
int seed = 0; // default random seed (no need to edit this one)

void setup() {
  size(200, 200, P2D);
  //size(displayWidth, displayHeight, P2D);
  noSmooth();
  noCursor();
  frameRate(1);
  
  /*
  myShader = loadShader("shader.frag");
  myShader.set("resolution", float(width), float(height));
  shader(myShader); 
  */
}

void draw() {
  background(0);

  // The code below would normally go in setup() as 
  // you would not need to load the shader on every 
  // frame but right now, this allows you to change 
  // the shader file and see the result in the active 
  // sketch window without reloading it every time.
  // Just edit and save shader.frag to apply the changes.
  myShader = loadShader("shader.frag");
  myShader.set("resolution", float(width), float(height));
  shader(myShader);
  
  seed = (int)random(0,1000);
  
  myShader.set("time", (float)(millis() / 1000.0));
  myShader.set("mouse", float(mouseX), float(mouseY));
  myShader.set("side", (float)side);
  myShader.set("seed", (float)seed);
  
  noStroke();
  fill(0);
  rect(0, 0, width, height);  
  
  resetShader();
}

void keyPressed() {
  if(keyCode == UP) { side++; println("side="+side); }
  if(keyCode == DOWN && side>2) { side--; println("side="+side); }
}
