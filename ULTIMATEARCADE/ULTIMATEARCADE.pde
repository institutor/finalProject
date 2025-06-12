import processing.sound.*;

GameManager gm;
PApplet papplet;

void setup() {
  size(1920, 1080);
  fullScreen();
  papplet = this;
  gm = new GameManager();
  gm.init();
}

void draw() {
  gm.update();
  gm.draw();
}

void keyPressed() {
  gm.handleKey(key, keyCode, true);
}

void keyReleased() {
  gm.handleKey(key, keyCode, false);
}

void mousePressed() {
  gm.handleMouse(true);
}

void mouseReleased() {
  gm.handleMouse(false);
}

void mouseDragged() {
  gm.handleDrag();
}
