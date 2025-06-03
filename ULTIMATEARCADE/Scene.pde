abstract class Scene {
  void enter() {
  }
  void exit() {
  }
  abstract void update();
  abstract void draw();
  void handleKey(char k, int code, boolean down) {
  }
  void handleMouse(boolean pressed) {
  }
  void handleDrag() {
  }
}
