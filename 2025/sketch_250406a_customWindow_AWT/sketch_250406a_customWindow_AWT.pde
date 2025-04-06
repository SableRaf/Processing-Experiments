// Global variables for button states and window control
boolean overCloseBtn = false;
boolean overMinBtn = false;
boolean overFullBtn = false;
boolean isFullscreen = false;
int prevWidth, prevHeight, prevX, prevY;

// Dragging state
boolean isDragging = false;
int dragOffsetX, dragOffsetY;

// Resizing state
boolean isResizing = false;
boolean overResizeArea = false;
int resizeStartX, resizeStartY;
int initialWidth, initialHeight;
int resizeHandleSize = 15;

void setup() {
  size(400, 300);
  
  // Store original dimensions
  prevWidth = width;
  prevHeight = height;
  prevX = 100;
  prevY = 100;
  
  // Remove window decoration
  surface.setVisible(false);
  surface.setLocation(prevX, prevY);
  
  java.awt.Frame frame = ((processing.awt.PSurfaceAWT.SmoothCanvas) surface.getNative()).getFrame();
  frame.removeNotify();
  frame.setUndecorated(true);
  frame.setResizable(true); // Allow Java-level resizing
  
  frame.addNotify();
  surface.setVisible(true);
  
  // Set initial background
  background(240);
}

void draw() {
  // Clear background
  background(240);
  
  // Draw custom title bar
  fill(50);
  noStroke();
  rect(0, 0, width, 30);
  
  // Draw window controls
  // Close button (red X)
  if (overCloseBtn) fill(255, 80, 80); else fill(255, 0, 0);
  rect(width-30, 0, 30, 30);
  stroke(255);
  strokeWeight(2);
  line(width-23, 7, width-7, 23);
  line(width-7, 7, width-23, 23);
  
  // Minimize button (yellow with white line)
  if (overMinBtn) fill(255, 255, 130); else fill(255, 255, 0);
  noStroke();
  rect(width-60, 0, 30, 30);
  stroke(255);
  strokeWeight(2);
  line(width-53, 15, width-37, 15);
  
  // Fullscreen button (green with white square)
  if (overFullBtn) fill(120, 255, 120); else fill(0, 255, 0);
  noStroke();
  rect(width-90, 0, 30, 30);
  stroke(255);
  strokeWeight(2);
  if (!isFullscreen) {
    rect(width-83, 7, 16, 16);
  } else {
    rect(width-80, 10, 10, 10);
    line(width-70, 10, width-80, 10);
    line(width-70, 10, width-70, 20);
    line(width-70, 20, width-80, 20);
  }
  
  // Draw resize handle indicator
  noFill();
  if (overResizeArea) {
    stroke(0, 120, 255);
    strokeWeight(2);
  } else {
    stroke(150);
    strokeWeight(1);
  }
  // Bottom-right corner resize indicator
  line(width-resizeHandleSize, height, width, height-resizeHandleSize);
  line(width, height-resizeHandleSize/2, width-resizeHandleSize/2, height);
  
  // Reset stroke settings
  strokeWeight(1);
  
  // Your drawing code for the rest of the sketch would go here
  fill(0);
  textAlign(CENTER, CENTER);
  textSize(20);
  text("Custom Window", width/2, height/2);
  
  if (isFullscreen) {
    fill(200);
    textSize(14);
    text("Press ESC to exit fullscreen", width/2, height-20);
  }
}

void mousePressed() {
  // Check if mouse is over buttons
  checkButtons();
  
  // Check if mouse is over the title bar (but not over buttons)
  if (mouseY < 30 && !overCloseBtn && !overMinBtn && !overFullBtn) {
    isDragging = true;
    
    // Get system-level coordinates
    java.awt.Point mousePos = java.awt.MouseInfo.getPointerInfo().getLocation();
    java.awt.Frame frame = ((processing.awt.PSurfaceAWT.SmoothCanvas) surface.getNative()).getFrame();
    java.awt.Point framePos = frame.getLocation();
    
    // Calculate the offset
    dragOffsetX = mousePos.x - framePos.x;
    dragOffsetY = mousePos.y - framePos.y;
  }
  
  // Check if mouse is over resize area
  if (overResizeArea) {
    isResizing = true;
    resizeStartX = mouseX;
    resizeStartY = mouseY;
    initialWidth = width;
    initialHeight = height;
  }
  
  // Handle button clicks
  if (overCloseBtn) {
    exit(); // Close the application
  }
  
  if (overMinBtn) {
    // Get the frame and minimize it
    java.awt.Frame frame = ((processing.awt.PSurfaceAWT.SmoothCanvas) surface.getNative()).getFrame();
    frame.setState(java.awt.Frame.ICONIFIED);
  }
  
  if (overFullBtn) {
    toggleFullscreen();
  }
}

