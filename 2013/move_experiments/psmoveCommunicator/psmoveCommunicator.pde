

// IMPORTS
//-----------------------------------------------------------------------------------------
import io.thp.psmove.*;


  
// DECLARATIONS
//-----------------------------------------------------------------------------------------  

boolean debug = true; // print message ?

MoveController [] controllers; // Define an array of controllers

int rumbleLevel;   // vibration
color sphereColor; // LED sphere

// Button enum
final int TRIGGER_BTN  = 0;
final int MOVE_BTN     = 1;
final int SQUARE_BTN   = 2;
final int TRIANGLE_BTN = 3;
final int CROSS_BTN    = 4;
final int CIRCLE_BTN   = 5;
final int START_BTN    = 6;
final int SELECT_BTN   = 7;
final int PS_BTN       = 8;



// SETUP
//-----------------------------------------------------------------------------------------

void setup() {
  //Init the PSMove controller(s)
  psmoveInit(); 
}



// DRAW
//-----------------------------------------------------------------------------------------

void draw() {
  // Playstation Move update
    psmoveUpdate();
}


// Setup of the move 
// -------------------------------------------------------------

void psmoveInit() {
  int connected = psmoveapi.count_connected();

  // This is only fun if we actually have controllers
  if (connected == 0) {
    println("WARNING: No controllers detected.");
    println("The application will now quit.");
    println("Please connect a controller before running this sketch again.");
    exit();
  }
  else if (debug) { 
    String plural = (connected > 1) ? "s":"";
    println("Found "+ connected + " connected controller" + plural + ".");
  }

  controllers = new MoveController[connected];

  // Fill the array with controllers and light them up
  for (int i = 0; i<controllers.length; i++) {
    controllers[i] = new MoveController(i);       
    controllers[i].update(color(255, 0, 0), 0);
  }
} 


// Update of the move controller(s) 
// ---------------------------------------------------------

void psmoveUpdate() {  
  
  for (int i = 0; i<controllers.length; i++) {
    
    // Get the index of the next controller
    int next = (i+1) % controllers.length;
    
    rumbleLevel = 0;
    
    if ( controllers[i].isTriggerPressed() ) {
      rumbleLevel = controllers[i].triggerValue;
    }

    sphereColor = color( 10, 10, 10 );
      
    if ( controllers[i].isSquarePressed() ) {
       sphereColor =  color( 255, 20, 100 );
    }
    
    else if ( controllers[i].isTrianglePressed() ) {
       sphereColor =  color( 80, 255, 10 );
    }
    
    else if ( controllers[i].isCrossPressed() ) {
       sphereColor =  color( 10, 80, 255 );
    }
    
    else if ( controllers[i].isCirclePressed() ) {
       sphereColor =  color( 255, 20, 10 );
    }
    
    // Poll next controller and update actuators
    controllers[next].update( rumbleLevel, sphereColor );
  }

}



