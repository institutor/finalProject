class Player {
  PVector pos = new PVector(200, 300);
  KeyBinds keys = new KeyBinds();
  void update() {
    PVector d = keys.direction();
    pos.add(d);
    pos.x = constrain(pos.x, 0, width);
    pos.y = constrain(pos.y, 60, height);
  }
  void draw() {
    fill(255, 0, 0);
    ellipse(pos.x, pos.y, 20, 20);
  }
  void key(char k, int code, boolean down) {
    keys.update(k, code, down);
  }
}
