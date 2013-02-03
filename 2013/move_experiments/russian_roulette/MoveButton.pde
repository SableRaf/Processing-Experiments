class MoveButton {

  boolean isPressed;
  boolean isPressedEvent, isReleasedEvent;
  int value, previousValue; // For analog buttons only (triggers)
  PVector analog; // For analog sticks (navigation controller only)

  MoveButton() {
    isPressed = false;
    isPressedEvent = false;
    isReleasedEvent = false;
    value = 0;
    analog = new PVector(0,0);
  }

  void press() {
    isPressed = true;
  }

  void release() { 
    isPressed = false;
  }
  
  void eventPress() {
    isPressedEvent = true;
  }
  
  void eventRelease() {
    isReleasedEvent = true;
  }
  
  boolean isPressedEvent() {
    if(isPressedEvent) {
      isPressedEvent = false; // Reset the event catcher
      return true;
    }
    return false;
  }
  
  boolean isReleasedEvent() {
    if(isReleasedEvent) {
      isReleasedEvent = false; // Reset the event catcher
      return true;
    }
    return false;
  }
  
  boolean isPressed() {
    return isPressed;
  }

  void setValue(int _val) { 
    previousValue = value;
    value = _val;
    
    if(value>0) {
      isPressed = true;
      if (previousValue == 0) // Catch trigger presses
        isPressedEvent = true;
    }
    else isPressed = false;
  }
  
  int getValue() {    
    return value;
  }
  
  void setAnalog(float _x, float _y) {
    analog.x = _x;
    analog.y = _y;
  }
  
  PVector getAnalog() {
    return analog;
  }
}
