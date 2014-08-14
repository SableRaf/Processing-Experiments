import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class ShaderLiveCoding extends PApplet {


PShader shd_gradient;

boolean loaded = false;
boolean errorDisplayed = false;
 
String shaderFileName = "gradient.frag";
File shaderFile;

PGraphics scene;
PGraphics error;

// When was the file last modified?
long previousTimeStamp, timeStamp;

int reloadEvery = 60; // in frames

public void setup() {
	size(800,600,P2D);

  // Load the shader
  tryLoadingShader(shaderFileName);

  // Get the file we want to monitor for changes
  shaderFile = new File(dataPath(shaderFileName));

  // Initialize timestamps
  previousTimeStamp = shaderFile.lastModified();
  timeStamp = previousTimeStamp;
	
  // The shader and the error message are 
  // drawn on separate PGraphics
  scene = createGraphics(width,height,P2D);
  error = createGraphics(width,height,P2D);

}

public void draw() {

  // Try to reload the shader regularly
  if (frameCount % reloadEvery == 0) {
    frame.setTitle("frame: " + frameCount + " - fps: " + frameRate);  

    // Check that we do have a file at that path
    if(shaderFile.exists()){
      // Only reload if the file has changed
      if(isFileUpdated(shaderFile)){
        println("Shader file has changed. Updating.");
        tryLoadingShader(shaderFileName);
      }
    } 
    else {
      println("File not found:", shaderFile);
    }
  }

  if(loaded) {
    // Yes, the shader compiled

   	shd_gradient.set("vec2_mouse", PApplet.parseFloat(mouseX), PApplet.parseFloat(height-mouseY));

    scene.beginDraw();
   	scene.shader(shd_gradient);
   	scene.rect(0,0,width,height);
    scene.resetShader();
    scene.endDraw();

    image(scene,0,0);
  }
  else if (!errorDisplayed) {
    // No, the shader did not compile
  	displayError();
  }
  
}


public void tryLoadingShader(String shaderFilePath) {
  
  try {  
    shd_gradient = loadShader(shaderFilePath);
    
    // You have to set at least one uniform here to trigger syntax errors
    // see: https://github.com/processing/processing/issues/2268
    shd_gradient.set("vec2_sketchSize", PApplet.parseFloat(width), PApplet.parseFloat(height));
 
    loaded = true;
    errorDisplayed = false;
  } 
  
  catch (RuntimeException e) {    
    if(errorDisplayed == false) { 
      // String time = nf(str(hour()),2) + ":" + nf(str(minute()),2) + ":" + nf(str(second()),2);
      println("\n");
      // println("At", time, "loadShader() returned the following error: \n");
      println("loadShader() returned the following error: \n");
      e.printStackTrace(); 
    }
    loaded = false;
  }
}

public void displayError() {

  error.beginDraw();
  error.pushStyle();
  error.pushMatrix();

  error.noStroke();
  error.fill(255, 255, 255, 100);
  error.rect(0,0,width,height);

  error.stroke(255);
  error.fill(255, 0, 0);

  error.textAlign(CENTER);
  error.textSize(18);
  error.text("Error compiling the shader.", width/2 , height/2 - 15);
  error.text("Check the console for details.", width/2 , height/2 + 15);

  error.popMatrix();
  error.popStyle();
  error.endDraw();

  image(error,0,0);

  errorDisplayed = true;
}


private boolean isFileUpdated( File file ) {

  //print("Previous file timestamp:", timeStamp, " ");

  long previousTimeStamp = timeStamp;
  timeStamp = file.lastModified();

  //println("New timestamp:", timeStamp, " File:", file);

  if( timeStamp != previousTimeStamp ) {
    previousTimeStamp = timeStamp;
    //Yes, file is updated
    return true;
  }
  //No, file is not updated
  return false;
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "ShaderLiveCoding" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
