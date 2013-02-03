
// Give access to the Move controller in a Processing-friendlier 
// manner, by abstracting the calls to the API.

class MoveController extends PSMove {

  private boolean debug = true; // Print debug messages?
  
  private boolean has_orientation = true; // Defines if the controller will be configured for sensor fusion


  private String serial;       // What is the MAC adress of the controller?  
  
  // Actuators
  private int rumble_level;    // Value for the vibration
  private color sphere_color;  // The color values we send to the leds

  // Orientation calculated by sensor fusion (quaternion)
  float [] quat0 = {0.f}, quat1 = {0.f}, quat2 = {0.f}, quat3 = {0.f};

  // Sensor values (inertial mesurement)
  float [] ax = {0.f}, ay = {0.f}, az = {0.f}; // Accelerometers
  float [] gx = {0.f}, gy = {0.f}, gz = {0.f}; // Gyroscopes
  float [] mx = {0.f}, my = {0.f}, mz = {0.f}; // Magnetometers (compasses)

  private int battery_level;   // How much juice left? Is the controller charging?
  private String battery_name;    // Same in plain text
  
  // enum values returned by PSMove.get_battery()
  private final int Batt_MIN           = 0x00;
  private final int Batt_20Percent     = 0x01;
  private final int Batt_40Percent     = 0x02;
  private final int Batt_60Percent     = 0x03;
  private final int Batt_80Percent     = 0x04;
  private final int Batt_MAX           = 0x05;
  private final int Batt_CHARGING      = 0xEE;
  private final int Batt_CHARGING_DONE = 0xEF;

  private int connection_type; // USB or Bluetooth?
  private String connection_name; // Same in plain text

  // enum values returned by PSMove.connection_type()
  private final int Conn_Bluetooth = 0; // if the controller is connected via Bluetooth
  private final int Conn_USB       = 1; // if the controller is connected via USB
  private final int Conn_Unknown   = 2; // on error

  private MoveButton[] moveButtons = new MoveButton[9];  // The move controller has 9 buttons
  
  // enum values for the moveButtons array
  private final int TRIGGER_BTN  = 0;
  private final int MOVE_BTN     = 1;
  private final int SQUARE_BTN   = 2;
  private final int TRIANGLE_BTN = 3;
  private final int CROSS_BTN    = 4;
  private final int CIRCLE_BTN   = 5;
  private final int START_BTN    = 6;
  private final int SELECT_BTN   = 7;
  private final int PS_BTN       = 8;
  
  private long [] pressed = {0};  // Button press events
  private long [] released = {0}; // Button release events
  
  private int rumbleLevel; // Vibration of the controller (between 0 and 255)

  MoveController(int i) {
    super(i);
    init();
  }

  private void init() {    
    get_serial();
    getConnection_type();
    create_buttons();
  }

  void update() {
    update_poll();
    super.update_leds();
  }
  
  // Put all actuators to rest (vibration & leds)
  void shutdown() {
    super.set_rumble(0);
    super.set_leds(0, 0, 0);
    super.update_leds();
  }
  
  // Print the current battery level, mac adress and connection type of each controller
  void echo() {     
     println("MAC address: "+serial+ " | Battery "+battery_name+" | Connected via "+connection_name);
  }
  
  // --- Getters & Setters --------------------
  
  color get_sphere_color() {
    return sphere_color;
  }
  
  int getRed() {
    return (int)red(sphere_color);
  }
  
  int getGreen() {
    return (int)green(sphere_color);
  }
  
  int getBlue() {
    return (int)blue(sphere_color);
  }
  
  String get_connection_name() {
    return connection_name;
  }
  
  String get_battery_name() {
    return battery_name;
  }
  
  // Orientation get
  
  float get_quat0() {
    return quat0[0];
  }
  
  float get_quat1() {
    return quat1[0];
  }
  
  float get_quat2() {
    return quat2[0];
  }
  
  float get_quat3() {
    return quat3[0];
  }
  
  // Sensors get
  
  // Accelerometers
  float get_ax() {
    return ax[0];
  }
  
  float get_ay() {
    return ay[0];
  }
  
