class HallScene extends Scene {
  ArrayList<CabinetScene> cabinets = new ArrayList<CabinetScene>();
  Player player = new Player();
  HallScene() {
    cabinets.add(new MiniGolf());
    cabinets.get(0).cabPos = new PVector(400, 100);
  }

  void update() {
    player.update();
  }

  void draw() {
    background(40);
    for (CabinetScene c : cabinets) c.drawCabinet();
    player.draw();
    fill(255);
    text("                                                                                                    Arrows to move  |  E to enter  |  Q to quit game", 10, 20); // the large indent you see here is a temporary fix for my text going outside of the screen for some reason
  }
  void handleKey(char k, int code, boolean down) {
    player.key(k, code, down);
    if (down && (k == 'e' || k == 'E')) {
      for (CabinetScene c : cabinets)
        if (c.isNear(player.pos))
          gm.switchScene(c);
    }
  }
}
