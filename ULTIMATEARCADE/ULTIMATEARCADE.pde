GameManager gameManager;

void setup() {
  size(800, 600, P3D); 
  println(" making Processing Sketch");
  gameManager = new GameManager();
  gameManager.init();
  textAlign(LEFT, TOP);
  textSize(16);
}

void draw() {
  background(50, 80, 100); 

  gameManager.update();
  gameManager.draw();
}

void keyPressed() {
  if (gameManager != null && gameManager.currentScene != null) {
    gameManager.currentScene.handleKeyPressed(key, keyCode);
  }
}

void keyReleased() { 
  if (gameManager != null && gameManager.currentScene != null) {
    gameManager.currentScene.handleKeyReleased(key, keyCode);
  }
}

void mousePressed() {
  if (gameManager != null && gameManager.currentScene != null) {
    gameManager.currentScene.handleMousePressed(mouseButton, mouseX, mouseY);
  }
}

void mouseReleased() {
  if (gameManager != null && gameManager.currentScene != null) {
    gameManager.currentScene.handleMouseReleased(mouseButton, mouseX, mouseY);
  }
}

void mouseDragged() {
  if (gameManager != null && gameManager.currentScene != null) {
    gameManager.currentScene.handleMouseDragged(mouseX, mouseY);
  }
}
