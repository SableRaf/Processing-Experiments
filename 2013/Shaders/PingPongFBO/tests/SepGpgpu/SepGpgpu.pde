/**
 * Separate Blur Shader
 * 
 * This blur shader works by applying two successive passes, one horizontal
 * and the other vertical.
 * 
 * Press the mouse to switch between the custom and default shader.
 */

PShader ripple;
PGraphics src;
PGraphics pass1, pass2;

PVector pixelSize; // dimension of the pixel in [0,0]-[1,1]

void setup() {
  size(640, 640, P2D);
  
  ripple = loadShader("gpgpu_frag.glsl");
  
  pixelSize = new PVector(1.0/width, 1.0/height); // dimension of the pixel in [0,0]-[1,1]
  ripple.set("pixel", pixelSize.x, pixelSize.y);
  
  src = createGraphics(width, height, P2D); 
  
  pass1 = createGraphics(width, height, P2D);
  pass1.noSmooth();  
  
  pass2 = createGraphics(width, height, P2D);
  pass2.noSmooth();
}

void draw() {
  src.beginDraw();
  src.background(0);
  src.fill(255,0,0);
  src.ellipse(random(width), random(height), 100, 100);
  src.endDraw();
      
  pass1.beginDraw();            
  pass1.shader(ripple);  
  pass1.image(src, 0, 0);
  pass1.endDraw();

  pass2.beginDraw();            
  pass2.shader(ripple);  
  pass2.image(pass1, 0, 0);
  pass2.endDraw();  
        
  image(pass2, 0, 0);   
}
