
/* 
 * Execute code before shutdown
 * must add "prepareExitHandler();" in setup() 
 * 
 */

private void prepareExitHandler () {
  Runtime.getRuntime().addShutdownHook(new Thread(new Runnable() {
    public void run () {
      //System.out.println("SHUTDOWN HOOK");
      try {
        cleanUpAndClose();
      } 
      catch (Exception ex) {
        println("Error: cleanUpAndClose() returned an error:");
        ex.printStackTrace(); // not much else to do at this point
      }
    }
  }
  ));
}

// This is called on exit
void cleanUpAndClose() {
  println("Shutting down");

  quit();

  super.stop();
}

