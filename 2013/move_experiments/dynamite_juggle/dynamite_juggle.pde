/*

 * DYNAMITE JUGGLE
 * A social game for one PS Move and any number of players
 * By Raphaël de Courville (Twitter: @sableRaph)
 
 * Video Preview: http://youtu.be/zWF-38NtHHU
 
 * HOW TO PLAY
 * Press the MOVE button to arm the explosive
 * Press the TRIGGER to ignite the fuse
 * Pass the dynamite around
 * If someone passes you the dynamite, you have to take it!
 * Shake the dynamite to make it burn faster!
 * Any player touching the stick when it blows up is out of the game
 * Press START for a brand new stick of TNT
 * The game goes on until one player (or none) remains.
 * The winner of the round gets to launch the new dynamite
 
 * Or make your own rules!
 
 * DISCLAIMER: The creators of Dynamite Juggle are not liable for 
 * an injury to, or death of, a player resulting from the inherent 
 * risk of using high explosive materials for recreationnal purpose.
 
 * PS Move Api By Thomas Perl: http://thp.io/2010/psmove/
 * Sound effects made with Bfxr: http://www.bfxr.net/
 
 * Distributed under the GRL CreativeCommons license: 
 * http://goo.gl/Ypucq (or see attached file)
 
 * A literature review on reaction time RJ Kosinski - 
 * Clemson University, 2008 — http://goo.gl/71Klx
 
 * “For about 120 years, the accepted figures for mean simple reaction 
 * times for college-age individuals have been about 190 ms (0.19 sec) 
 * for light stimuli and about 160 ms for sound stimuli.” 
 
 */
 
 /*
    TO DO
    - Try softening the "burn" sound and having a louder "fuse" with a smooth transition for both
    - Idea: Force the player to keep his finger on the trigger for a short time at ignition or the fuse will fail
    - Fix: pressing MOVE while fuse is on makes the indicator circle turn red...
    - Implement drawCircle() for multiple controllers
 */
 
boolean isDebugMode = false;

int detonatorThreshold = 1; // the lower the number, the harder it is to ignite

import io.thp.psmove.*;

import java.util.Set;

Minim minim;
Audio audio;

Timer quitTimer; // Time you have to press the SELECT button to quit the program
  
// Min and Max time (in milliseconds) between which the dynamite can randomly blast
int minimumTime = 10000;
int maximumTime = 20000;

int burnRate = 100; // How much time (in ms) is taken from the countdown for each frame the dynamite is shaken

int soundDropTime = 600;     // Time (in milliseconds) before the explosion when the volume drops
int soundDropDuration = 300; // Duration (in milliseconds) of the fade out

int blastCueTime = 600;      // How long (in milliseconds) before the blast is the cue sound played
float cueVolume = -15.0;     // Volume at which the cue is played (min is -80 max is 6)

int quit_countdown = 1200;

PSMove move;

MoveManager moveManager;

int glow;

int startRadius = 90; // Initial radius of the on screen time indicator
int radius = startRadius;

Dynamite dynamite;

HashMap<String, Dynamite> dynamites;
HashMap<String, Audio> audios;

//MoveButton[] moveButtons = new MoveButton[9];  // The move controller has 9 buttons                 



//--- SETUP ---------------------------------------------------------------

void setup() {
  
  frameRate(60);
  size(100, 100);
  noStroke();
  
  prepareExitHandler(); // needed to execute code at shutdown
  
  moveManager = new MoveManager();     // Communicates with the connected Move controllers
  moveManager.update();

  dynamites = new HashMap<String, Dynamite>();
  
  minim = new Minim(this);  // We pass this to Minim so that it can load files from the data directory
  audios = new HashMap<String, Audio>();

  //ArrayList<String> controller_ids = moveManager.get_serials(); // Lets get the MAC adresses of all connected controllers
  
  // Make a list of dynamites & audios matching the list of controllers in moveManager
  for( Object serial: moveManager.get_serials() ) {
    String id = (String) serial;
    
    Dynamite d = new Dynamite();
    d.setFuseLength( minimumTime, maximumTime );
    d.setBurnRate(burnRate);
    dynamites.put( id, d );
    
    Audio a = new Audio( "/data","wav" );
    audios.put( id, a );    
  }

  audio = new Audio("/data","wav");

  quitTimer = new Timer(quit_countdown); // How long do you need to press the button to quit the program?

} // SETUP END



//--- DRAW --------------------------------------------------------------

void draw() {
  
  for(Object serial: moveManager.get_serials()) {
    String id = (String) serial;
    Dynamite d = dynamites.get(id);
    Audio a = audios.get(id);
    MoveController m = moveManager.get_controller(id);
    handle(d, a, m);
  }

  moveManager.update();

  //drawColorCircle( sphereColor ); // Draw time indicator

} // DRAW END



//--- OTHER METHODS -------------------------------------------------------

