class TetrisGame extends CabinetScene {
  int columnCount = 10, rowCount = 20, blockSize = 40;
  int[][] board = new int[rowCount][columnCount];
  int[][][] pieceShapes = {
    {{0, -1}, {0, 0}, {0, 1}, {0, 2}},
    {{0, 0}, {1, 0}, {0, 1}, {1, 1}},
    {{-1, 0}, {0, 0}, {1, 0}, {0, 1}},
    {{-1, -1}, {-1, 0}, {0, 0}, {1, 0}},
    {{-1, 0}, {0, 0}, {1, 0}, {1, -1}},
    {{-1, 1}, {0, 1}, {0, 0}, {1, 0}},
    {{-1, 0}, {0, 0}, {0, 1}, {1, 1}}
  };
  int[][] activePiece;
  int pieceX, pieceY, pieceType;
  int frameTick, dropSpeed = 30;
  boolean gameOver;
  int points;
  SoundFile clearSound, dropSound, themeMusic, gameOverSound;
  Leaderboard leaderboard;

  String getLabel() { 
    return "Tetris"; 
  }
  int getColor() { 
    return color(0, 0, 200); 
  }

  void exit() {
    if (themeMusic != null) {
      themeMusic.stop();
    }
  }

  void enter() {
    leaderboard = new Leaderboard("tetris_scores.txt");
    initGame();
    ui.messages.clear();
    ui.messages.add("Tetris  |  A D left/right  |  W rotate  |  S down  |  Space drop  |  Q exit  |  P pause");
    try {
      clearSound = new SoundFile(papplet, "line.wav");
      dropSound = new SoundFile(papplet, "drop.wav");
      gameOverSound = new SoundFile(papplet, "gameover.wav");
      themeMusic = new SoundFile(papplet, "music.mp3");
      themeMusic.loop();
    } catch(Exception e) {
      println("Could not load Tetris sound files.");
    }
  }

  void initGame() {
    for (int r = 0; r < rowCount; r++) {
      for (int c = 0; c < columnCount; c++) {
        board[r][c] = 0;
      }
    }
    createNewPiece();
    gameOver = false;
    frameTick = 0;
    points = 0;
  }

  void createNewPiece() {
    pieceType = int(random(pieceShapes.length));
    activePiece = new int[4][2];
    for (int i = 0; i < 4; i++) {
      activePiece[i][0] = pieceShapes[pieceType][i][0];
      activePiece[i][1] = pieceShapes[pieceType][i][1];
    }
    pieceX = columnCount / 2;
    pieceY = 2; 
    if (collide(pieceX, pieceY)) {
       gameOver = true;
       leaderboard.addScore(gm.playerName, points);
       if (gameOverSound != null) {
         gameOverSound.play();
       }
       if (themeMusic != null) {
         themeMusic.stop();
       }
    }
  }

  boolean collide(int x, int y) {
    for (int[] block : activePiece) {
      int boardX = x + block[0], boardY = y + block[1];
      if (boardX < 0 || boardX >= columnCount || boardY >= rowCount) {
        return true;
      }
      if (boardY >= 0 && board[boardY][boardX] != 0) {
        return true;
      }
    }
    return false;
  }

  void lockPiece() {
    for (int[] block : activePiece) {
      int boardX = pieceX + block[0], boardY = pieceY + block[1];
      if (boardY >= 0) {
        board[boardY][boardX] = pieceType + 1;
      }
    }
    clearFullLines();
    createNewPiece();
  }
  
  void rotatePiece() {
    if (pieceType == 1) {
      return;
    }
    
    int[][] tempPiece = new int[4][2];
    for(int i=0; i < activePiece.length; i++) {
        tempPiece[i][0] = activePiece[i][0];
        tempPiece[i][1] = activePiece[i][1];
    }
    
    for (int[] block : tempPiece) {
        int temp = block[0];
        block[0] = -block[1];
        block[1] = temp;
    }
    
    int[][] backupPiece = activePiece;
    activePiece = tempPiece; 
    
    if (collide(pieceX, pieceY)) {
        activePiece = backupPiece;
    }
  }

  void movePiece(int dx) {
    if (!collide(pieceX + dx, pieceY)) {
      pieceX += dx;
    }
  }