  float get_az() {
    return az[0];
  }
  
  // Gyroscopes
  float get_gx() {
    return gx[0];
  }
  
  float get_gy() {
    return gy[0];
  }
  
  float get_gz() {
    return gz[0];
  }
  
  // Magnetometers
  float get_mx() {
    return mx[0];
  }
  
  float get_my() {
    return my[0];
  }
  
  float get_mz() {
    return mz[0];
  }
  
  // Buttons get
  
  int get_trigger_value() {
    return moveButtons[TRIGGER_BTN].getValue();
  }
  
  boolean isTriggerPressed() {
    return moveButtons[TRIGGER_BTN].isPressed();
  }
  
  boolean isMovePressed() {
    return moveButtons[MOVE_BTN].isPressed();
  }
  
  boolean isSquarePressed() {
    return moveButtons[SQUARE_BTN].isPressed();
  }
  
  boolean isTrianglePressed() {
    return moveButtons[TRIANGLE_BTN].isPressed();
  }
  
  boolean isCrossPressed() {
    return moveButtons[CROSS_BTN].isPressed();
  }
  
  boolean isCirclePressed() {
    return moveButtons[CIRCLE_BTN].isPressed();
  }
  
  boolean isSelectPressed() {
    return moveButtons[SELECT_BTN].isPressed();
  }
  
  boolean isStartPressed() {
    return moveButtons[START_BTN].isPressed();
  }
  
  boolean isPsPressed() {
    return moveButtons[PS_BTN].isPressed();
  }    

  // Get button events 
  // Tells if a given button was pressed/released
  // since the last call to the event function
  
  // Pressed
  
  boolean isMovePressedEvent() {
    boolean event = moveButtons[MOVE_BTN].isPressedEvent();
    return event;
  }
  
  boolean isSquarePressedEvent() {
    boolean event = moveButtons[SQUARE_BTN].isPressedEvent();
    return event;
  }
  
  boolean isTrianglePressedEvent() {
    boolean event = moveButtons[TRIANGLE_BTN].isPressedEvent();
    return event;
  }
  
  boolean isCrossPressedEvent() {
    boolean event = moveButtons[CROSS_BTN].isPressedEvent();
    return event;
  }
  
  boolean isCirclePressedEvent() {
    boolean event = moveButtons[CIRCLE_BTN].isPressedEvent();
    return event;
  }
  
  boolean isSelectPressedEvent() {
    boolean event = moveButtons[SELECT_BTN].isPressedEvent();
    return event;
  }
  
  boolean isStartPressedEvent() {
    boolean event = moveButtons[START_BTN].isPressedEvent();
    return event;
  }
  
  boolean isPsPressedEvent() {
    boolean event = moveButtons[PS_BTN].isPressedEvent();
    return event;
  }   
  
  // Released
  
  boolean isMoveReleasedEvent() {
    boolean event = moveButtons[MOVE_BTN].isReleasedEvent();
    return event;
  }
  
  boolean isSquareReleasedEvent() {
    boolean event = moveButtons[SQUARE_BTN].isReleasedEvent();
    return event;
  }
  
  boolean isTriangleReleasedEvent() {
    boolean event = moveButtons[TRIANGLE_BTN].isReleasedEvent();
    return event;
  }
  
  boolean isCrossReleasedEvent() {
    boolean event = moveButtons[CROSS_BTN].isReleasedEvent();
    return event;
  }
  
  boolean isCircleReleasedEvent() {
    boolean event = moveButtons[CIRCLE_BTN].isReleasedEvent();
    return event;
  }
  
  boolean isSelectReleasedEvent() {
    boolean event = moveButtons[SELECT_BTN].isReleasedEvent();
    return event;
  }
  
  boolean isStartReleasedEvent() {
    boolean event = moveButtons[START_BTN].isReleasedEvent();
    return event;
  }
  
  boolean isPsReleasedEvent() {
    boolean event = moveButtons[PS_BTN].isReleasedEvent();
    return event;
  }   

  
  // --- Inherited methods --------------------
  
