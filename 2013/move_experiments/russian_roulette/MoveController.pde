class MoveController extends PSMove {
  
  private boolean has_orientation = true;

  private String serial;       // What is the MAC adress of the controller?
  private int connection_type; // USB or Bluetooth?
  private int battery_level;   // How much juice left? Is the controller charging?
  private int rumble_level;    // Value for the vibration
  private color sphere_color;
  
  private String connection_name;
  private String battery_name;

  // Orientation values (quaternion floats)
  float [] quat0 = {0.f}, quat1 = {0.f}, quat2 = {0.f}, quat3 = {0.f};

  // Sensor values
  float [] ax = {0.f}, ay = {0.f}, az = {0.f};
  float [] gx = {0.f}, gy = {0.f}, gz = {0.f};
  float [] mx = {0.f}, my = {0.f}, mz = {0.f};

  // enum values returned by PSMove.get_battery()
  final int Batt_MIN           = 0x00;
  final int Batt_20Percent     = 0x01;
  final int Batt_40Percent     = 0x02;
  final int Batt_60Percent     = 0x03;
  final int Batt_80Percent     = 0x04;
  final int Batt_MAX           = 0x05;
  final int Batt_CHARGING      = 0xEE;
  final int Batt_CHARGING_DONE = 0xEF;

  // enum values returned by PSMove.connection_type()
  final int Conn_Bluetooth = 0; // if the controller is connected via Bluetooth
  final int Conn_USB       = 1; // if the controller is connected via USB
  final int Conn_Unknown   = 2; // on error

  private MoveButton[] moveButtons = new MoveButton[9];  // The move controller has 9 buttons

  boolean isTriggerPressed, isMovePressed, isSquarePressed, isTrianglePressed, isCrossPressed, isCirclePressed, isStartPressed, isSelectPressed, isPsPressed; 
  int trigger_value=0;
  
  int rumbleLevel;

  protected color sphereColor;
  protected int r, g, b;

  MoveController(int i) {
    super(i);
    init();
  }

  void init() {    
    get_serial();
    getConnection_type();
    create_buttons();
  }

  void update() {
    update_poll();
    super.update_leds();
  }
  
  // Shut down all controllers
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
    return trigger_value;
  }
  
  boolean isTriggerPressed() {
    return isTriggerPressed;
  }
  
  boolean isMovePressed() {
    return isMovePressed;
  }
  
  boolean isSquarePressed() {
    return isSquarePressed;
  }
  
  boolean isTrianglePressed() {
    return isTrianglePressed;
  }
  
  boolean isCrossPressed() {
    return isCrossPressed;
  }
  
  boolean isCirclePressed() {
    return isCirclePressed;
  }
  
  boolean isSelectPressed() {
    return isSelectPressed;
  }
  
  boolean isStartPressed() {
    return isStartPressed;
  }
  
  boolean isPsPressed() {
    return isPsPressed;
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
      
      super.get_accelerometer_frame(io.thp.psmove.Frame.Frame_SecondHalf, ax, ay, az);
      super.get_gyroscope_frame(io.thp.psmove.Frame.Frame_SecondHalf, gx, gy, gz);
      super.get_magnetometer_vector(mx, my, mz);
  
      int trigger = super.get_trigger();
      moveButtons[0].setValue(trigger);
  
      int buttons = super.get_buttons();
      if ((buttons & Button.Btn_MOVE.swigValue()) != 0) {
        moveButtons[1].press();
      } 
      else {
        moveButtons[1].release();
      }
      if ((buttons & Button.Btn_SQUARE.swigValue()) != 0) {
        moveButtons[2].press();
      } 
      else {
        moveButtons[2].release();
      }
      if ((buttons & Button.Btn_TRIANGLE.swigValue()) != 0) {
        moveButtons[3].press();
      } 
      else {
        moveButtons[3].release();
      }
      if ((buttons & Button.Btn_CROSS.swigValue()) != 0) {
        moveButtons[4].press();
      } 
      else {
        moveButtons[4].release();
      }
      if ((buttons & Button.Btn_CIRCLE.swigValue()) != 0) {
        moveButtons[5].press();
      } 
      else {
        moveButtons[5].release();
      }
      if ((buttons & Button.Btn_SELECT.swigValue()) != 0) {
        moveButtons[6].press();
      } 
      else {
        moveButtons[6].release();
      }
      if ((buttons & Button.Btn_START.swigValue()) != 0) {
        moveButtons[7].press();
      } 
      else {
        moveButtons[7].release();
      }
      if ((buttons & Button.Btn_PS.swigValue()) != 0) {
        moveButtons[8].press();
      } 
      else {
        moveButtons[8].release();
      }
    }
  
    // Store the values in conveniently named variables
    trigger_value        = moveButtons[0].value;
    isTriggerPressed     = moveButtons[0].getPressed(); // The trigger is considered pressed if value > 0
    isMovePressed        = moveButtons[1].getPressed();
    isSquarePressed      = moveButtons[2].getPressed();
    isTrianglePressed    = moveButtons[3].getPressed();
    isCrossPressed       = moveButtons[4].getPressed();
    isCirclePressed      = moveButtons[5].getPressed();
    isSelectPressed      = moveButtons[6].getPressed();
    isStartPressed       = moveButtons[7].getPressed();
    isPsPressed          = moveButtons[8].getPressed();
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
      default:                  return "[Error in get_battery_level_name()]";
    }
  }
}

