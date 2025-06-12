class NameInputScene extends Scene {
  private String playerNameInput = "";

  void update() {
  }

  void draw() {
    background(20, 20, 80);
    textAlign(CENTER, CENTER);
    fill(255);
    textSize(32);
    text("Enter Your NAME:", width / 2, height / 2 - 80);
    fill(200);
    rect(width / 2 - 200, height / 2 - 25, 400, 50);
    fill(0);
    textSize(28);
    text(playerNameInput, width/2, height/2);
    fill(150);
    textSize(20);
    text("Press enter to Begin!!!", width / 2, height / 2 + 80);
  }

  void handleKey(char k, int code, boolean down) {
    if (!down) {
      return;
    }

    if ((k >= 'a' && k <= 'z') || (k >= 'A' && k <= 'Z') || (k >= '0' && k <= '9')) {
      if (playerNameInput.length() < 12) {
        playerNameInput += k;
      }
    } else if (code == BACKSPACE) {
      if (playerNameInput.length() > 0) {
        playerNameInput = playerNameInput.substring(0, playerNameInput.length() - 1);
      }
    } else if (code == ENTER || code == RETURN) {
      if (playerNameInput.length() > 0) {
        gm.playerName = playerNameInput;
        try {
          gm.playerAvatar = loadImage("avatar.png");
        } catch (Exception e) {
          println("Avatar loading failed.");
        }
        gm.switchScene(new HallScene());
      }
    }
  }
}
