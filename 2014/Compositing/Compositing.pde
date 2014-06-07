

// Basic compositing and blending using PShader
// Adapted from http://www.w3.org/TR/compositing-1


// The shader that will contain the compositing code
PShader myShader;

// Textures
PImage sourceImage, backdropImage;

void setup() {

  size( 512, 512, P2D );
 
  // Load texture images
  sourceImage   = loadImage( "duck-with-alpha.png" );
  backdropImage = loadImage( "rainbow-background-with-alpha.png" );
 
  // Load the shader file from the "data" folder
  myShader = loadShader( "compositing.glsl" );
  
  // Pass the dimensions of the viewport to the shader
  myShader.set( "sketchSize", float(width), float(height) );
  
  // Pass the images to the shader
  myShader.set( "sourceImage", sourceImage ); 
  myShader.set( "backdropImage", backdropImage );

  // Pass the resolution of the images to the shader
  myShader.set( "sourceImageResolution", float( sourceImage.width ), float( sourceImage.height ) );
  myShader.set( "backdropImageResolution", float( backdropImage.width ), float( backdropImage.height ) );

}


void draw() {

  background(0);
  
  drawCheckerboard();
  
  // Apply the specified shader to any geometry drawn from this point  
  shader(myShader);

  // Draw the output of the shader onto a rectangle that covers the whole viewport
  rect(0, 0, width, height);

  // Call resetShader() so that further geometry remains unaffected by the shader
  resetShader();

}

// Draw checkerboard background
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
