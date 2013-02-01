
class MoveManager {
  
  int total_connected, unique_connected;
  
  // This is the list where we will store the connected 
  // controllers and their id (MAC address) as a Key.
  private HashMap<String, MoveController> controllers;
  
  // The same controller connected via USB and Bluetooth 
  // shows twice. If enabled, USB controllers will be replaced 
  // with their Bluetooth counterpart when found. Otherwise,
  // it is "first in first served".
  boolean priority_bluetooth = true;
  
  MoveManager() {
    init();
  }
  
  void init() {
    println("Looking for controllers...");
    println("");
    
    total_connected = psmoveapi.count_connected();
    unique_connected = 0; // Number of actual controllers connected (without duplicates)
    
    controllers = new HashMap<String, MoveController>(); // Create the list of controllers

    // This is only fun if we actually have controllers
    if (total_connected == 0) {
      println("WARNING: No controllers connected.");
    }

    // Filter via connection type to avoid duplicates
    for (int i = 0; i<total_connected; i++) {
  
      MoveController move = new MoveController(i);

      String serial = move.get_serial();
      String connection = move.get_connection_name();
  
      if (!controllers.containsKey(serial)) { // Check for duplicates
        try { 
          controllers.put(serial, move);        // Add the id (MAC address) and controller to the list
          println("Found "+serial+" via "+connection);
        }
        catch (Exception ex) {
          println("Error trying to register Controller #"+i+" with address "+serial);
          ex.printStackTrace();
        }
        unique_connected++; // We just added one unique controller
      }
      else {
        if(connection == "Bluetooth" && priority_bluetooth) {
          MoveController duplicate_move = controllers.get(serial);
          String duplicate_connection = duplicate_move.get_connection_name(); // 
          
          controllers.put(serial, move);     // Overwrite the controller at this id
          println("Found "+serial+" via "+connection+" (overwrote "+duplicate_connection+")");
        }
        else {
          println("Found "+serial+" via "+connection+" (duplicate ignored)");
        }
      }
    }
    //init_serial_array(controllers);
  }
  
  void update() {
    for (String id: controllers.keySet()) {
      MoveController move = controllers.get(id);     // Give me the controller with that MAC address
      move.update();
    }
  }
  
  void shutdown() {
    for (String id: controllers.keySet()) {
      MoveController move = controllers.get(id);     // Give me the controller with that MAC address
      move.shutdown();
    }
  }

  // --- Getters & Setters ----------------------
  
  int get_controller_count() {
   return unique_connected;
  }
  
  // Return the Mac adress of a given controller
  String get_serial(int i) {
    int iterator = 0;
    String serial = "";
    for (String id: controllers.keySet()) {
      if(iterator==i)
        serial = id;
      else
        serial = "error in get_serial()";
      iterator++;
    }
    return serial;
  }
  
  Set get_serials() {
   Set serials = controllers.keySet();
   return serials; 
  }
  
  MoveController get_controller(String id) {
    MoveController m = controllers.get(id);
    return m;
  }
  
  void set_sphere_color(String id, int r, int g, int b) {
      MoveController move = controllers.get(id);     // Give me the controller with that MAC address
      move.set_leds( r,g,b );
  }
  
  // --- Internal methods -----------------------
  
  
}
