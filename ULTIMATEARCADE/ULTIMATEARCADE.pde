GameManager gm;

void setup() {
  size(960, 540);
  gm = new GameManager();
  gm.init();
}

void draw() {
  gm.update();
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
