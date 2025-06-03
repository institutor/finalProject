class HallScene extends Scene {
  ArrayList<CabinetScene> cabinets = new ArrayList<CabinetScene>();
  Player player = new Player();

  HallScene() {
    cabinets.add(new MiniGolf());
    cabinets.get(0).cabPos = new PVector(400, 100);
    cabinets.add(new TetrisGame());
    cabinets.get(1).cabPos = new PVector(700, 100);
  }

  void update() { player.update(); }

  void draw() {
    background(40);
    for (CabinetScene c : cabinets) c.drawCabinet();
    player.draw();
    fill(255);
    textAlign(CENTER, TOP);
    text("Arrows move  |  E enter  |  Q quit game", width / 2, 20);
  }

  void handleKey(char k, int code, boolean d) {
    player.key(k, code, d);
    if (d && (k == 'e' || k == 'E')) {
      for (CabinetScene c : cabinets) if (c.isNear(player.pos)) gm.switchScene(c);
    }
  }
}
