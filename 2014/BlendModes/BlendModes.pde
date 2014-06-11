
// Adaptation of the original "Photoshop Blends" shader 
// by ben: https://www.shadertoy.com/view/XdS3RW 

// Ported to Processing by Raphaël de Courville <Twitter: @sableRaph>
// - added support for transparency

// Compositing formulas from http://www.w3.org/TR/compositing-1

// Controls: 
//  'SPACE': Play/Pause looping through blend modes
//  'G':     Display/Hide GUI
//  'UP':    Select previous blend mode
//  'DOWN':  Select next blend mode

// Note: blendMode() should be faster in most cases
// since it is based on the built-in OpenGL glBlendFunc
// Source: https://stackoverflow.com/questions/7054538/custom-glblendfunc-a-lot-slower-than-native

// TO DO:
//       - fix odd looking blend modes (see photoshop_ref for reference)


// Textures
PImage sourceImage, backdropImage;

// Active blend mode
int blendIndex = 0;

// How many modes do we have? (minus one)
int maxIndex = 24;

// Show the GUI by default?
boolean isGUI = true;

// Active shader
PShader myShader;

// Start looping through the modes?
boolean isPlaying = true;

// Where are our files stored within the "data" folder
String shaderSubDirectory = "glsl/";
String textureSubDirectory = "textures/";

// Let's store the names of all our blend modes
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

// Let's store the names of the shader files too
String[] blendFilenames = { 
                          "darken.glsl",
                          "multiply.glsl",

                          "colorBurn.glsl",
                          "linearBurn.glsl",
                          "darkerColor.glsl",

                          "lighten.glsl",
                          "screen.glsl",
                          "colorDodge.glsl",
                          "linearDodge.glsl",
                          "lighterColor.glsl",

                          "overlay.glsl",
                          "softLight.glsl",
                          "hardLight.glsl",
                          "vividLight.glsl",
                          "linearLight.glsl",
                          "pinLight.glsl",
                          "hardMix.glsl",

                          "difference.glsl",
                          "exclusion.glsl",
                          "subtract.glsl",
                          "divide.glsl",

                          "hue.glsl", 
                          "color.glsl",
                          "saturation.glsl",
                          "luminosity.glsl"
                          };

// Let's give a legible name to each index
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

// List of the PShader objects containing the compositing code
ArrayList<PShader> blendModes;

void setup() {

  size( 512, 512, P2D );
  
  // Load texture images
  sourceImage   = loadImage( textureSubDirectory + "duck-with-alpha.png" );
  backdropImage = loadImage(  textureSubDirectory + "rainbow-background-with-alpha.png" );

  // Instanciate the list of shader files
  blendModes = new ArrayList<PShader>();
  
  // Load the shader files for each blend mode
  for(int i=0; i< blendFilenames.length; i++) {
    String filePath = shaderSubDirectory + blendFilenames[i];
    
    PShader s = loadShader(filePath);
    
    // Pass the size of the viewport to the shader
    s.set( "sketchSize", float(width), float(height) );
  
    // Pass the images to the shader
    s.set( "sourceImage", sourceImage ); 
    s.set( "backdropImage", backdropImage );
  
    // Pass the resolution of the images to the shader
    s.set( "sourceImageResolution", float( sourceImage.width ), float( sourceImage.height ) );
    s.set( "backdropImageResolution", float( backdropImage.width ), float( backdropImage.height ) );

    blendModes.add(s);
  }
 
  setBlendMode(blendIndex);
 
}

void draw() {
  
  drawCheckerboard();

  // Switch mode every 100 frames
  if(isPlaying && frameCount % 100 == 0) {
    // You can also set the blend modes using their index value (from 0 to 24)
    blendIndex = ( blendIndex + 1 ) % maxIndex;
    setBlendMode(blendIndex);
  }
  
  // Apply the specified shader to any geometry drawn from this point  
  shader(myShader);

  // Draw the output of the shader onto a rectangle that covers the whole viewport
  rect(0, 0, width, height);

  // Call resetShader() so that further geometry remains unaffected by the shader
  resetShader();
  
  // Display the GUI ( press G to hide/show )
  if(isGUI) {
    // Draw a nice backdrop for the text
    fill(255, 255, 255, 150);
    noStroke();
    rect(0,0,width,50);

    // Display the current blend mode
    pushStyle();
    textAlign(LEFT);
    textSize(20);
    fill(60);
    text( blendIndex + ") " + blendNames[ blendIndex ], 10, 30 );
    popStyle();
  }

}

void setBlendMode(int i) {
  myShader = blendModes.get(i);
}

void drawCheckerboard() {
  
  float row = 64;
  float squareSize = height / row;
  float col = width / squareSize;
  
  pushMatrix();
  
  pushStyle();
  
  noStroke();
  
  for(int i = 0; i <= row; i++) {
    
    pushMatrix();
    for(int j = 0; j <= col; j++) {
      
      // Alternate between white and grey
      if(i%2 == 1) {
        if( j%2 == 1 ) { fill(200); }
        else { fill(255); }
      }
      else {
        if( j%2 == 1 ) { fill(255); }
        else { fill(200); }
      }
      
      rect(0, 0, squareSize, squareSize);
      
      translate(squareSize, 0);
    }
    popMatrix();
    
    translate(0, squareSize);
  }
  
  popStyle();
  
  popMatrix();
  
}

// Handle keyboard input
void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      blendIndex--;
    } else if (keyCode == DOWN) {
      blendIndex++;
    } 
  // wrap around
       if ( blendIndex > maxIndex ) { blendIndex =  0; }
  else if ( blendIndex <  0 ) { blendIndex = maxIndex; }
  
  // Update the active shader
  setBlendMode(blendIndex);
  }
  
  else if ( key == ' ' ) {
    isPlaying = !isPlaying; // start & stop looping through modes
  }
  else if ( key == 'g' || key == 'G') {
    isGUI = !isGUI;
  }
}
