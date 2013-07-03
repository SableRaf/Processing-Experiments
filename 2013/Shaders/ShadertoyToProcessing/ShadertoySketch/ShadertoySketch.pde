PShader myShader;

// Mouse clicks
float left = 0.0, right = 0.0;


void setup() {
  size(640, 360, P2D);
 
  // Load the shader file from the "data" folder
  myShader = loadShader("shader.glsl");
  
  // Pass the dimensions of the viewport
  myShader.set("iResolution", float(width), float(height));
  
}


void draw() {
  
  // Set the time in seconds
  myShader.set("iGlobalTime", millis()/1000.0);
  
  // Set mouse position and button clicks
  if(mousePressed) {
    if(mouseButton == LEFT)  left = 1.0;
    else                     left = 0.0;
    
    if(mouseButton == RIGHT) right = 1.0;
    else                     right = 0.0;
    
    myShader.set("iMouse", float(mouseX), float(mouseY), left, right);
  }

  // Apply the specified shader to any geometry drawn from this point  
  shader(myShader);

  // Draw the output of the shader onto a rectangle that covers the whole viewport.
  rect(0, 0, width, height);  
  
}
