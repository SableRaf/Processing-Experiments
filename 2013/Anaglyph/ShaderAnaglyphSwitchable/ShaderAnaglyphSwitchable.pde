// 3D Fish & deghost shader code by John Einselen
// http://iaian7.com/quartz/AnaglyphCompositing

// Simple shader code by r3dux
// http://r3dux.org/2011/05/anaglyphic-3d-in-glsl/

// Adapted for Processing by Raphaël de Courville 
// Twitter: @sableRaph

PShader anaglyph_simple, anaglyph_advanced;
PImage leftEye, rightEye, test;

Float contrast = 0.7; // lets us adjust the apparent colour saturation (based on the contrast between channels)
Float deghost = 0.6; //
Float stereo = 0.0; // allows for small alignment adjustments to the images

void setup() {
  
  leftEye = loadImage("VectorformFish_Left.png");
  rightEye = loadImage("VectorformFish_Right.png");
  
  //leftEye = loadImage("leftPittsburgh.png");
  //rightEye = loadImage("rightPittsburgh.png");
  
  test = loadImage("VectorformFish_test.png");
  
  int w = leftEye.width;
  int h = leftEye.height;
  size(w, h, P2D);
  
  anaglyph_simple = loadShader("simple_anaglyph.glsl");
  anaglyph_advanced = loadShader("deghost_anaglyph.glsl");
  
  //anaglyph.set("resolution", float(width), float(height));
}

void draw() {
  
  PShader s = anaglyph_simple;
  
  if (mousePressed) {
  s = anaglyph_advanced;
  s.set("Contrast", contrast);
  s.set("Deghost", deghost);
  s.set("Stereo", stereo); 
  }
  
  s.set("Left", leftEye);
  s.set("Right", rightEye);
  
  shader(s);
  
  image(test,0,0,width,height);

  resetShader();
}