  void hardDrop() {
    while (!collide(pieceX, pieceY + 1)) {
      pieceY++;
    }
    lockPiece();
    if (dropSound != null) {
      dropSound.play();
    }
  }

  void step() { 
    if (collide(pieceX, pieceY + 1)) {
       lockPiece(); 
    } else {
       pieceY++; 
    }
  }

  void clearFullLines() {
    int linesCleared = 0;
    for (int r = rowCount - 1; r >= 0; r--) {
      boolean full = true;
      for (int c = 0; c < columnCount; c++) {
        if (board[r][c] == 0) {
          full = false; 
          break; 
        }
      }
      if (full) {
        linesCleared++;
        for (int rr = r; rr > 0; rr--) {
          board[rr] = board[rr - 1].clone();
        }
        board[0] = new int[columnCount];
        r++;
        points += 1000;
      }
    }
    if (linesCleared > 0 && clearSound != null) {
      clearSound.play();
    }
  }

  void update() {
    if (gameOver) {
      return;
    }
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
    stroke(40);
    for(int i = 1; i < columnCount; i++) {
      line(offsetX + i * blockSize, offsetY, offsetX + i * blockSize, offsetY + rowCount * blockSize);
    }
    for(int i = 1; i < rowCount; i++) {
      line(offsetX, offsetY + i * blockSize, offsetX + columnCount * blockSize, offsetY + i * blockSize);
    } 
    stroke(150);
    noFill();
    rect(offsetX, offsetY, columnCount * blockSize, rowCount * blockSize);
    noStroke();
    for (int r = 0; r < rowCount; r++) {
      for (int c = 0; c < columnCount; c++) {
        int v = board[r][c];
        if (v != 0) {
          fill(colorPalette(v - 1));
          rect(offsetX + c * blockSize, offsetY + r * blockSize, blockSize, blockSize);
        }
      }
    }
    if (!gameOver) {
      for (int[] block : activePiece) {
        int boardX = pieceX + block[0], boardY = pieceY + block[1];
        if (boardY >= 0) {
          fill(colorPalette(pieceType));
          rect(offsetX + boardX * blockSize, offsetY + boardY * blockSize, blockSize, blockSize);
        }
      }
    }
      ui.draw();
      fill(255);
      textAlign(LEFT, TOP);
      textSize(24);
      text("Score: " + points, 10, ui.getHeight() + 10);
      if (gameOver) {
        fill(255, 0, 0, 200);
        rect(0,0,width,height);
        fill(255);
        textAlign(CENTER, CENTER);
        textSize(48);
        text("GAME OVER", width / 2, height / 2 - 150);

        textSize(24);
        text("Leaderboard", width/2, height/2 - 50);
        ArrayList<ScoreEntry> entries = leaderboard.getEntries();
        for(int i = 0; i < entries.size(); i++){
          ScoreEntry e = entries.get(i);
          text((i+1) + ". " + e.name + " - " + e.score, width/2, height/2 - 10 + i * 30);
        }
        textSize(20);
        text("Press any key to play again", width/2, height/2 + 100);
    }
  }

  int colorPalette(int index) {
    int[] palette = {color(0, 255, 255), color(255, 255, 0), color(128, 0, 128), color(0, 0, 255), color(255, 165, 0), color(0, 255, 0), color(255, 0, 0)};
    return palette[index % palette.length];
  }

  void handleKey(char key, int code, boolean down) {
    if (!down) {
      return;
    }
    if (key == 'q' || key == 'Q') {
      gm.switchScene(new HallScene());
      return;
    } 
    if (gameOver) {
      initGame();
      if (themeMusic != null && !themeMusic.isPlaying()) {
        themeMusic.loop();
      }
      return;
    } 
    
    if (key == 'a' || key == 'A') {
      movePiece(-1);
    } else if (key == 'd' || key == 'D') {
      movePiece(1);
    } else if (key == 's' || key == 'S') {
        step();
        frameTick = 0;
    } else if (key == 'w' || key == 'W') {
      rotatePiece();
    } else if (key == ' ') {
      hardDrop();
    }
  }

  void handleMouse(boolean pressed) {
  }
  
  void handleDrag() {
  }
}
