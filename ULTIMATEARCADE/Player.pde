class Player {
  private PVector pos = new PVector(200, 300);
  private KeyBinds keys = new KeyBinds();
  void update() {
    PVector d = keys.direction();
    pos.add(d);
    pos.x = constrain(pos.x, 0, width);
    pos.y = constrain(pos.y, 60, height);
  }
  void draw() {
    if (gm.playerAvatar != null) {
      imageMode(CENTER);
      image(gm.playerAvatar, pos.x, pos.y, 40, 40);
    } else {
      fill(255, 0, 0);
      ellipse(pos.x, pos.y, 20, 20);
    }
  }
  void key(char k, int code, boolean down) {
    keys.update(k, code, down);
  }
}
