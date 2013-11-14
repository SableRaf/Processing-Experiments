

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
  float s = map( mouseX / (float) width,  0.0, 1.0, 0.0, 1.5 );
  float b = map( mouseY / (float) height, 0.0, 1.0, 0.3, 1.5 );

  myFilter.set( "contrast",   c );
  myFilter.set( "saturation", s );
  myFilter.set( "brightness", b );

  image( myTexture, 0, 0 );

  filter( myFilter );

}
