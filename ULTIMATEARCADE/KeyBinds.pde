class KeyBinds {
  boolean up, down, left, right;
  void update(char k, int code, boolean d) {
    if (k == CODED) {
      if (code == UP) up = d;
      if (code == DOWN) down = d;
      if (code == LEFT) left = d;
      if (code == RIGHT) right = d;
    }
  }
  PVector direction() {
    PVector v = new PVector();
    if (up) v.y -= 3;
    if (down) v.y += 3;
    if (left) v.x -= 3;
    if (right) v.x += 3;
    return v;
  }
}
