class GameManager {
  Scene currentScene;
  void init() {
    currentScene = new HallScene();
    currentScene.enter();
  }

  void update() {
    currentScene.update();
    currentScene.draw();
  }

  void handleKey(char k, int code, boolean down) {
    currentScene.handleKey(k, code, down);
  }

  void handleMouse(boolean pressed) {
    currentScene.handleMouse(pressed);
  }

  void handleDrag() {
    currentScene.handleDrag();
  }

  void switchScene(Scene next) {
    currentScene.exit();
    currentScene = next;
    currentScene.enter();
  }
}
