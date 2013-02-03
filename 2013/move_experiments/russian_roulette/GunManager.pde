class GunManager extends MoveManager {
  
  private Timer blastTimer; // Duration of a single shot

  boolean wasTriggerReleased = true; // You have to release the trigger to be able to fire again 

  Magazine magazine;
  int magazineSize = 6;

  // Over-simplified gun typology (defines the type of magazine)
  private final int REVOLVER  = 0;
  private final int SEMIAUTO  = 1;
  private int gunType = REVOLVER;
  
  private final int SINGLE  = 0; // The gun has to be manually cocked before firing
  private final int DOUBLE  = 1; // The gun fires each time the trigger is pressed
  private int actionType = DOUBLE;

  private final int COCKED    = 0;
  private final int FIRING    = 1;
  private final int DECOCKED  = 2;
  private int state;

  MoveController gun;

  GunManager() {
    super();
    println("Press the START button on the gun to initialize.");
    blastTimer = new Timer(100);
    state = DECOCKED;
    magazine = new Magazine(magazineSize,gunType);
  }
  
  GunManager(int size) {
    super();
    println("Press the START button on the gun to initialize.");
    blastTimer = new Timer(100);
    state = DECOCKED;
    magazineSize = size;
    magazine = new Magazine(magazineSize,gunType);
  }

  void waitForGun() {
    // Iterate through the connected controllers and 
    // retrieve the first one to push the START button
    for (String id: super.controllers.keySet()) {
      //println("id = "+id);
      MoveController move = super.controllers.get(id);    // Give me the controller with that MAC address
      move.update();
      if (move.isStartPressedEvent()) {
        gun = move;
        println("Move with serial "+id+" is now the gun.");
      }
    }
  }
  
  
  //--- Gun simulation -----------
  
  void arm() {
    state = COCKED;
    println("Cocked, ready to fire");
  }
  
  void reload() {
    magazine.reload();
    println("Gun fully reloaded");
  }
  
  void empty() {
    magazine.unload();
    println("Magazine cleared");
  }
  
  void spin() {
    magazine.spin();
    println("Spinning the wheel... Do you feel lucky?");
  }
  
  // Put a set number of rounds randomly in the cylinder
  void loadRandom(int bullets) {
    
    if (bullets < 0)
      println("You must load a positive number of bullets. Error: bullets = "+bullets+ " The value will be clamped.");
    else if (bullets > magazineSize)
      println("Trying to load too many bullets ("+bullets+") for the magazineSize ("+magazineSize+"). The value will be clamped.");
    
    bullets = constrain(bullets, 0, magazineSize); // Limit the nb of bullets to an acceptable range
    String plural = "";
    if (bullets > 1) plural = "s";
    println("Loading "+bullets+" bullet"+plural+" in the magazine.");
    magazine.loadRandom(bullets);
  }
  
  void fire() {
    // We can only fire if the gun has been cocked (unless it is a semi-automatic)
    if(state == COCKED || actionType == DOUBLE) {
      if(magazine.fireNext()) {
        state = FIRING;
        blastTimer.start();
      }
      else {
        state = DECOCKED;
      }
    }
    else { println("You can't fire an uncocked gun"); }
  }
  
  void fire(int duration) {
    // We can only fire if the gun has been cocked (unless it is a semi-automatic)
    if(state == COCKED || actionType == DOUBLE) {
      blastTimer.setLength(duration);
      if(magazine.fireNext()) {
        state = FIRING;
        blastTimer.start();
      }
      else {
        state = DECOCKED;
      }
    }
    else { println("You can't fire an uncocked gun"); }
  }
  
  // This is the fun part
  void setupRoulette(int numBullets) {
    empty();                 // we have to get rid of the bullets already in the magazine
    loadRandom(numBullets);
    spin();                  // Spin the cylinder... do you feel lucky, punk?
  }
  
  
  //--- Monitoring --------------
  
  boolean isInit() {
    // if we have a gun
    if (null!=gun) return true;
    return false;
  }
  
  boolean isFiring() {
   if(state == FIRING)
     return true;
   return false;
  }
  
  // Detect trigger presses
  boolean isClick() {
    int trigger = gun.get_trigger_value();
    if (trigger >= 255 && wasTriggerReleased) {
      wasTriggerReleased = false;
      return true; 
    }
    return false;
  }
  
  // Is the trigger fully released ?
  boolean isReleased() {
    int trigger = gun.get_trigger_value();
    if (trigger <= 50) {
      return true; 
    }
    return false;
  }
  
  
  //--- Controller management ------------

  // Prepare rumble level of the controller for next update
  void setRumble(int level) {
    int rumble = constrain(level, 0, 255);

    if (level>255 || level<0)
      println("Selected rumble level ("+level+") is out of bounds [0 255]. Rumble set to "+rumble);

    gun.set_rumble(rumble);
  }

  // Prepare sphere color of the controller for next update
  void setColor(color sphereColor) {    
    int r = (int)red(sphereColor);
    int g = (int)green(sphereColor);
    int b = (int)blue(sphereColor);

    gun.set_leds(r, g, b);
  }

  float getAngle() {
    // We get the Y axis magnetometer and map it to the angle
    float magnetometerY = gun.get_my();
    float angle = map(magnetometerY, -1, 1, 0, PI);
    angle = constrain(angle, 0, PI); // make sure we don't go out of bounds
    return angle;
  }
  
  float[] getOrientation() {
   float[] quaternion = new float[4];
   // get the sensor fusion orientation values from the move
   return quaternion;
  }
  
  void update() {
   
   // Wait for trigger to be released
   if(!wasTriggerReleased)
     wasTriggerReleased = isReleased();
     
   if(state == FIRING) {
     int randWhite  = (int)random(100,255);
     int randOrange = (int)random(2);        
     switch(randOrange) {
       case 0: gun.set_leds( randWhite, randWhite, randWhite ); break; // Gray
       case 1: gun.set_leds( randWhite, int(randWhite*.4f), 0 ); break; // orange
     }
     gun.set_rumble(255); 
   }
   else {
     gun.set_leds(0,0,0);
     gun.set_rumble(0);
   }
   if(blastTimer.isFinished())
     state = DECOCKED;
    
   super.update();
  }
  
  
  // --- Visual feedback ---------------------------
  
  public void display() {
    magazine.display();
  }
}

