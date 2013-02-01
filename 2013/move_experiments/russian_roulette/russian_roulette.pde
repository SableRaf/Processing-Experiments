// Russian roulette prototype

import io.thp.psmove.*;
import java.util.Set;

boolean isRoulette = true;   // Are we in soviet russia?
int numBullets = 1;          // How many bullets do we want to play with?
int magazineSize = 6;        // Default is 6, obviously

GunManager gunManager;

color sphereColor;
boolean triggerReady = true;

void setup() {
  size(200,200);
  gunManager = new GunManager(magazineSize);
  sphereColor = color(255,0,0);
}

void draw() {
  background(155);
    
  // Provided we have an active gun...
  if(gunManager.isInit()) {
    
    gunManager.update();
    
    // Visual feedback on the firing
    if(gunManager.isFiring())
      background(random(100,255));
    
    if(gunManager.gun.isMovePressedEvent())
      gunManager.arm();
      
    if(gunManager.gun.isCrossPressedEvent())
      gunManager.setupRoulette(numBullets); // (re)set the roulette game
    
    // Trigger
    if(gunManager.isClick())
      gunManager.fire(300);
    
    // Show the orientation of the gun
    float angle = gunManager.getAngle();
    displayAngle(angle);
    
    gunManager.display();
  }
  // Otherwise, we try to activate the gun
  else {
    gunManager.waitForGun();
  }
}

void displayAngle(float angle) {
  fill(50);
  ellipse(width/2,height/2,width*.99f,height*.99f);
  pushMatrix();
  noStroke();
  fill(100);
  translate(width/2, height/2);
  scale(width*.05);
  rotate(angle+PI/2);
  beginShape();
  vertex(-10,0);
  vertex(0,-1);
  vertex(10,0);
  vertex(0,1);
  vertex(-10,0);
  endShape(CLOSE);
  popMatrix();
}

void stop() {
  gunManager.shutdown(); // We clean after ourselves (stop rumble and lights off)
  super.stop();          // Whatever Processing usually does on shutdown
} 
