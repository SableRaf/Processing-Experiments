PFont fText, fNum;

int textSize = 270;
int numSize = 400;

int count = 0;

void setup() {
  size(800,800, P2D);
  
  // Show all active fonts
  println(PFont.list());
  
  fText = createFont("Consolas-bold", textSize);
  fNum = createFont("Consolas-bold", numSize);
  textAlign(CENTER);
}

void draw() {
  
  colorMode(HSB, 1.0);
  float h = (noise(frameCount*0.01) + noise(100+frameCount*0.01)) % 1.0;
  background(h, 1.0, 1.0);
  
  textFont(fText);
  pushMatrix();
  translate(width/2, textSize - 60);
  text("KINDA", 0, 0 ); 
  popMatrix(); 
  
  if( count > 0 ) {
    textFont(fNum);
    pushMatrix();
    translate( width/2, height/2 + numSize*0.31 );
    text( nf( count, 0 ), 0, 0 );
    popMatrix();
  }
  
  textFont(fText);
  pushMatrix();
  translate( width/2, height - 40 );
  text("LIKE", 0, 0);
  popMatrix(); 
}

void keyPressed() {
  // increment our kindalike counter
  if(key == ' ') {
    count++;
  }
}
