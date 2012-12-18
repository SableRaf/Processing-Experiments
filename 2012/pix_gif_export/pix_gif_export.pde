import gifAnimation.*;

/*
 * Inspiration: http://www.cntlsn.com/dev/pixpat/
 
 * Tested in Processing 2.0b7
 * Shader support is still beta in Processing at the moment 
 * so this sketch might not work anymore in the final release.
 
 * Arrow UP/DOWN to enlarge/reduce the square module by 1 pixel
 * Press 'S' to start recording the gif file
 * Press 'S' again to save the file (right now, only one file can be created)
 
 */

PShader myShader;
int side = 3; // default grid width
int seed = 0; // default random seed (no need to edit this one)

int freq = 333; // speed of the refresh (in ms)

GifMaker gifExport;
boolean isRecording = false;
boolean isFinished = false;

void setup() {
  size(800, 800, P2D);
  //size(displayWidth, displayHeight, P2D);
  noSmooth();
  noCursor();
  frameRate(1000/freq);
  
  gifInit();
  
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
  
  if(isRecording) gifAddFrame();
  if(isFinished) gifExport.finish(); // write file
}

void keyPressed() {
  if(keyCode == UP) { side++; println("side="+side); }
  if(keyCode == DOWN && side>2) { side--; println("side="+side); }
}

void keyReleased() {
  if(key == 's' || key == 'S' ) {
    if(!isRecording)  isRecording = true;
    else { isRecording = false; isFinished = true; }
  }
}

void gifInit() {
  gifExport = new GifMaker(this, "pix.gif");
  gifExport.setRepeat(0);        // make it an "endless" animation
  //gifExport.setTransparent(0,0,0);  // black is transparent 
}

void gifAddFrame() {
  gifExport.setDelay(freq);
  gifExport.addFrame();
}
