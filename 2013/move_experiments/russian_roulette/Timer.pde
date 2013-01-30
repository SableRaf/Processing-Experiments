// Learning Processing
// Daniel Shiffman

class Timer {
 
  boolean running;
  
  int savedTime; // When Timer started
  int totalTime; // How long Timer should last
  
  int passedTime;
  
  Timer(int _TotalTime) {
    totalTime = _TotalTime;
    running = false;
  }
  
  // Starting the timer
  void start() {
    running = true;
    // When the timer starts it stores the current time in milliseconds.
    savedTime = millis();
  }
  
  // The function isFinished() returns true if totalTime has passed. 
  // The work of the timer is farmed out to this method.
  boolean isFinished() { 
    // Check how much time has passed
    passedTime = millis() - savedTime;
    if (passedTime > totalTime) {
      running = false;
      return true;
    } else {
      return false;
    }
   }
   
   void reset() {
     passedTime = 0;
   }
   
   void stop() {
     running = false; 
   }
   
   boolean isRunning() {
     isFinished(); // updates the value of running
     return running;
   }
   
   int getTotalTime() {
    return totalTime; 
   }
   
   int getRemaining() {
     int remaining = totalTime - passedTime;
     return remaining;
   }
   
   public void setLength(int time) {
     totalTime = time;
   }
   
 }
