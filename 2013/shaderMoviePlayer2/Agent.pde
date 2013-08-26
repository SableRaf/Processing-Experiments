
class Agent {
  PVector pos;
  int step = 40;
  
  Agent(){
    pos = new PVector(width/2, height/2);
  }
  
  void move() {
    pos.x += random(-step, step);
    pos.y += random(-step, step);
    bind();
  }
  
  int getX() {
    return (int)pos.x;
  }
  
  int getY() {
    return (int)pos.y;
  }
 
  void wrap() {
    if(pos.x > width) {
      pos.x = 0;
    }
    if(pos.x < 0) {
      pos.x = width; 
    }
    if(pos.y > height) {
      pos.y = 0;
    }
    if(pos.y < 0) {
      pos.y = height; 
    }
  }
  
  // Prevent the agent from crossing the limits of the screen
  void bind() {
    pos.x = constrain(pos.x, 0, width);
    pos.y = constrain(pos.y, 0, height);
  }
 
}
