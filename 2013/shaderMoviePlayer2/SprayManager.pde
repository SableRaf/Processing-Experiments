

class SprayManager {
 
 ArrayList<Path> strokeList;
 
 color col;
 float size;
 
 SprayManager() {
   strokeList = new ArrayList<Path>();
   col = color(0);
 }
 
 // Draw newly added points 
 // NOTE: points are only drawn once so you should not redraw the background
 void draw(PGraphics buffer) {
   for(Path p: strokeList) {
     p.draw(buffer);
   }
 }
 
 // Delete all the strokes
 void clearAll() {
   
   for(Path p: strokeList) {
     p.clear();
   }
   
   strokeList.clear();
 }
 
 void newStroke(float x, float y, float weight) {
   
   Knot startingKnot = new Knot(x, y, weight, col);
   Path p = new Path(startingKnot);
   strokeList.add(p);
   
 }
 
 // Add a point the the current path
 void newKnot(float x, float y, float weight) {
   
   Knot newKnot = new Knot(x, y, weight, col);
   
   Path activePath = getActivePath();
   activePath.add(newKnot);
   
 }
 
 // Return the path beeing drawn at the moment
 Path getActivePath() {
   return strokeList.get( strokeList.size() - 1 );
 }
 
 // Set the size of the spray
 void setWeight(float weight) {
   size = weight;
 }
 
 // Set the color of the spray
 void setColor(color tint) {
   col = tint;
 }
 
 color getColor() {
   return col;
 }

}
