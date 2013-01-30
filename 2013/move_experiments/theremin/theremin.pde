/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/43125*@* */
/* !do not delete the line above, required for linking your tweak if you re-upload */

// Sound
import ddf.minim.signals.*;
import ddf.minim.*;

Minim minim; 
AudioOutput out; 
SawWave saw;
SineWave sine;

// PS Move
import io.thp.psmove.*;

PSMove move;
PSMoveTracker tracker;
byte [] pixels;
PImage img;

float x[] = new float[1];
float y[] = new float[1];
float r[] = new float[1];


void setup() {
  size(640, 480);

  tracker_init();

  // example from Géridan et Lafargue
  minim = new Minim(this); 
  out = minim.getLineOut(Minim.STEREO, 512);
  saw=new SawWave(440, 1, 44100);
  sine=new SineWave(440, 1, 44100);
  
  // Sets how many milliseconds it should take to transition
  // from one frequency to another when setting a new frequency.
  sine.portamento(100);
  saw.portamento(100);
  
  out.addSignal(saw);
  out.addSignal(sine);
}

void draw() {
  tracker_update();
  
  int trigger=0;
  while (move.poll() != 0) {
    trigger = move.get_trigger();
  }
  
  // Map the Move pos to the frequencies
  float hz1 = map(x[0],0, width, 200, 800);
  float hz2 = map(y[0],0, height, 200, 800);
  
  saw.setFreq(hz1);
  sine.setFreq(hz2);
  
  // The more you press the trigger, the louder the sound
  float a = map(trigger, 0,255,0,1);
  saw.setAmp(a);
  sine.setAmp(a);
}

void stop() {
  minim.stop();
  super.stop();
}


void tracker_init() {
  move = new PSMove();
  move.set_leds(255, 255, 255);
  move.update_leds();
  tracker = new PSMoveTracker();
  tracker.set_mirror(1); // Mirror the tracker image horizontally
  while (tracker.enable (move) != Status.Tracker_CALIBRATED);

  // Initialize coordinates
  x = new float[1];
  y = new float[1];
  r = new float[1];
}

void tracker_update() {
  tracker.update_image();
  tracker.update();

  PSMoveTrackerRGBImage image = tracker.get_image();
  if (pixels == null) {
    pixels = new byte[image.getSize()];
  }
  image.get_bytes(pixels);
  if (img == null) {
    img = createImage(image.getWidth(), image.getHeight(), RGB);
  }
  img.loadPixels();
  for (int i=0; i<img.pixels.length; i++) {
    // We need to AND the values with 0xFF to convert them to unsigned values
    img.pixels[i] = color(pixels[i*3] & 0xFF, pixels[i*3+1] & 0xFF, pixels[i*3+2] & 0xFF);
  }
  img.updatePixels();
  image(img, 0, 0);
  
  tracker.get_position(move, x, y, r);
}