void handle(Dynamite dynamite, Audio audio, MoveController move) {
  
  // Send the values of the sensors to the dynamite
  float accelerometer_x = move.get_ax();
  float accelerometer_z = move.get_az();
  dynamite.updateMotion( accelerometer_x, accelerometer_z );
  
  if(!dynamite.isExplosion()) background(200);

  glow = (int)map( sin( frameCount*.05 ), -1, 1, 10, 80 );

  // Debug
  //println("Dynamite state: "+dynamite.getState());
  
  if (dynamite.isSetup()) {
    //println("Setup");
    
    audio.stopPlay("fuse","blast");
    
    // Show a glowing blue light
    move.set_leds( 0, glow, glow );
    
    if (move.isMovePressed()) {
      dynamite.arm(); // Remove the security from the detonator
      dynamite.setFuseLength(minimumTime,maximumTime); // Pick a new fuse lenght
      audio.playOnce("arm");
    }
  }

  if (dynamite.isReady()) {
    //println("Ready...");
    
    // Show a flickering red light
    int rand = (int)random(220, 255);   
    move.set_leds( rand, 0, 0);
    
    // Monitor the values of the trigger to catch ignition and failed ignition events
    String _ignition = dynamite.detonatorSuccess( move.get_trigger_value(), move.get_trigger_history() );
    
    if(_ignition == "success") {
      dynamite.igniteFuse();
      audio.playOnce("ignite");
    }
    else if(_ignition == "failure")  {
      move.set_leds( 50, 0, 0);
      println("Ignition failed. Gotta press harder on that detonator!");
      audio.playOnce("igniteFail");
    }
    
  }

  if (dynamite.isBurning()) {
    //println("The fuse is burning...");
    audio.playLoop("fuse");
    
    // Sphere is a flickering bright orange
    int rand = (int)random(100, 200);
    move.set_leds( rand, rand/2, 0 );
    
    // Change the size of the circle proportionally to the remaining time before the explosion
    float _remainingTime = dynamite.getRemainingTime();
    float _fuseLength = dynamite.getFuseLength();
    radius = (int)map( _remainingTime, 0f, _fuseLength, 0f, 90f );
    
    
    //float _fuseVolume = audio.getVolume("fuse");
    //println("Remaining time: "+_remainingTime+" | \"fuse\" volume = "+_fuseVolume);
    
    // If the remaining time is under the given threshold, mute the sound
    if( _remainingTime < soundDropTime) {
      audio.fadeOut("fuse", _remainingTime, soundDropTime, soundDropDuration);
      audio.fadeOut("burn", _remainingTime, int(soundDropTime*2), int(soundDropDuration*.1)); // This one should fade out faster
    }
    
    // Play a cue sound just before the blast 
    if ( _remainingTime <= blastCueTime ) { 
      audio.setVolume("cue", cueVolume);
      audio.playOnce("cue");
    }
    
    
    if(dynamite.isShaken()) { // Shaking burns away some more time from the fuse
      audio.playLoop("burn");
      dynamite.consume();
      int rand2 = (int)random(200, 255);
      move.set_leds( rand2, int(rand2*.7), int(rand2*.1) );
    } 
    else if(audio.isPlaying("burn")) {
      audio.stopPlay("burn"); 
    }
  }

  if (dynamite.isExplosion()) {
    //println("BOOOOOOOOOOOOOOOM!");
    audio.stopPlay("burn","arm","fuse", "cue");
    audio.playOnce("blast");
    int rand = (int)random(0, 255);
    move.set_leds( rand, rand, rand );
    move.set_rumble( 255 );
    int rand2 = (int)random(200,255);
    background( color(rand2,rand2,rand2) ); // show explosion
    radius=0;
  }

  if (dynamite.isFinished()) {
    //println("Press START to play again");
    move.set_leds( 10, 10, 10 );
    move.set_rumble( 0 );
    if (move.isStartPressed()) {
      dynamite.reset();
      radius = startRadius;
    }
  }
  else if (move.isPsPressed() && isDebugMode) {
    audio.stop();
    dynamite.reset();
    dynamite.arm();
    radius = startRadius;
  }

  // Check for how long the PS button is pressed
  if (move.isPsPressed()) {
    if (!quitTimer.isRunning())
      quitTimer.start();
    if (quitTimer.isFinished())
      exit(); // If the button was pressed long enough, close the sketch
  }
  else {
    // Stop the timer if the button is not pressed
    quitTimer.stop();
    quitTimer.reset();
  }
}

void drawColorCircle(color c) {
  pushStyle();
  colorMode(HSB);
  stroke( 0,0,255 ); // White outline, for style
  strokeWeight(3);
  
  int alpha = (int)brightness(c);   // Transparency
  
  pushMatrix();                     // Temporary adjustment of the coordinates system
  translate( width*.5, height*.5 ); // To the center
  
  fill( 0,0,255 );                  // Paint any shape that follows white
  ellipse( 0,0,radius,radius );         // Draw a white background circle
  
  fill( c, alpha );                 // Set color & transparency
  ellipse( 0,0,radius,radius );         // Draw the color circle
  
  popMatrix();                      // Forget the adjustment of the coord system
  popStyle();
}

//---- Stop ------------------------------------------------------------

// Called just before stop()
void quit() {
 
   moveManager.shutdown(); // we switch of the sphere and rumble

  // --- Cause of errors --- 
  // --- Relevant discussion: https://forum.processing.org/topic/minim-close-sound-file ---
  //audio.stop();  // stop all the sounds playing
  //audio.close(); // release AudioPlayer threads
  //minim.stop();  // release minim
}


//--- Generic operations ---------------------------------------------

// Calculates the arithmetic mean of all values in and Arraylist<Integer>
int arrayMean( ArrayList<Integer> _arrayList ) {
  int _result = arraySum(_arrayList) / _arrayList.size();
  return _result;
}

// Adds together all the values in an Arraylist<Integer>
int arraySum(ArrayList<Integer> _arrayList) {
  int _result=0;
  for ( int i: _arrayList ) {
      _result += i;
  }
  return _result;
}
