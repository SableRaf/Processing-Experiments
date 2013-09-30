// Controller class -------------------------------------------------------------

class MoveController extends PSMove {
  

  int triggerValue, previousTriggerValue;
  
  long [] pressed = {0};                         // Button press events
  long [] released = {0};                        // Button release events 
  
  MoveButton[] buttonList = new MoveButton[9];  // The move controller has 9 buttons
  
  boolean isTriggerPressed, isMovePressed, isSquarePressed, isTrianglePressed, isCrossPressed, isCirclePressed, isStartPressed, isSelectPressed, isPsPressed; 

  
  MoveController(int i) {
    super(i);
    init();
  }
  
  void init() {
    createButtons();
    movePoll();
  }
  
  //Populate the moveButton[] array of the controller with MoveButton objects.
  void createButtons() {
    for (int i=0; i<buttonList.length; i++) {
      buttonList[i] = new MoveButton();
    }
  }

  
  
  // Trigger value --------------------------------------------------------
  
  int getTriggerValue() {
    return buttonList[TRIGGER_BTN].getValue();
  }

  // Button presses --------------------------------------------------------
  
  boolean isTriggerPressed() {
    return buttonList[TRIGGER_BTN].isPressed();
  }

  boolean isMovePressed() {
    return buttonList[MOVE_BTN].isPressed();
  }

  boolean isSquarePressed() {
    return buttonList[SQUARE_BTN].isPressed();
  }

  boolean isTrianglePressed() {
    return buttonList[TRIANGLE_BTN].isPressed();
  }

  boolean isCrossPressed() {
    return buttonList[CROSS_BTN].isPressed();
  }

  boolean isCirclePressed() {
    return buttonList[CIRCLE_BTN].isPressed();
  }

  boolean isSelectPressed() {
    return buttonList[SELECT_BTN].isPressed();
  }

  boolean isStartPressed() {
    return buttonList[START_BTN].isPressed();
  }

  boolean isPsPressed() {
    return buttonList[PS_BTN].isPressed();
  }    

  // --------------------------------------------------------
  // Button events 
  
  // Tells if a given button was pressed/released
  // since the last call to the event function

  // --------------------------------------------------------
  // Pressed

  boolean isTriggerPressedEvent() {
    boolean event = buttonList[TRIGGER_BTN].isPressedEvent();
    return event;
  }

  boolean isMovePressedEvent() {
    boolean event = buttonList[MOVE_BTN].isPressedEvent();
    return event;
  }

  boolean isSquarePressedEvent() {
    boolean event = buttonList[SQUARE_BTN].isPressedEvent();
    return event;
  }

  boolean isTrianglePressedEvent() {
    boolean event = buttonList[TRIANGLE_BTN].isPressedEvent();
    return event;
  }

  boolean isCrossPressedEvent() {
    boolean event = buttonList[CROSS_BTN].isPressedEvent();
    return event;
  }

  boolean isCirclePressedEvent() {
    boolean event = buttonList[CIRCLE_BTN].isPressedEvent();
    return event;
  }

  boolean isSelectPressedEvent() {
    boolean event = buttonList[SELECT_BTN].isPressedEvent();
    return event;
  }

  boolean isStartPressedEvent() {
    boolean event = buttonList[START_BTN].isPressedEvent();
    return event;
  }

  boolean isPsPressedEvent() {
    boolean event = buttonList[PS_BTN].isPressedEvent();
    return event;
  }   

  // Released --------------------------------------------------------

  boolean isTriggerReleasedEvent() {
    boolean event = buttonList[TRIGGER_BTN].isReleasedEvent();
    return event;
  }

  boolean isMoveReleasedEvent() {
    boolean event = buttonList[MOVE_BTN].isReleasedEvent();
    return event;
  }

  boolean isSquareReleasedEvent() {
    boolean event = buttonList[SQUARE_BTN].isReleasedEvent();
    return event;
  }

  boolean isTriangleReleasedEvent() {
    boolean event = buttonList[TRIANGLE_BTN].isReleasedEvent();
    return event;
  }

  boolean isCrossReleasedEvent() {
    boolean event = buttonList[CROSS_BTN].isReleasedEvent();
    return event;
  }

  boolean isCircleReleasedEvent() {
    boolean event = buttonList[CIRCLE_BTN].isReleasedEvent();
    return event;
  }

  boolean isSelectReleasedEvent() {
    boolean event = buttonList[SELECT_BTN].isReleasedEvent();
    return event;
  }

  boolean isStartReleasedEvent() {
    boolean event = buttonList[START_BTN].isReleasedEvent();
    return event;
  }

  boolean isPsReleasedEvent() {
    boolean event = buttonList[PS_BTN].isReleasedEvent();
    return event;
  }
  

  
  // Update --------------------------------------------------------

