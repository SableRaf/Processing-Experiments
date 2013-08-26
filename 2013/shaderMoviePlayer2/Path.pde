
// The Path object contains a list of points

class Path {
  
  PGraphics targetBuffer;
  
  ArrayList<Knot> pointList;       // raw point list
  
  Knot previousKnot;
  Knot currentKnot;
  
  float mag;
  float numSteps;
  float distMin = 0;
  float stepSize = 1;
  
  Path() {
  }

  Path(Knot startingPoint) {
    add(startingPoint);
  }
  
  
  Path(Knot startingPoint, float d) {
    stepSize = d;
    add(startingPoint);
  }
  
  
  void setBuffer(PGraphics target) {
    targetBuffer = target;
  }
  
  
  void add(Knot k) {
    
    if( null != targetBuffer) 
      k.setBuffer(targetBuffer);
      
    if( null == pointList ) {
      createList(k);
    }
    else {
      newKnot(k);
    }
    
  }
  
  
  // When the first knot is added, we want to create the list
  void createList(Knot k) {
    
    previousKnot = k;
    currentKnot  = k;
    
    if( null == pointList ) pointList = new ArrayList<Knot>();
    
    pointList.add(previousKnot);
    pointList.add(currentKnot);
  }
  
  
  // Add a new knot and all knots between it and 
  // the previous knot, based on the defined step size
  void newKnot(Knot k) {
    
    int size = pointList.size();

    previousKnot = pointList.get(size-1);
    currentKnot = k;
    
    // Compute the vector from previous to current knot
    PVector prevPos = previousKnot.getPos();
    PVector newPos  = currentKnot.getPos();
    PVector velocity = PVector.sub(newPos, prevPos);
 
    // How many points can we fit between the two last knots?
    float mag = velocity.mag();
    
    // Create intermediate knots and pass them interpolated parameters
    if( mag > stepSize ) {
      
      numSteps = mag/stepSize;
      for(int i=1; i<numSteps; i++ ) {
        
        float interpolatedX = lerp ( previousKnot.x,  currentKnot.x,  i/numSteps );
        float interpolatedY = lerp ( previousKnot.y,  currentKnot.y,  i/numSteps );
        
        float interpolatedSize  = lerp      ( previousKnot.getSize(),  currentKnot.getSize(),  i/numSteps );
        color interpolatedColor = lerpColor ( previousKnot.getColor(), currentKnot.getColor(), i/numSteps );
        
        Knot stepKnot = new Knot(interpolatedX, interpolatedY, interpolatedSize, interpolatedColor);
        
        pointList.add(stepKnot);
        
      }
    }
    else {
      pointList.add(currentKnot);
    }
    
  }
  
  
  void draw(PGraphics buffer) {
    for(Knot p: pointList) {
      p.draw(buffer);
    }
  }
  
  
  void clear() {
    pointList.clear();
  }
  
}
