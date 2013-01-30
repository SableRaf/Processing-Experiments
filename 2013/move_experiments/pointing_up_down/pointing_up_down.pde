
// Import the PS Move API Package
import io.thp.psmove.*;

PSMove [] moves;

int[] angleBuffer;

void setup() {
  size(250, 500);
  colorMode(HSB);
  moves = new PSMove[psmoveapi.count_connected()];
  for (int i=0; i<moves.length; i++) {
    moves[i] = new PSMove(i);
  }
}

void draw() {
  background(155);
  drawBackground();
  for (int i=0; i<moves.length; i++) {
    handle(i, moves[i]);
  }
}

void handle(int i, PSMove move)
{
  float [] ax = {
    0.f
  }
  , ay = {
    0.f
  }
  , az = {
    0.f
  };
  float [] gx = {
    0.f
  }
  , gy = {
    0.f
  }
  , gz = {
    0.f
  };
  float [] mx = {
    0.f
  }
  , my = {
    0.f
  }
  , mz = {
    0.f
  };

  while (move.poll () != 0) {
  } // get button presses here

  move.get_accelerometer_frame(io.thp.psmove.Frame.Frame_SecondHalf, ax, ay, az);
  move.get_gyroscope_frame(io.thp.psmove.Frame.Frame_SecondHalf, gx, gy, gz);
  move.get_magnetometer_vector(mx, my, mz);

  int glow = (int)map(sin(frameCount*.02), -1, 1, 20, 200);

  int hue = (int) map(getOrientation(my[0]), 0, 2*PI, 0, 255 );
  color sphereColor = color(hue, 255, 255);
  int r = (int)red(sphereColor); 
  int g = (int)green(sphereColor);
  int b = (int)blue(sphereColor);
  move.set_leds(r, g, b);
  move.update_leds();
}

float getOrientation(float my) {
  //println("my = "+ my);
  float angle = map(my, -1, 1, 0, PI);
  angle = constrain(angle, 0, PI); // make sure we don't go out of bounds
  println("angle = "+ angle);
  drawArrow(angle);
  return angle;
}

void drawBackground() {
  pushMatrix();
  noStroke();
  fill(255);
  translate(0, height/2);
  ellipse(0, 0, height*.99, height*.99);
  popMatrix();
}

void drawArrow(float angle) {
  pushMatrix();
  noStroke();
  fill(100);
  translate(0, height/2);
  scale(20);
  rotate(angle+PI/2);
  beginShape();
  vertex(-10,0);
  vertex(0,-1);
  vertex(10,0);
  vertex(0,1);
  vertex(-10,0);
  endShape(CLOSE);
  popMatrix();
}

