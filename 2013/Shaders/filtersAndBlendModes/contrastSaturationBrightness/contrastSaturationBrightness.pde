import processing.video.*;

// The capture device
Capture video;

// Some variables for the capture initialization
Boolean isInit   = false;
Boolean hasVideo = false;

PShader myFilter;

PImage myTexture;


void setup() {

  size( 512, 512, P2D );
  
  myTexture = loadImage( "texture.jpg" );
  
  myFilter = loadShader( "shader.glsl" );

}


void draw() {

  background(0);
  
  // For all settings: 1.0 = 100% 0.5=50% 1.5 = 150%
  float c = 1.0;
  float s = mouseX / (float) width  * 1.5;
  float b = mouseY / (float) height * 1.5;

  myFilter.set( "contrast",   c );
  myFilter.set( "saturation", s );
  myFilter.set( "brightness", b );

  image( myTexture, 0, 0 );

  filter( myFilter );

}


void initCamera() {

  String[] cameras = Capture.list();

  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } 
  else {
    //println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      // println(cameras[i]);
    }

    // The camera can be initialized directly using an element
    // from the array returned by list():
    video = new Capture(this, cameras[0]);
    
    // Start capturing the images from the camera
    video.start();
  }

}

