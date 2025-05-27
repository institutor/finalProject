class Scene {
  GameManager manager; 

  Scene(GameManager manager) {
    this.manager = manager;
  }

  void enter() {
    println("Scene (" + this.getClass().getSimpleName() + "): enter() called");
  }

  void exit() {
    println("Scene (" + this.getClass().getSimpleName() + "): exit() called");
  }

  void update() {
  }

  void draw() {
  }

  void handleKeyPressed(char key, int keyCode) {}
  void handleKeyReleased(char key, int keyCode) {} 
  void handleMousePressed(int mouseButton, int mx, int my) {}
  void handleMouseReleased(int mouseButton, int mx, int my) {}
  void handleMouseDragged(int mx, int my) {}
}
