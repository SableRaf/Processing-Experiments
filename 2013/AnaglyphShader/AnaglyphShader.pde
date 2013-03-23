// Optimised anaglyph shader by John Einselen
// http://iaian7.com/quartz/AnaglyphCompositing

// Simple anaglyph shader by r3dux
// http://r3dux.org/2011/05/anaglyphic-3d-in-glsl/

// Adapted for Processing by Raphaël de Courville 
// Twitter: @sableRaph

// Photo by Hiroshi Yoshinaga
// http://www.flickr.com/photos/parallel_yoshing/4429541662/

// SPACE: switch between the two anaglyph modes
// X: switch 3D on/off

boolean isShader = true;
boolean isOptimised = true;

PShader simple_anaglyph, optimised_anaglyph;
PImage leftEye, rightEye;

Float contrast = 0.4; // lets us adjust the apparent colour saturation (based on the contrast between channels) better left between 0.5 and 1.0
Float deghost = 0.6;  // Amount of deghosting (via channel subtraction)
Float stereo = 0.0;   // allows for small alignment adjustments to the images

void setup() {
  leftEye = loadImage("img_left.png");
  rightEye = loadImage("img_right.png");
  
  int w = leftEye.width;
  int h = leftEye.height;
  size(w, h, P2D);

  simple_anaglyph = loadShader("simple_anaglyph.glsl");
  optimised_anaglyph = loadShader("optimised_anaglyph.glsl");
}

void draw() {
  
  PShader s;
  
  s = simple_anaglyph;
  
  if(isOptimised) { 
    s = optimised_anaglyph; 
    s.set("Contrast", contrast);
    s.set("Deghost", deghost);
    s.set("Stereo", stereo);
  }
  
  s.set("Left", leftEye);
  s.set("Right", rightEye);
  
  if(isShader) 
    shader(s);
  
  image(rightEye,0,0,width,height); // Any image will do but we have to call the function

  resetShader();
}

void keyPressed() {
 if(key == ' ') { 
   isOptimised = !isOptimised; 
   println("isOptimised = "+ isOptimised);
 }
 else if (key == 'x' || key == 'X') { 
   isShader = !isShader; 
   println("isShader = "+ isShader);
 }
}