void mouseReleased() {
  isDragging = false;
  isResizing = false;
}

void mouseMoved() {
  checkButtons();
  
  // Check if mouse is over resize area (bottom-right corner)
  overResizeArea = (mouseX > width - resizeHandleSize && mouseY > height - resizeHandleSize);
  
  // Change cursor based on mouse position
  if (overResizeArea) {
    //cursor(SOUTHEAST_RESIZE);
  } else if (mouseY < 30 && !overCloseBtn && !overMinBtn && !overFullBtn) {
    cursor(MOVE);
  } else {
    cursor(ARROW);
  }
}

void checkButtons() {
  // Check if mouse is over buttons
  overCloseBtn = (mouseX > width-30 && mouseX < width && mouseY > 0 && mouseY < 30);
  overMinBtn = (mouseX > width-60 && mouseX < width-30 && mouseY > 0 && mouseY < 30);
  overFullBtn = (mouseX > width-90 && mouseX < width-60 && mouseY > 0 && mouseY < 30);
}

void mouseDragged() {
  // Handle window dragging
  if (isDragging) {
    // Get current mouse position in screen coordinates
    java.awt.Point mousePos = java.awt.MouseInfo.getPointerInfo().getLocation();
    
    // Calculate new window position
    int newX = mousePos.x - dragOffsetX;
    int newY = mousePos.y - dragOffsetY;
    
    // Update window position
    java.awt.Frame frame = ((processing.awt.PSurfaceAWT.SmoothCanvas) surface.getNative()).getFrame();
    frame.setLocation(newX, newY);
  }
  
  // Handle window resizing
  if (isResizing) {
    // Calculate new size
    int newWidth = max(200, initialWidth + (mouseX - resizeStartX));
    int newHeight = max(150, initialHeight + (mouseY - resizeStartY));
    
    // Resize window
    surface.setSize(newWidth, newHeight);
  }
  
  // Update button hover states when dragging
  checkButtons();
  
  // Update cursor for resize area
  if (isResizing) {
    //cursor(SOUTHEAST_RESIZE);
  }
}

void keyPressed() {
  // Exit fullscreen when ESC is pressed
  if (key == ESC && isFullscreen) {
    // Prevent default ESC behavior (which would close the sketch)
    key = 0;
    // Exit fullscreen mode
    exitFullscreen();
  }
}

void toggleFullscreen() {
  if (!isFullscreen) {
    enterFullscreen();
  } else {
    exitFullscreen();
  }
}

void enterFullscreen() {
  java.awt.Frame frame = ((processing.awt.PSurfaceAWT.SmoothCanvas) surface.getNative()).getFrame();
  
  // Store current position and size
  prevX = frame.getLocation().x;
  prevY = frame.getLocation().y;
  prevWidth = width;
  prevHeight = height;
  
  // Go fullscreen
  java.awt.GraphicsEnvironment env = java.awt.GraphicsEnvironment.getLocalGraphicsEnvironment();
  java.awt.GraphicsDevice device = env.getDefaultScreenDevice();
  java.awt.DisplayMode mode = device.getDisplayMode();
  surface.setSize(mode.getWidth(), mode.getHeight());
  frame.setLocation(0, 0);
  
  isFullscreen = true;
}

void exitFullscreen() {
  java.awt.Frame frame = ((processing.awt.PSurfaceAWT.SmoothCanvas) surface.getNative()).getFrame();
  
  // Restore previous size and position
  surface.setSize(prevWidth, prevHeight);
  frame.setLocation(prevX, prevY);
  
  isFullscreen = false;
}
