import peasy.*; 
import fisica.*;

GameManager gameManager;
PeasyCam cam; 

void settings() {
  size(1280, 720, P3D); 
}

void setup() {
  Fisica.init(this); 
  gameManager = new GameManager(this); 
  gameManager.init();
  cam = new PeasyCam(this, 0, 0, 0, 500); 
  cam.setMinimumDistance(50);
  cam.setMaximumDistance(1000);
}

void draw() {
  background(50);
  gameManager.update();
  gameManager.draw();
}

void keyPressed() {
  gameManager.handleInput(keyCode, key); 
}

void mousePressed() {
  gameManager.handleMousePress(mouseButton);
}

void mouseReleased() {
  gameManager.handleMouseRelease(mouseButton);
}

void mouseDragged() {
  gameManager.handleMouseDrag();
}
