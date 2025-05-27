class GameManager {
  Scene currentScene;

  GameManager() {
    println("GameManager: Initialized");
  }

  void init() {
    println("GameManager: init() called");
    currentScene = new HallScene(this); 
    currentScene.enter();
  }

  void update() {
    if (currentScene != null) {
      currentScene.update();
    } else {
      println("GameManager: No current scene to update");
    }
  }

  void draw() {
    if (currentScene != null) {
      currentScene.draw();
    } else {
      println("GameManager: No current scene to draw");
      fill(255);
      text("No current scene loaded.", 50, 50);
    }
  }
  
  void switchScene(Scene newScene) {
    if (currentScene != null) {
      currentScene.exit();
    }
    currentScene = newScene;
    if (currentScene != null) {
      currentScene.enter();
    }
  }
}