  void update(int _rumbleLevel, color _sphereColor) {
    
    movePoll();
    
    int r, g, b;
    
    r = (int)red(_sphereColor);
    g = (int)green(_sphereColor);
    b = (int)blue(_sphereColor);
    
    super.set_leds(r, g, b);
    
    super.set_rumble(_rumbleLevel);
    
    super.update_leds(); // actually, it also updates the rumble... don't ask
    
  } // END OF UPDATE
  
  
  
  // updatePoll --------------------------------------------------------
  // Read inputs from the Move controller (buttons and sensors)


  private void movePoll() { 
      
    // Update all readings in the PSMove object
          
    while ( super.poll() != 0 ) {} 
    
    // Start by reading all the buttons from the controller
    
    int buttons = super.get_buttons();      
        
    // Then update individual MoveButton objects in the buttonList array
    
    
    if ((buttons & io.thp.psmove.Button.Btn_MOVE.swigValue()) != 0) {
      buttonList[MOVE_BTN].press();
    }
    // ERROR: this causes nullPointerException
    else if (buttonList[MOVE_BTN].isPressed()) {
      buttonList[MOVE_BTN].release();
    }
    
    if ((buttons & io.thp.psmove.Button.Btn_SQUARE.swigValue()) != 0) {
      buttonList[SQUARE_BTN].press();
    } 
    else if (buttonList[SQUARE_BTN].isPressed()) {
      buttonList[SQUARE_BTN].release();
    }
    if ((buttons & io.thp.psmove.Button.Btn_TRIANGLE.swigValue()) != 0) {
      buttonList[TRIANGLE_BTN].press();
    } 
    else if (buttonList[TRIANGLE_BTN].isPressed()) {
      buttonList[TRIANGLE_BTN].release();
    }
    if ((buttons & io.thp.psmove.Button.Btn_CROSS.swigValue()) != 0) {
      buttonList[CROSS_BTN].press();
    } 
    else if (buttonList[CROSS_BTN].isPressed()) {
      buttonList[CROSS_BTN].release();
    }
    if ((buttons & io.thp.psmove.Button.Btn_CIRCLE.swigValue()) != 0) {
      buttonList[CIRCLE_BTN].press();
    } 
    else if (buttonList[CIRCLE_BTN].isPressed()) {
      buttonList[CIRCLE_BTN].release();
    }
    if ((buttons & io.thp.psmove.Button.Btn_START.swigValue()) != 0) {
      buttonList[START_BTN].press();
    } 
    else if (buttonList[START_BTN].isPressed()) {
      buttonList[START_BTN].release();
    }
    if ((buttons & io.thp.psmove.Button.Btn_SELECT.swigValue()) != 0) {
      buttonList[SELECT_BTN].press();
    } 
    else if (buttonList[SELECT_BTN].isPressed()) {
      buttonList[SELECT_BTN].release();
    }
    if ((buttons & io.thp.psmove.Button.Btn_PS.swigValue()) != 0) {
      buttonList[PS_BTN].press();
    } 
    else if (buttonList[PS_BTN].isPressed()) {
      buttonList[PS_BTN].release();
    }

    // Now the same for the events
    
    // Start by reading all events from the controller
    
    super.get_button_events(pressed, released);
    // Then register the current individual events to the corresponding MoveButton objects in the buttonList array
    if ((pressed[0] & io.thp.psmove.Button.Btn_MOVE.swigValue()) != 0) {
      if (debug) println("The Move button was just pressed.");
      buttonList[MOVE_BTN].eventPress();
    } 
    else if ((released[0] & io.thp.psmove.Button.Btn_MOVE.swigValue()) != 0) {
      if (debug) println("The Move button was just released.");
      buttonList[MOVE_BTN].eventRelease();
    }
    if ((pressed[0] & io.thp.psmove.Button.Btn_SQUARE.swigValue()) != 0) {
      if (debug) println("The Square button was just pressed.");
      buttonList[SQUARE_BTN].eventPress();
    } 
    else if ((released[0] & io.thp.psmove.Button.Btn_SQUARE.swigValue()) != 0) {
      if (debug) println("The Square button was just released.");
      buttonList[SQUARE_BTN].eventRelease();
    }
    if ((pressed[0] & io.thp.psmove.Button.Btn_TRIANGLE.swigValue()) != 0) {
      if (debug) println("The Triangle button was just pressed.");
      buttonList[TRIANGLE_BTN].eventPress();
    } 
    else if ((released[0] & io.thp.psmove.Button.Btn_TRIANGLE.swigValue()) != 0) {
      if (debug) println("The Triangle button was just released.");
      buttonList[TRIANGLE_BTN].eventRelease();
    }
    if ((pressed[0] & io.thp.psmove.Button.Btn_CROSS.swigValue()) != 0) {
      if (debug) println("The Cross button was just pressed.");
      buttonList[CROSS_BTN].eventPress();
    } 
    else if ((released[0] & io.thp.psmove.Button.Btn_CROSS.swigValue()) != 0) {
      if (debug) println("The Cross button was just released.");
      buttonList[CROSS_BTN].eventRelease();
    }
    if ((pressed[0] & io.thp.psmove.Button.Btn_CIRCLE.swigValue()) != 0) {
      if (debug) println("The Circle button was just pressed.");
      buttonList[CIRCLE_BTN].eventPress();
    } 
    else if ((released[0] & io.thp.psmove.Button.Btn_CIRCLE.swigValue()) != 0) {
      if (debug) println("The Circle button was just released.");
      buttonList[CIRCLE_BTN].eventRelease();
    }
    if ((pressed[0] & io.thp.psmove.Button.Btn_START.swigValue()) != 0) {
      if (debug) println("The Start button was just pressed.");
      buttonList[START_BTN].eventPress();
    } 
    else if ((released[0] & io.thp.psmove.Button.Btn_START.swigValue()) != 0) {
      if (debug) println("The Start button was just released.");
      buttonList[START_BTN].eventRelease();
    }
    if ((pressed[0] & io.thp.psmove.Button.Btn_SELECT.swigValue()) != 0) {
      if (debug) println("The Select button was just pressed.");
      buttonList[SELECT_BTN].eventPress();
    } 
    else if ((released[0] & io.thp.psmove.Button.Btn_SELECT.swigValue()) != 0) {
      if (debug) println("The Select button was just released.");
      buttonList[SELECT_BTN].eventRelease();
    }
    if ((pressed[0] & io.thp.psmove.Button.Btn_PS.swigValue()) != 0) {
      if (debug) println("The PS button was just pressed.");
      buttonList[PS_BTN].eventPress();
    } 
    else if ((released[0] & io.thp.psmove.Button.Btn_PS.swigValue()) != 0) {
      if (debug) println("The PS button was just released.");
      buttonList[PS_BTN].eventRelease();
    }

    
    // Read the trigger information from the controller
    
    previousTriggerValue = triggerValue;             // Store the previous value
    triggerValue = super.get_trigger();              // Get the new value
    buttonList[TRIGGER_BTN].setValue(triggerValue); // Send the value to the button object

    
    // press/release behaviour for the trigger
    
    if (triggerValue>0) {
      buttonList[TRIGGER_BTN].press();
      if (previousTriggerValue == 0) { // Catch trigger presses
        if (debug) println("The Trigger button was just pressed.");
        buttonList[TRIGGER_BTN].eventPress();
      }
    }
    else if (previousTriggerValue>0) { // Catch trigger releases
      if (debug) println("The Trigger button was just released.");
      buttonList[TRIGGER_BTN].eventRelease();
      buttonList[TRIGGER_BTN].release();
    }
    else buttonList[TRIGGER_BTN].release();
    
  }
  // END OF UPDATE POLL
  
