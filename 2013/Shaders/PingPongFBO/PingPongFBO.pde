
// FBO ping pong demo based on the tutorial by Ban the Rewind
// http://www.bantherewind.com/wrap-your-mind-around-your-gpu
// Ported to Processing by Raphaël de Courville <twitter.com/sableRaph>

// see also: http://www.comp.nus.edu/~ashwinna/docs/PingPong_FBO.pdf

/*
* Copyright (c) 2012, Ban the Rewind
* All rights reserved.
* 
* Redistribution and use in source and binary forms, with or 
* without modification, are permitted provided that the following 
* conditions are met:
* 
* Redistributions of source code must retain the above copyright 
* notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright 
* notice, this list of conditions and the following disclaimer in 
* the documentation and/or other materials provided with the 
* distribution.
* 
* Neither the name of the Ban the Rewind nor the names of its 
* contributors may be used to endorse or promote products 
* derived from this software without specific prior written 
* permission.
* 
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
* "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
* LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS 
* FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE 
* COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, 
* INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
* BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; 
* LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER 
* CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, 
* STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
* ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF 
* ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
* 
*/

PImage image; // Source texture to be refracted
PImage scene; // Image to be displayed

PShader rippleShader, refractionShader;

PShader testShader;

PVector pixelSize; // dimension of the pixel in [0,0]-[1,1]

PGraphics ping, pong;

PGraphics testScene;

boolean isRefraction = true;

void setup() {
  size(1024, 768, P2D);
  noStroke();
  frameRate(60);
  
  ping = createGraphics(width, height, P2D);
  pong = createGraphics(width, height, P2D);

  testScene = createGraphics(width, height, P2D);
  
  scene = new PImage(width,height);
  
  // Set ping and pong to black for the first pass
  ping.beginDraw();
  ping.background(0);
  ping.endDraw();
  
  pong.beginDraw();
  pong.background(0);
  pong.endDraw();
  
  rippleShader = loadShader("gpgpu_frag.glsl", "passThru_vert.glsl");
  refractionShader = loadShader("refraction_frag.glsl", "passThru_vert.glsl");
  
  pixelSize = new PVector(1.0/width, 1.0/height); // dimension of the pixel in [0,0]-[1,1]
  rippleShader.set("pixel", pixelSize.x, pixelSize.y);
  refractionShader.set("pixel", pixelSize.x, pixelSize.y);
  
  image = loadImage("texture.jpg");
    
  println("setup() finished ok");
}

void draw() {
  background(0,255,0);
  
  // Animate
  
  int x = (int)random(width);
  int y = (int)random(height);
  
  pong.beginDraw();
  noStroke();
  fill(255,0,0);
  ellipse(width*.5,height*.5,20,20);
  ellipse(x,y,10,10);
  shader(rippleShader);
  rippleShader.set("buffer", ping); // we want to write on the previous result
  rect(0, 0, width, height); // Draw the shader result on this window-sized rectangle
  resetShader(); // Restore the default shaders
  pong.endDraw();
  
  ping.beginDraw();
    // Refract
  shader(refractionShader);
  refractionShader.set("buffer", pong); // set current pong as refraction map
  refractionShader.set("tex", image);   // set source image to refract
  rect(0, 0, width, height);
  resetShader(); // Restore the default shaders
  ping.endDraw();

  // Copy to final scene texture
  if(isRefraction) {
    scene.copy(ping, 0, 0, width, height, 0, 0, width, height);
  }
  else {
    scene.copy(pong, 0, 0, width, height, 0, 0, width, height);
  }
    
  // Display result
  image(scene, 0, 0, width, height);
}

void keyReleased() {
  if(key == 'i') {
    isRefraction = !isRefraction; // toggle the refraction shader pass
    if(isRefraction)
      println("Showing ping. isRefraction = "+isRefraction);
    else
      println("Showing pong. isRefraction = "+isRefraction);
  }
}

