PShader myShader;

// Mouse clicks
float left = 0.0, right = 0.0;

// Textures
PImage sourceImage, targetImage;

// Blend modes
static final int BL_DARKEN        =  0;
static final int BL_MULTIPLY      =  1;

static final int BL_COLORBURN     =  2;
static final int BL_LINEARBURN    =  3;
static final int BL_DARKERCOLOR   =  4;

static final int BL_LIGHTEN       =  5;
static final int BL_SCREEN        =  6;
static final int BL_COLORDODGE    =  7;
static final int BL_LINEARDODGE   =  8;
static final int BL_LIGHTERCOLOR  =  9;

static final int BL_OVERLAY       = 10;
static final int BL_SOFTLIGHT     = 11;
static final int BL_HARDLIGHT     = 12;
static final int BL_VIVIDLIGHT    = 13;
static final int BL_LINEARLIGHT   = 14;
static final int BL_PINLIGHT      = 15;
static final int BL_HARDMIX       = 16;

static final int BL_DIFFERENCE    = 17;
static final int BL_EXCLUSION     = 18;
static final int BL_SUBSTRACT     = 19;
static final int BL_DIVIDE        = 20;

static final int BL_HUE           = 21;
static final int BL_COLOR         = 22;
static final int BL_SATURATION    = 23;
static final int BL_LUMINOSITY    = 24;


void setup() {

  size( 512, 512, P2D );
 
  // Load texture images
  sourceImage = loadImage( "tex00.jpg" );
  targetImage = loadImage( "tex01.jpg" );
 
  // Load the shader file from the "data" folder
  myShader = loadShader( "shader.glsl" );
  
  // Pass the dimensions of the viewport
  myShader.set( "sketchSize", float(width), float(height) );
  
  // Pass the images to the shader
  myShader.set( "topLayer", sourceImage ); 
  myShader.set( "lowLayer", targetImage );

  // Pass the resolution of the images
  myShader.set( "topLayerResolution", float( sourceImage.width ), float( sourceImage.height ) );
  myShader.set( "lowLayerResolution", float( targetImage.width ), float( targetImage.height ) );

  // You can set the blend mode using the enum values
  myShader.set( "blendMode", BL_DIFFERENCE );
  
}


void draw() {

  // Switch mode every 20 frames
  if( frameCount % 30 == 0 ) {
    // You can also set the blend mode using a number from 0 to 24
    myShader.set( "blendMode", int( random(24) ) );
  }

  // Apply the specified shader to any geometry drawn from this point  
  shader(myShader);

  // Draw the output of the shader onto a rectangle that covers the whole viewport.
  rect(0, 0, width, height);  
  
}
