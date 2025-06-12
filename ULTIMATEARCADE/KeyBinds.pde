class KeyBinds {
  private boolean up, down, left, right;
  void update(char k, int code, boolean d) {
    if (k == CODED) {
      if (code == UP) up = d;
      if (code == DOWN) down = d;
      if (code == LEFT) left = d;
      if (code == RIGHT) right = d;
    } else {
        if (k == 'w' || k == 'W') up = d;
        if (k == 's' || k == 'S') down = d;
        if (k == 'a' || k == 'A') left = d;
        if (k == 'd' || k == 'D') right = d;
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
