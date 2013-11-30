

PShader myShader;

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

  // Set the date (I'm not sure what the actual range should be for these values)
  float timeInSeconds = hour()*3600 + minute()*60 + second();
  myShader.set("iDate", year(), month(), day(), timeInSeconds );

  // Apply the specified shader to any geometry drawn from this point  
  shader(myShader);

  // Draw the output of the shader onto a rectangle that covers the whole viewport.
  rect(0, 0, width, height);  
  
}

// New mouse coords are passed to the shader only when a button is clicked...
void mousePressed() {
  myShader.set( "iMouse", float(mouseX), float(mouseY), 1.0, 1.0 ); // setting iMouse.zw values to 1.0 means "clicked"
}

// They keep being updated as the mouse is dragged...
void mouseDragged() {
  myShader.set( "iMouse", float(mouseX), float(mouseY), 1.0, 1.0 );
}

// But stop being sent when you release the mouse button
void mouseReleased() {
  myShader.set( "iMouse", float(mouseX), float(mouseY), 0.0, 0.0 ); // setting iMouse.zw values to 0.0 means "not clicked"
}

