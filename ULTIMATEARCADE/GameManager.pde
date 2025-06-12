class GameManager {
  Scene currentScene;
  boolean paused = false;
  String playerName;
  PImage playerAvatar;

  void init() {
    currentScene = new NameInputScene();
    currentScene.enter();
  }
  void update() {
    if (!paused) {
      currentScene.update();
    }
  }

  void draw() {
    currentScene.draw();
    if (paused) {
      fill(0, 150);
      rect(0, 0, width, height);
      fill(255);
      textAlign(CENTER, CENTER);
      textSize(50);
      text("PAUSED", width/2, height/2);
      textSize(12);
    }
  }

  void handleKey(char k, int code, boolean down) {
    if (down && (k == 'p' || k == 'P')) {
      if (!(currentScene instanceof NameInputScene)) {
         paused = !paused;
         return;
      }
    }
    if (!paused) {
      currentScene.handleKey(k, code, down);
    }
  }
  void handleMouse(boolean pressed) {
    if (!paused) {
      currentScene.handleMouse(pressed);
    }
  }
  void handleDrag() {
    if (!paused) {
      currentScene.handleDrag();
    }
  }
  void switchScene(Scene next) {
    currentScene.exit();
    currentScene = next;
    paused = false;
    currentScene.enter();
  }
}
