// http://glsl.heroku.com/e#4633.5

// Wall texture from: http://texturez.com/textures/concrete/4092

String movFilename = "redline.avi";

// The agent that determines the position of the brush
Agent agent;
int x, y;

boolean debug = false;

SprayManager sprayCan;

PShader pointShader;

// Spray density distribution expressed in grayscale gradient
PImage sprayMap;

float weight;

float depthOffset;
float offsetVel;

PImage bgImage;

PGraphics paintscreen;

// This is going to retrieve the frames from the video for us
MoviePlayer m;

Path s;

void setup() {
  //size(640, , P3D);
  size(1280, 720, P3D);
  frameRate(60);
  
  m = new MoviePlayer(this, movFilename);
  
  agent = new Agent();
  
  paintscreen = createGraphics(width, height, P3D);
  
  bgImage = loadImage("wallTexture.jpg");
  
  sprayCan = new SprayManager();

  sprayMap = loadImage("sprayMap.png");

  depthOffset = 0.0;
  offsetVel = 0.0005;

  pointShader = loadShader("pointfrag.glsl", "pointvert.glsl");  
  //pointShader.set("sharpness", 0.9);
  pointShader.set( "sprayMap", sprayMap );

  //background(0);
  
  paintscreen.beginDraw();
  paintscreen.background(155);
  paintscreen.endDraw();
  
  x = width/2;
  y = height/2;
  
  // Initialize the stroke
  sprayCan.newStroke(x, y, weight);

}

void draw() {

  float animSpeed = 4;
  float animate = ((sin(radians(frameCount * animSpeed)) + 1.0) / 2.0);
  
  weight = animate * 100.0 + 100.0 + random(-10,10);
  
  agent.move();
  
  x = agent.getX();
  y = agent.getY();
  color col = m.getColorAt(x,y);
  
  sprayCan.setColor(col);
  sprayCan.setWeight(weight);

  //println(weight);

  if ( null!= sprayCan ) {
    sprayCan.newKnot( x, y, weight );
  }

  
  paintscreen.beginDraw();
  paintscreen.strokeCap(SQUARE);
  if ( null != sprayCan ) sprayCan.draw(paintscreen);
  paintscreen.endDraw();
  
  image(paintscreen,0,0);
}


void keyPressed() {
  if (key == 'r' || key == 'R') {
    
    paintscreen.beginDraw();
    paintscreen.background(155);
    paintscreen.endDraw();
    
    sprayCan.clearAll();
  }
  if (key == 's' || key == 'S') {
    saveFrame(); 
  }
}

