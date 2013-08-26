/**
 * Getting Started with Capture.
 * 
 * Reading and displaying an image from an attached Capture device. 
 */

import processing.video.*;

Capture cam;

PShader pointShader;

int numPoints = 100;

void setup() {
  size(640, 480, P2D);
  
  // Load shader file
  pointShader = loadShader("pointfrag.glsl", "pointvert.glsl");  
  pointShader.set("sharpness", 0.9);
  
  strokeCap(SQUARE);

  String[] cameras = Capture.list();

  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } 
  else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }

    // The camera can be initialized directly using an element
    // from the array returned by list():
    cam = new Capture(this, cameras[0]);
    // Or, the settings can be defined based on the text in the list
    //cam = new Capture(this, 640, 480, "Built-in iSight", 30);
    
    // Start capturing the images from the camera
    cam.start();
  }
}

void draw() {
  if (cam.available() == true) {
    cam.read();
  }
  
  println("1 (cam.width = "+cam.width+" | cam.height = "+cam.height+")");
  
  shader(pointShader, POINTS);
  
  println("2");
  
  for(int i = 0; i<numPoints; i++) {
    println("3");
    
    int xPoint = (int)random(cam.width);
    int yPoint = (int)random(cam.height);
    
    println("4 (xPoint = "+xPoint+" | yPoint = "+yPoint+")");
    
    float w = random(5, 10);
    pointShader.set("weight", w);
    strokeWeight(w);
    
    println("5");
    
    int pxIndex = coordToIndex(cam, xPoint, yPoint);
    
    println("6 (pxIndex = "+pxIndex+")");
    
    color pix = cam.pixels[pxIndex];
    
    println("7");
    
    int r = (pix >> 16) & 0xFF;  // Faster way of getting red(pix)
    int g = (pix >> 8) & 0xFF;   // Faster way of getting green(pix)
    int b = pix & 0xFF;          // Faster way of getting blue(pix)
    
    stroke(r,g,b);  
    point(xPoint, yPoint);
  }
  
  resetShader();
  
  //image(cam, 0, 0);
  
  // The following does the same as the above image() line, but 
  // is faster when just drawing the image without any additional 
  // resizing, transformations, or tint.
  //set(0, 0, cam);
}

// Get the pixel index for a given set of coordinates
int coordToIndex(PImage img, int x, int y) {
  if(!(x<=img.width)) {
    println("Error in coordToIndex: X coordinate ["+x+"] is larger than the width of the image ["+img.width+"] ");
    return 0;
  }
  if(!(y<=img.height)) {
    println("Error in coordToIndex: Y coordinate ["+y+"] is larger than the height of the image ["+img.height+"] ");
    return 0;
  }
  
  int index = y * img.width + x;
  
  return index;
  
}

