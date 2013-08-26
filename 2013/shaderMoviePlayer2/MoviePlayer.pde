import processing.video.*;

//String PATH = "transit.mov";

class MoviePlayer {
  
  Movie video;
  PImage frame;
  
  MoviePlayer(PApplet parent, String filename) {
    video = new Movie(parent, filename);
    video.play();  
    video.speed(1);
    video.volume(1);
  }
  
  PImage getFrame() {
    return video;
  }
  
  // FIX ME
  color getColorAt(int x, int y) {
    int index = y * video.width + x;
    println("picking color at index " + index);
    color pixelColor = video.pixels[index];
    return pixelColor;
  }

}

// This function is required. It takes care of preparing
// video frames for us as they arrive from the movie.
void movieEvent(Movie m) {
  m.read();
}
