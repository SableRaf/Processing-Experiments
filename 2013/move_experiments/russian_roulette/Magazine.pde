class Magazine {

  int activeSlot = 0; // id of the slot currently aligned with the muzzle

  private final int CYLINDER  = 0;
  private final int SEMIAUTO  = 1; //
  private int magazineType;

  int[] slots; // 1 = bullet, 0 = empty slot

  // Constructor
  Magazine(int slotNumber) {
    magazineType = CYLINDER;
    slots = new int[slotNumber];
    reload();
  }

  Magazine(int slotNumber, int magType) {
    slots = new int[slotNumber];
    magazineType = magType;
    reload();
  }

  // Fill the magazine with rounds
  public void reload() {
    for (int i=0; i < slots.length; i++ ) {
      slots[i] = 1;
    } 
    activeSlot = 0;
  }

  // Remove all rounds
  public void unload() {
    for (int i=0; i < slots.length; i++ ) {
      slots[i] = 0;
    }
    activeSlot = slots.length-1;
  }

  // Put a round in this slot
  public void loadAt(int i) {
    if (magazineType == CYLINDER) {
      if (slots[i] == 1)
        println("Can't loadAt("+i+"): slot is already loaded");
      else if (i>=0 && i<slots.length)
        slots[i] = 1;
      else println("loadAt argument ("+i+") is out of bounds [0 "+slots.length+"]");
    }
    else {
      println("You can only access individual slots on a cylinder");
    }
  }

  // Remove the round in this slot
  public void unloadAt(int i) {
    if (magazineType == CYLINDER) {
      if (slots[i] == 0)
        println("Can't unloadAt("+i+"): slot is already empty");
      else if (i>=0 && i<slots.length)
        slots[i] = 0;
      else println("unloadAt argument ("+i+") is out of bounds [0 "+slots.length+"]");
    }
    else {
      println("You can only access individual slots on a cylinder");
    }
  }

  public void loadRandom(int bullets) {
    for (int i=0; i<bullets; i++) { 
      loadAt((int)random(slots.length-1)); // load a bullet anywhere in the magazine
    }
  }

  // Is there a round in this slot?
  boolean isBullet(int i) {
    if (slots[i] == 1)
      return true;
    return false;
  }

  boolean fireNext() {

    boolean isFinished = false;
    if (activeSlot>=slots.length) 
      isFinished = true;

    if (!isFinished) { // Are we sure we are not past the last slot?
      if (slots[activeSlot] == 1) {
        println("Firing slot "+ (activeSlot+1) );
        unloadAt(activeSlot); // Empty the slot
        activeSlot++;         // Move to the next slot
        return true;
      }
      else {
        println("Slot "+ (activeSlot+1) +" was empty");
        activeSlot++;         // Move to the next slot
      }
    }
    // We fired the whole magazine? Ok, then...
    else {
      switch(magazineType) {
        
      case CYLINDER:
        activeSlot = 0; // The cylinder rotates back to the first chamber
        
        if (slots[activeSlot] == 1) {
          println("Firing slot "+ (activeSlot+1) );
          unloadAt(activeSlot); // Empty the slot
          activeSlot++;
          return true;
        }
        else {
          println("Slot "+ (activeSlot+1) +" was empty");
          activeSlot++;
        }
        
      case SEMIAUTO:
        activeSlot = activeSlot; // We stay there (just for clarity)
        break;
      }
    }
    return false;
  }

  // Spin the cylinder
  int spin() {
    if (magazineType==CYLINDER) {
      activeSlot = (int)random(slots.length-1);
    }
    else {
      println("You can't spin a semi-automatic.");
    }
    return activeSlot;
  }
}
