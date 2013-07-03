
// Abstract movie player by Abe Pazos
// With spray brush simulator by Raphaël de Courville

// Note: this program runs only in the Processing IDE, not in the browser

import processing.video.*;

//String PATH = "transit.mov";
String PATH = "video.mov";
Movie mov;
PImage frame;

PShader pointShader;
float weight;
float depthOffset;
float offsetVel;

// Spray density distribution expressed in grayscale gradient
PImage sprayMap;

void setup() {
  //size(640, 360);
  size(1022, 597, P3D);
  frameRate(30);
  mov = new Movie(this, PATH);
  mov.play();  
  mov.speed(1);
  mov.volume(1);
  //colorMode(HSB, 1);
  background(0);
  
  strokeCap(SQUARE);
  
  sprayMap = loadImage("sprayMap.png");
  depthOffset = 0.0;
  offsetVel = 0.0005;
  pointShader = loadShader("pointfrag.glsl", "pointvert.glsl");  
  pointShader.set("resolution", (float)width, (float)height);
}

// This function is required. It takes care of preparing
// video frames for us as they arrive from the movie.
void movieEvent(Movie m) {
  m.read();
}

void draw() {
  // For each frame we draw a collection of dots
  // beginning at the center of the screen.
  
  // Pass the frame from the movie to the shader for sampling
  if (mov.available() == true) {
    pointShader.set("movieFrame", mov);
  }

  int x = width/2;
  int y = height/2;

  // We draw up to 100 dots (less if we touch the border of
  // the screen while moving in this loop).

  shader(pointShader, POINTS);

  for(int i=0; i<100; i++) {
    
    strokeWeight(10);
    point(x*2, y*2);
    resetShader();
    
    x = (int)random(width);
    y = (int)random(height);
  }
  //This was how we displayed the video as normal video.
  //image(mov, 0, 0, width, height);
}

// Press a key to save the current image
void keyPressed() {
  saveFrame();
}
