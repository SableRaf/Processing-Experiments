PShader myShader;

// Mouse clicks
float left = 0.0, right = 0.0;

// Textures
PImage tex00, tex01;

void setup() {
  size(512, 512, P2D);
 
  // Load texture images
  tex00 = loadImage("tex00.jpg");
  tex01 = loadImage("tex01.jpg");
 
  // Load the shader file from the "data" folder
  myShader = loadShader("shader.glsl");
  
  // Pass the dimensions of the viewport
  myShader.set("iResolution", float(width), float(height));
  
  // Pass the textures
  myShader.set("iChannel0",tex00); 
  myShader.set("iChannel1",tex01);
 
  
  float[] channelRes = { 
                      512., 512., // tex00
                      512., 512.  // tex01
                     };
 
  // Pass the resolution of each texture
  myShader.set("iChannelResolution", channelRes, 2); 
  
}


void draw() {

  // Apply the specified shader to any geometry drawn from this point  
  shader(myShader);

  // Draw the output of the shader onto a rectangle that covers the whole viewport.
  rect(0, 0, width, height);  
  
}
