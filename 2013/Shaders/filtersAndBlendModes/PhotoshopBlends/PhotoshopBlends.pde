// The shader that will contain the blending code
PShader myShader;

// Textures
PImage sourceImage, targetImage;

// Let's give a name to each blend mode
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

// Start with that mode
int blendIndex = 0;

// Start looping through the modes?
boolean isPlaying = true;

// Let's store the names of the modes too
String[] blendNames = {
                        "Darken",
                        "Multiply",
                        "Color burn",
                        "Linear burn",
                        "Darker color",
                        "Lighten",
                        "Screen",
                        "Color dodge",
                        "Linear dodge",
                        "Lighter color",
                        "Overlay",
                        "Soft light",
                        "Hard light",
                        "Vivid light",
                        "Linear light",
                        "Pin light",
                        "Hard mix",
                        "Difference",
                        "Exclusion",
                        "Substract",
                        "Divide",
                        "Hue",
                        "Color",
                        "Saturation",
                        "Luminosity"
                      };

void setup() {

  size( 512, 512, P2D );
 
  // Load texture images
  sourceImage = loadImage( "tex00.jpg" );
  targetImage = loadImage( "tex01.jpg" );
 
  // Load the shader file from the "data" folder
  myShader = loadShader( "shader.glsl" );
  
  // Pass the dimensions of the viewport to the shader
  myShader.set( "sketchSize", float(width), float(height) );
  
  // Pass the images to the shader
  myShader.set( "topLayer", sourceImage ); 
  myShader.set( "lowLayer", targetImage );

  // Pass the resolution of the images to the shader
  myShader.set( "topLayerResolution", float( sourceImage.width ), float( sourceImage.height ) );
  myShader.set( "lowLayerResolution", float( targetImage.width ), float( targetImage.height ) );

  // You can set the blend mode using the name directly
  myShader.set( "blendMode", BL_DIFFERENCE );
  
}


void draw() {

  // Switch mode every 100 frames
  if( frameCount % 100 == 0 && isPlaying ) {
    // You can also set the blend modes using their index value (from 0 to 24)
    blendIndex = ( blendIndex + 1 ) % 24;
  }

  // How much of the top layer should be blended in the lower layer?
  float blendOpacity = float( mouseX ) / float( width );
  myShader.set( "blendAlpha", blendOpacity );

  // Pass the index of the blend mode to the shader
  myShader.set( "blendMode", blendIndex );

  // Apply the specified shader to any geometry drawn from this point  
  shader(myShader);

  // Draw the output of the shader onto a rectangle that covers the whole viewport
  rect(0, 0, width, height);

  // Call resetShader() so that further geometry remains unaffected by the shader
  resetShader();

  // Draw a nice backdrop for the text
  fill(255, 255, 255, 200);
  noStroke();
  rect(0,0,width,50);

  // Display the current blend mode
  pushStyle();
  textAlign(LEFT);
  textSize(20);
  fill(60);
  text( blendIndex + ") " + blendNames[ blendIndex ], 10, 30 );
  popStyle();

  pushStyle();
  textAlign(RIGHT);
  fill(150);
  textSize(20);
  text(" opacity: "+ floor(blendOpacity * 100) + "%", width - 10, 30);
  popStyle();

}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      blendIndex--;
    } else if (keyCode == DOWN) {
      blendIndex++;
    } 
  // wrap around
       if ( blendIndex > 24 ) blendIndex =  0;
  else if ( blendIndex <  0 ) blendIndex = 24;
  }
  else if ( key == ' ' ) {
    isPlaying = !isPlaying; // start & stop looping through modes
  }

}