  void shutdown() {
      super.set_rumble(0);
      super.set_leds(0, 0, 0);
      super.update_leds();
  }
  

}

// END OF MOVE CONTROLLER



// Button class -------------------------------------------------------------

class MoveButton {

  
  boolean isPressed;
  //boolean isPressedEvent, isReleasedEvent;
  int value, previousValue; // For analog buttons only (triggers)
  
  
  // We store multiple catchers for the event in case we need to make 
  // several queries; the event catcher is set to false after the query 
  // so we can only use each event catcher once. To do so, we can use 
  // isPressedEvent(i) where i is the id of the catcher.
  boolean[] pressedEvents;
  boolean[] releasedEvents;

  
  MoveButton() {
    isPressed = false;
    pressedEvents = new boolean[64];
    releasedEvents = new boolean[64];
    value = 0;
  }
  

  void press() {
    isPressed = true;
  }

  
  void release() { 
    isPressed = false;
  }
  
  
  void eventPress() {
    for(int i=0; i < pressedEvents.length; i++) {
      pressedEvents[i] = true; // update all the event catchers
    }
  }
  
  
  void eventRelease() {
    for(int i=0; i < releasedEvents.length; i++) {
      releasedEvents[i] = true; // update all the event catchers
    }
  }
  
  
  boolean isPressedEvent() {
    if(pressedEvents[0]) {
      pressedEvents[0] = false; // Reset the main event catcher
      return true;
    }
    return false;
  }
  
  
  boolean isReleasedEvent() {
    if(releasedEvents[0]) {
      releasedEvents[0] = false; // Reset the main event catcher
      return true;
    }
    return false;
  }
  
  
  boolean isPressedEvent(int i) {
    if(pressedEvents[i]) {
      pressedEvents[i] = false; // Reset the selected event catcher
      return true;
    }
    return false;
  }
  
  
  boolean isReleasedEvent(int i) {
    if(releasedEvents[i]) {
      releasedEvents[i] = false; // Reset the selected event catcher
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
  }
  
  
  int getValue() {    
    return value;
  }
   
}
