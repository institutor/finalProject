class HallScene extends Scene {
  ArrayList<CabinetScene> cabinets = new ArrayList<CabinetScene>();
  Player player = new Player();
  HallScene() {
    cabinets.add(new MiniGolf());
    cabinets.get(0).cabPos = new PVector(400, height/2);
    cabinets.add(new TetrisGame());
    cabinets.get(1).cabPos = new PVector(width/2, height/2);
    cabinets.add(new PongGame());
    cabinets.get(2).cabPos = new PVector(width - 400, height/2);
  }

  void update() { 
    player.update();
  }

  void draw() {
    background(40);
    for (CabinetScene c : cabinets) {
       c.drawCabinet();
       if (c.isNear(player.pos)) {
         fill(255);
         textAlign(CENTER, CENTER);
         text("Press E to play " + c.getLabel(), c.cabPos.x, c.cabPos.y - 60);
       }
    }
    player.draw();
    fill(255);
    textAlign(CENTER, TOP);
    text("WASD or Arrows to move  |  P to Pause in game", width / 2, 20);
  }

  void handleKey(char k, int code, boolean d) {
    player.key(k, code, d);
    if (d && (k == 'e' || k == 'E')) {
      for (CabinetScene c : cabinets) {
        if (c.isNear(player.pos)) {
          gm.switchScene(c);
        }
      }
    }
  }
}
