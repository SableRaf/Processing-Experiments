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

public class RDiffusion extends PApplet {

// Based on the RDiffusion sample from Cinder (http://libcinder.org/)

PImage substrate;    // Data buffer

PGraphics feedback;  // Image drawn onto by & re-fed to the shader every loop

PImage scene;        // Image to be displayed

PShader mShader;


boolean reactionStarted = false;

// Set the speed of the reaction (number of loops for each frame)

final int ITERATIONS = 25;


// Initial settings that will be passed to the shader as uniforms

float mReactionU = 0.25f;
float mReactionV = 0.04f;
float mReactionK = 0.047f;
float mReactionF = 0.1f;


public void setup() {

  size(512, 512, P2D);
  //size(displayWidth, displayHeight, P2D);
  
  noStroke();
  frameRate(60);

  // This will be the image used in our feedback loop
  feedback         = createGraphics(width, height, P2D);

  // This will be drawn on the screen
  scene = new PImage(width,height);
  
  // Our shader
  mShader = loadShader("gsrd_frag.glsl");

  // Load and pass the initial image to the shader 
  substrate = loadImage("seed.jpg");

}


public void draw() {

  // Start reaction
  if( !reactionStarted && frameCount > 5 ) {
    resetReaction();
    reactionStarted = true;
  }

  textureWrap(REPEAT);


  for(int i=0 ; i<ITERATIONS ; i++) {

    // Set the uniforms of the shader
    mShader.set( "texture",    feedback );
    mShader.set( "srcTexture", substrate );
    mShader.set( "ru",         mReactionU );
    mShader.set( "rv",         mReactionV );
    mShader.set( "k",          mReactionK );
    mShader.set( "f",          mReactionF );


    // Start drawing into the PGraphics object (note: PGraphics are image buffers. They are not drawn to the screen unless you ask)
    feedback.beginDraw();

    
    // Anything drawn between shader(yourShader) and resetShader() will be affected by that shader
    feedback.shader( mShader );

    
    // drawing an image makes it available for the shader as: uniform sampler2D texture;
    // we pass the previous result to the shader (this is the heart of the feedback loop)
    feedback.image( feedback, 0, 0, width, height ); 

    
    // Restore default Processing shaders so geometry drawn after is not affected by our custom shader
    feedback.resetShader();

    if(mousePressed) {
       feedback.pushStyle();
       feedback.fill( 255 );
       feedback.noStroke();
       feedback.ellipse( mouseX, mouseY, 100, 100 );
       feedback.popStyle();
    }

    
    // Unbind our PGraphics object
    feedback.endDraw();
  }
  
  // Map final image to screen size for display
  scene.copy( feedback, 0, 0, feedback.width, feedback.height, 0, 0, width, height );
    
  
  // Display result
  image( scene, 0, 0, width, height );
  
}

public void resetReaction() {
  feedback.beginDraw();
  feedback.image(substrate, 0, 0, width, height);
  feedback.endDraw();
}

public void keyPressed() {


  // Setup the parameters

  if(key=='u') mReactionU -= 0.01f;
  if(key=='j') mReactionU += 0.01f;

  if(key=='v') mReactionV -= 0.01f;
  if(key=='V') mReactionV += 0.01f;

  if(key=='k') mReactionK -= 0.001f;
  if(key=='K') mReactionK += 0.001f;

  if(key=='f') mReactionF -= 0.001f;
  if(key=='F') mReactionF += 0.001f;


  // Limit to known-good value ranges

  mReactionU = constrain(mReactionU, 0.0f, 0.4f);
  mReactionV = constrain(mReactionV, 0.0f, 0.4f);
  mReactionK = constrain(mReactionK, 0.0f, 1.0f);
  mReactionF = constrain(mReactionF, 0.0f, 1.0f);


  // Show in the console
  println("u="+mReactionU+" v="+mReactionV+" k="+mReactionK+" f="+mReactionF);

  if(key=='r' || key=='R') 
    resetReaction();
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "RDiffusion" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
