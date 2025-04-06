
/* 
TO DO:
- Keyboard input
- Sound input

DOCUMENTATION:
// Input - Keyboard    : https://www.shadertoy.com/view/lsXGzf
// Input - Microphone  : https://www.shadertoy.com/view/llSGDh
// Input - Mouse       : https://www.shadertoy.com/view/Mss3zH
// Input - Sound       : https://www.shadertoy.com/view/Xds3Rr
// Input - SoundCloud  : https://www.shadertoy.com/view/MsdGzn
// Input - Time        : https://www.shadertoy.com/view/lsXGz8
// Input - TimeDelta   : https://www.shadertoy.com/view/lsKGWV
// Input - 3D Texture  : https://www.shadertoy.com/view/4llcR4

NOTES:

*/

PShader myShader;

// uniform float     iChannelTime[4];       // channel playback time (in seconds)
// uniform vec3      iChannelResolution[4]; // channel resolution (in pixels)

// uniform samplerXX iChannel0..3;          // input channel. XX = 2D/Cube

float previousTime = 0.0;

boolean mouseDragged = false;

PVector lastMousePosition;
float mouseClickState = 0.0;

void setup() {
  size(640, 360, P2D);
  
  // Load the shader file from the "data" folder
  myShader = loadShader("defaultShader.glsl");
  //myShader = loadShader("input_time.glsl");
  //myShader = loadShader("input_timeDelta.glsl");
  //myShader = loadShader("oldWatch.glsl");
  
  // We assume the dimension of the window will not change over time, 
  // therefore we can pass its values in the setup() function  
  myShader.set("iResolution", float(width), float(height), 0.0);
  
  lastMousePosition = new PVector(float(mouseX),float(mouseY));
}


void draw() {
  
  // shader playback time (in seconds)
  float currentTime = millis()/1000.0;
  myShader.set("iTime", currentTime);
  
  // render time (in seconds)
  float timeDelta = currentTime - previousTime;
  previousTime = currentTime;
  myShader.set("iDeltaTime", timeDelta);
  
  // shader playback frame
  myShader.set("iFrame", frameCount);
  
  // mouse pixel coords. xy: current (if MLB down), zw: click
  if(mousePressed) { 
    lastMousePosition.set(float(mouseX),float(mouseY));
    mouseClickState = 1.0;
  } else {
    mouseClickState = 0.0;
  }
  myShader.set( "iMouse", lastMousePosition.x, lastMousePosition.y, mouseClickState, mouseClickState);

  // Set the date
  // Note that iDate.y and iDate.z contain month-1 and day-1 respectively, 
  // while x does contain the year (see: https://www.shadertoy.com/view/ldKGRR)
  float timeInSeconds = hour()*3600 + minute()*60 + second();
  myShader.set("iDate", year(), month()-1, day()-1, timeInSeconds );  

  // This uniform is undocumented so I have no idea what the range is
  myShader.set("iFrameRate", frameRate);
  
  println(frameRate);

  // Apply the specified shader to any geometry drawn from this point  
  shader(myShader);

  // Draw the output of the shader onto a rectangle that covers the whole viewport.
  rect(0, 0, width, height);
  
  resetShader();
  
}
