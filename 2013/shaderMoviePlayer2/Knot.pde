class Knot extends PVector {
  
  float size;
  color col;
  float angle;  
  float noiseDepth; // for spray pattern generation
  float timestamp;  // for replay
  PGraphics targetBuffer;

  boolean isDrawn = false;
  
  Knot(float x, float y, float weight, color tint) {
    super(x, y);
    size  = weight;
    col   = tint;
    angle = 0.0;
    noiseDepth = random(1.0);
    timestamp  = millis();
  }
  
  PVector getPos() {
    return new PVector(x,y);
  }
  
  float getSize() {
    return size;
  }
  
  color getColor() {
    return col; 
  }
  
  void setBuffer(PGraphics target) {
    targetBuffer = target;
  }
  
  PGraphics getBuffer() {
    return targetBuffer; 
  }
  
  void draw(PGraphics targetBuffer) {
    
    float x = this.x;
    float y = this.y;
    
    PVector dir = new PVector(x, y);
    dir.normalize();

    if(!isDrawn) {
      pointShader.set( "weight", size );
      pointShader.set( "direction", dir.x, dir.y );
      pointShader.set( "rotation", random(0.0,1.0), random(0.0,1.0) );
      pointShader.set( "scale", 0.3 ); 
      pointShader.set( "soften", 1.0 ); // towards 0.0 for harder brush, towards 2.0 for lighter brush
      pointShader.set( "depthOffset", noiseDepth );
      
      
      // Draw in the buffer (if one was defined) or directly on the viewport
      if (null!=targetBuffer)  {
        // println("drawing");
        targetBuffer.strokeWeight(size);
        targetBuffer.stroke(col);
        targetBuffer.shader(pointShader, POINTS);
        targetBuffer.point(x,y); 
      }
      //else                      point(x,y);
      
      //targetBuffer.resetShader();
      
      isDrawn = true;
    }
    
    if(debug) {
      pushMatrix();
        pushStyle();
          fill(255,0,0);
          noStroke();
          translate(x,y);
          ellipse(0,0,5,5);
        popStyle();
      popMatrix();
    }
    
  }

}
