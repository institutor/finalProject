class TetrisGame extends CabinetScene {
  int columnCount = 10, rowCount = 20, blockSize = 40;
  int[][] board = new int[rowCount][columnCount];
  int[][][] randShapeShapes = {
    {{0,0},{-1,0},{1,0},{0,1}},
    {{0,0},{-1,0},{1,0},{1,1}},
    {{0,0},{-1,0},{1,0},{-1,1}},
    {{0,0},{0,1},{1,0},{1,1}},
    {{0,0},{1,0},{0,1},{-1,1}},
    {{0,0},{-1,0},{0,1},{1,1}},
    {{0,0},{-1,0},{1,0},{2,0}}
  };
  int[][] activerandShape;
  int randShapeX, randShapeY, randShapeType;
  int frameTick, dropSpeed = 30;
  boolean gameOver;

  String getLabel() { 
    return "Tetris"; 
  }
  int getColor() { 
    return color(0, 0, 200); 
  }

  void enter() {
    initGame();
    ui.messages.clear();
    ui.messages.add("Tetris  |  A D left/right  |  W rotate  |  S down  |  Space drop  |  Q exit");
  }

  void initGame() {
    for (int r = 0; r < rowCount; r++) for (int c = 0; c < columnCount; c++) board[r][c] = 0;
    createNewrandShape();
    gameOver = false;
    frameTick = 0;
  }

  void createNewrandShape() {
    randShapeType = int(random(randShapeShapes.length));
    activerandShape = new int[4][2];
    for (int i = 0; i < 4; i++) {
      activerandShape[i][0] = randShapeShapes[randShapeType][i][0];
      activerandShape[i][1] = randShapeShapes[randShapeType][i][1];
    }
    randShapeX = columnCount / 2;
    randShapeY = 0;
    if (collide(randShapeX, randShapeY)) gameOver = true;
  }

  boolean collide(int x, int y) {
    for (int[] block : activerandShape) {
      int boardX = x + block[0], boardY = y + block[1];
      if (boardX < 0 || boardX >= columnCount || boardY >= rowCount) return true;
      if (boardY >= 0 && board[boardY][boardX] != 0) return true;
    }
    return false;
  }

  void lockrandShape() {
    for (int[] block : activerandShape) {
      int boardX = randShapeX + block[0], boardY = randShapeY + block[1];
      if (boardY >= 0) board[boardY][boardX] = randShapeType + 1;
    }
    clearFullLines();
    createNewrandShape();
  }

  void rotaterandShape() {
    if (randShapeType == 3) return;
    for (int[] block : activerandShape) {
      int temp = block[0];
      block[0] = -block[1];
      block[1] = temp;
    }
    if (collide(randShapeX, randShapeY)) {
      for (int i = 0; i < 3; i++) {
        for (int[] block : activerandShape) {
          int temp = block[0];
          block[0] = -block[1];
          block[1] = temp;
        }
      }
    }
  }

  void moverandShape(int dx) {
    if (!collide(randShapeX + dx, randShapeY)) randShapeX += dx;
  }

  void hardDrop() {
    while (!collide(randShapeX, randShapeY + 1)) randShapeY++;
    lockrandShape();
  }

  void step() { 
    if (collide(randShapeX, randShapeY + 1)) lockrandShape(); else randShapeY++; 
  }

  void clearFullLines() {
    for (int r = rowCount - 1; r >= 0; r--) {
      boolean full = true;
      for (int c = 0; c < columnCount; c++) if (board[r][c] == 0) { full = false; break; }
      if (full) {
        for (int rr = r; rr > 0; rr--) board[rr] = board[rr - 1].clone();
        board[0] = new int[columnCount];
        r++;
      }
    }
  }

  void update() {
    if (gameOver) return;
    frameTick++;
    if (frameTick >= dropSpeed) {
      step();
      frameTick = 0;
    }
  }

  void draw() {
    background(0);
    int offsetX = (width - columnCount * blockSize) / 2;
    int offsetY = (height - rowCount * blockSize) / 2;
    stroke(150);
    noFill();
    rect(offsetX, offsetY, columnCount * blockSize, rowCount * blockSize);
    noStroke();
    for (int r = 0; r < rowCount; r++) for (int c = 0; c < columnCount; c++) {
      int v = board[r][c];
      if (v != 0) {
        fill(colorPalette(v - 1));
        rect(offsetX + c * blockSize, offsetY + r * blockSize, blockSize, blockSize);
      }
    }
    for (int[] block : activerandShape) {
      int boardX = randShapeX + block[0], boardY = randShapeY + block[1];
      if (boardY >= 0) {
        fill(colorPalette(randShapeType));
        rect(offsetX + boardX * blockSize, offsetY + boardY * blockSize, blockSize, blockSize);
      }
    }
    ui.draw();
    if (gameOver) {
      fill(255, 0, 0);
      textAlign(CENTER, CENTER);
      textSize(48);
      text("GAME OVER", width / 2, height / 2);
      textSize(12);
    }
  }

  int colorPalette(int index) {
    int[] palette = {
      color(200, 0, 200), color(255, 165, 0), color(0, 0, 255),
      color(255, 255, 0), color(0, 255, 0), color(255, 0, 0),
      color(0, 255, 255)
    };
    return palette[index % palette.length];
  }

  void handleKey(char key, int code, boolean down) {
    if (!down) return;
    if (key == 'q' || key == 'Q') {
      gm.switchScene(new HallScene());
    } else if (gameOver) {
      initGame();
    } else if (key == 'a' || key == 'A') {
      moverandShape(-1);
    } else if (key == 'd' || key == 'D') {
      moverandShape(1);
    } else if (key == 's' || key == 'S') {
      if (!collide(randShapeX, randShapeY + 1)) randShapeY++;
    } else if (key == 'w' || key == 'W') {
      rotaterandShape();
    } else if (key == ' ') {
      hardDrop();
    }
  }

  void handleMouse(boolean pressed) {}
  void handleDrag() {}
}