  String get_serial() {
    serial = super.get_serial(); // Save the serial of the controller
    return serial;
  }
  
  int getConnection_type() {
    connection_type = super.getConnection_type();
    connection_name = connection_toString(connection_type);
    return connection_type;
  }
  
  void set_rumble(int level) {
    rumbleLevel = level;
    super.set_rumble(level);
  }
  
  int get_rumble() {
    return rumbleLevel;
  }
  
  void set_leds(int r, int g, int b) {
    sphere_color = color(r,g,b);
    super.set_leds(r,g,b);
  }
  
  void set_leds(color col) {
    sphere_color = col;
    int r = (int)red(col);
    int g = (int)green(col);
    int b = (int)blue(col);
    super.set_leds(r,g,b);
  }

  // --- Internal methods ---------------------

  protected void create_buttons() {
    for (int i=0; i<moveButtons.length; i++) {
      moveButtons[i] = new MoveButton();
    }
  }

  // Read inputs from the move (buttons and sensors)
  protected void update_poll() { 
    //println("update_buttons()");
        
    while (super.poll() != 0) {
      
      battery_level = super.get_battery(); // Save the battery level of the controller
      battery_name = get_battery_level_name(battery_level);
      
      // Read the (calibrated) sensor informations from the controller
      super.get_accelerometer_frame(io.thp.psmove.Frame.Frame_SecondHalf, ax, ay, az);
      super.get_gyroscope_frame(io.thp.psmove.Frame.Frame_SecondHalf, gx, gy, gz);
      super.get_magnetometer_vector(mx, my, mz);
  
      // Read the trigger information from the controller
      int trigger = super.get_trigger();
      moveButtons[TRIGGER_BTN].setValue(trigger);
  
      // Start by reading all the buttons from the controller
      int buttons = super.get_buttons();
      // Then update individual MoveButton objects
      if ((buttons & Button.Btn_MOVE.swigValue()) != 0) {
        moveButtons[MOVE_BTN].press();
      } 
      else if (moveButtons[MOVE_BTN].isPressed()) {
        moveButtons[MOVE_BTN].release();
      }
      if ((buttons & Button.Btn_SQUARE.swigValue()) != 0) {
        moveButtons[SQUARE_BTN].press();
      } 
      else if (moveButtons[SQUARE_BTN].isPressed()) {
        moveButtons[SQUARE_BTN].release();
      }
      if ((buttons & Button.Btn_TRIANGLE.swigValue()) != 0) {
        moveButtons[TRIANGLE_BTN].press();
      } 
      else if (moveButtons[TRIANGLE_BTN].isPressed()) {
        moveButtons[TRIANGLE_BTN].release();
      }
      if ((buttons & Button.Btn_CROSS.swigValue()) != 0) {
        moveButtons[CROSS_BTN].press();
      } 
      else if (moveButtons[CROSS_BTN].isPressed()) {
        moveButtons[CROSS_BTN].release();
      }
      if ((buttons & Button.Btn_CIRCLE.swigValue()) != 0) {
        moveButtons[CIRCLE_BTN].press();
      } 
      else if (moveButtons[CIRCLE_BTN].isPressed()) {
        moveButtons[CIRCLE_BTN].release();
      }
      if ((buttons & Button.Btn_START.swigValue()) != 0) {
        moveButtons[START_BTN].press();
      } 
      else if (moveButtons[START_BTN].isPressed()) {
        moveButtons[START_BTN].release();
      }
      if ((buttons & Button.Btn_SELECT.swigValue()) != 0) {
        moveButtons[SELECT_BTN].press();
      } 
      else if (moveButtons[SELECT_BTN].isPressed()) {
        moveButtons[SELECT_BTN].release();
      }
      if ((buttons & Button.Btn_PS.swigValue()) != 0) {
        moveButtons[PS_BTN].press();
      } 
      else if (moveButtons[PS_BTN].isPressed()) {
        moveButtons[PS_BTN].release();
      }
      
      // Start by reading all events from the controller
      super.get_button_events(pressed, released);
      // Then register the current individual events in the corresponding MoveButton objects
      if ((pressed[0] & Button.Btn_MOVE.swigValue()) != 0) {
        if(debug) println("The Move button was just pressed.");
        moveButtons[MOVE_BTN].eventPress();
      } else if ((released[0] & Button.Btn_MOVE.swigValue()) != 0) {
        if(debug) println("The Move button was just released.");
        moveButtons[MOVE_BTN].eventRelease();
      }
      if ((pressed[0] & Button.Btn_SQUARE.swigValue()) != 0) {
        if(debug) println("The Square button was just pressed.");
        moveButtons[SQUARE_BTN].eventPress();
      } else if ((released[0] & Button.Btn_SQUARE.swigValue()) != 0) {
        if(debug) println("The Square button was just released.");
        moveButtons[SQUARE_BTN].eventRelease();
      }
      if ((pressed[0] & Button.Btn_TRIANGLE.swigValue()) != 0) {
        if(debug) println("The Triangle button was just pressed.");
        moveButtons[TRIANGLE_BTN].eventPress();
      } else if ((released[0] & Button.Btn_TRIANGLE.swigValue()) != 0) {
        if(debug) println("The Triangle button was just released.");
        moveButtons[TRIANGLE_BTN].eventRelease();
      }
      if ((pressed[0] & Button.Btn_CROSS.swigValue()) != 0) {
        if(debug) println("The Cross button was just pressed.");
        moveButtons[CROSS_BTN].eventPress();
      } else if ((released[0] & Button.Btn_CROSS.swigValue()) != 0) {
        if(debug) println("The Cross button was just released.");
        moveButtons[CROSS_BTN].eventRelease();
      }
      if ((pressed[0] & Button.Btn_CIRCLE.swigValue()) != 0) {
        if(debug) println("The Circle button was just pressed.");
        moveButtons[CIRCLE_BTN].eventPress();
      } else if ((released[0] & Button.Btn_CIRCLE.swigValue()) != 0) {
        if(debug) println("The Circle button was just released.");
        moveButtons[CIRCLE_BTN].eventRelease();
      }
      if ((pressed[0] & Button.Btn_START.swigValue()) != 0) {
        if(debug) println("The Start button was just pressed.");
        moveButtons[START_BTN].eventPress();
      } else if ((released[0] & Button.Btn_START.swigValue()) != 0) {
        if(debug) println("The Start button was just released.");
        moveButtons[START_BTN].eventRelease();
      }
      if ((pressed[0] & Button.Btn_SELECT.swigValue()) != 0) {
        if(debug) println("The Select button was just pressed.");
        moveButtons[SELECT_BTN].eventPress();
      } else if ((released[0] & Button.Btn_SELECT.swigValue()) != 0) {
        if(debug) println("The Select button was just released.");
        moveButtons[SELECT_BTN].eventRelease();
      }
      if ((pressed[0] & Button.Btn_PS.swigValue()) != 0) {
        if(debug) println("The PS button was just pressed.");
        moveButtons[PS_BTN].eventPress();
      } else if ((released[0] & Button.Btn_PS.swigValue()) != 0) {
        if(debug) println("The PS button was just released.");
        moveButtons[PS_BTN].eventRelease();
      }      
    }
  }
  
  // Translate the connection type from int (enum) to a readable form
  protected String connection_toString(int type) {
    switch(type) {
      case Conn_Bluetooth:  return "Bluetooth";
      case Conn_USB :       return "USB";
      case Conn_Unknown :   return "Connection error";
      default:              return "Error in connection_toString()";
    }
  }
  
  // Translate the battery level from int (enum) to a readable form
  protected String get_battery_level_name(int level) {
    switch(level) {
      case Batt_MIN:            return "low";
      case Batt_20Percent :     return "20%";
      case Batt_40Percent :     return "40%";
      case Batt_60Percent :     return "60%";
      case Batt_80Percent :     return "80%";
      case Batt_MAX :           return "100%";
      case Batt_CHARGING :      return "charging...";
      case Batt_CHARGING_DONE : return "fully charged";
      default:                  return "returning [Error in get_battery_level_name()]";
    }
  }
}

