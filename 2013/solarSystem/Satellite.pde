class Satellite  {
  PVector angle; //Using a PVector to track two angles!
  PVector velocity;
  PVector amplitude;
 
  Satellite()  {
    angle = new PVector();
    velocity = new PVector(random(-0.05,0.05),random(-0.05,0.05),random(-0.05,0.05)); // Random velocities and amplitudes
    amplitude = new PVector(random(width/2),random(height/2),random(height/2));
  }
 
  void orbit()  {
    angle.add(velocity);
  }
 
  void display(PGraphics left, PGraphics right)  {
    float x = sin(angle.x)*amplitude.x; // Oscillating on the x-axis
    float y = sin(angle.y)*amplitude.y; // Oscillating on the y-axis
    float z = sin(angle.y)*amplitude.z; // Oscillating on the y-axis
 
    left.pushMatrix();
    left.translate(width/2,height/2);
    left.stroke(0);
    left.fill(175);
    left.translate(x,y,z);
    left.sphere(30);
    left.popMatrix();
    
    right.pushMatrix();
    right.translate(width/2,height/2);
    right.stroke(0);
    right.fill(175);
    right.translate(x,y,z);
    right.sphere(30);
    right.popMatrix();
  }
}
