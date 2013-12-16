
// Shader livecoding sketch based on a code by Andrés Colubri
// http://forum.processing.org/two/discussion/1877/pseudo-live-coding-shaders-idea#Item_2

// Launch this sketch and edit the shader file in /data

PShader myShader;
boolean loaded = false;

boolean errorDisplayed;
 
String shaderFileName = "shader.glsl";

int reloadEvery = 60; // in frames
 
 
void setup() {
  size(640, 360, P2D);
  tryLoadShader();
}

 
void draw() {
  
  // Try to reload the shader regularly
  if (frameCount % reloadEvery == 0) {
    tryLoadShader();
  }
 
  // In case of error in the shader
  // display a red rectangle around the sketch
  if (!loaded && !errorDisplayed) {
    resetShader();
   
    noStroke();
    fill(255, 255, 255, 100);
    rect(0,0,width,height);

    stroke(255);
    fill(255, 0, 0);
    textAlign(CENTER);
    textSize(18);
    text("Error compiling the shader.", width/2 , height/2 - 15);
    text("Check the console for details.", width/2 , height/2 + 15);

    errorDisplayed = true;
    
    return;
  }
  
  // Set your other uniforms here
  // myShader.set("time", millis() / 1000.0);
  
  // Compute the shader and 
  // draw the output on a quad that covers the sketch window
  shader(myShader);
  rect(0, 0, width, height);
  
}
 
void tryLoadShader() {
  try {  
    myShader = loadShader( shaderFileName );
    // You have to set at least one uniform here to trigger syntax errors
    myShader.set("resolution", float(width), float(height));    
    loaded = true;
    errorDisplayed = false;
  } catch (RuntimeException e) {
    e.printStackTrace();
    loaded = false;
  }
}
