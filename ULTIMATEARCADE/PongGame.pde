class PongGame extends CabinetScene {
  private float playerY, enemyY;
  private float ballX, ballY, ballVX, ballVY;
  private int playerScore, enemyScore;
  private final float PADDLE_HEIGHT = 120, PADDLE_WIDTH = 20;
  private final int WIN_SCORE = 5;
  private boolean gameOver = false;
  private SoundFile hitSound;
  private SoundFile gameOverSound;
  private Leaderboard leaderboard;
  private boolean enemyIsConfused = false;
  private int enemyConfusedDirection = 1;

  String getLabel() {
    return "Pong";
  }

  int getColor() {
    return color(150, 150, 150);
  }

  void enter() {
    leaderboard = new Leaderboard("pong_scores.txt");
    playerY = enemyY = height / 2;
    playerScore = enemyScore = 0;
    gameOver = false;
    resetBall();
    ui.messages.clear();
    ui.messages.add("Pong | Mouse controls paddle | First to 5 wins | Q exit | P pause");
    try {
      hitSound = new SoundFile(papplet, "hit.wav");
      gameOverSound = new SoundFile(papplet, "gameover.wav");
    } catch(Exception e) {
      println("ping pong sound files not found.");
    }
  }

  void resetBall() {
    ballX = width / 2;
    ballY = height / 2;
    ballVX = 8;
    if (random(1) > 0.5) {
      ballVX *= -1;
    }
    ballVY = random(-4, 4);
  }
  
  void update() {
    if (gameOver) {
      return;
    }
    playerY = mouseY;
    if (ballVX > 0) {
      if (enemyIsConfused) {
        enemyY += 5 * enemyConfusedDirection;
      } else {
        if (ballY < enemyY) {
          enemyY -= 5;
        }
        if (ballY > enemyY) {
          enemyY += 5;
        }
      }
    }
    playerY = constrain(playerY, PADDLE_HEIGHT / 2, height - PADDLE_HEIGHT / 2);
    enemyY = constrain(enemyY, PADDLE_HEIGHT / 2, height - PADDLE_HEIGHT / 2);
    ballX += ballVX;
    ballY += ballVY;
    if (ballY < 10 || ballY > height - 10) {
      ballVY *= -1;
      if (hitSound != null && !hitSound.isPlaying()) {
        hitSound.play();
      }
    }
    if (ballX < 30 + PADDLE_WIDTH / 2 && ballY > playerY - PADDLE_HEIGHT / 2 && ballY < playerY + PADDLE_HEIGHT / 2) {
      ballVX *= -1;
      ballX = 30 + PADDLE_WIDTH / 2;
      if (hitSound != null && !hitSound.isPlaying()) {
        hitSound.play();
      }
      if (random(1) < 0.4) {
        enemyIsConfused = true;
        enemyConfusedDirection = (random(1) < 0.5) ? 1 : -1;
      } else {
        enemyIsConfused = false;
      }
    }
    if (ballX > width - 30 - PADDLE_WIDTH / 2 && ballY > enemyY - PADDLE_HEIGHT / 2 && ballY < enemyY + PADDLE_HEIGHT / 2) {
      ballVX *= -1;
      ballX = width - 30 - PADDLE_WIDTH / 2;
      if (hitSound != null && !hitSound.isPlaying()) {
        hitSound.play();
      }
    }
    if (ballX < 0) {
      enemyScore++;
      resetBall();
    }
    if (ballX > width) {
      playerScore++;
      resetBall();
    }
    if (playerScore >= WIN_SCORE || enemyScore >= WIN_SCORE) {
      gameOver = true;
      if (gameOverSound != null) {
        gameOverSound.play();
      }
      if (playerScore >= WIN_SCORE) {
        leaderboard.addScore(gm.playerName, playerScore - enemyScore);
      }
    }
  }
  
  void draw() {
    background(0);
    textAlign(CENTER, CENTER);
    textSize(64);
    fill(255);
    text(playerScore, width * 0.25, 80);
    text(enemyScore, width * 0.75, 80);
    rectMode(CENTER);
    rect(30, playerY, PADDLE_WIDTH, PADDLE_HEIGHT);
    rect(width - 30, enemyY, PADDLE_WIDTH, PADDLE_HEIGHT);
    ellipse(ballX, ballY, 25, 25);
    rectMode(CORNER);
    if (gameOver) {
      String winner = "";
      if (playerScore >= WIN_SCORE) {
        winner = "YOU WIN";
      } else {
        winner = "ENEMY WINS";
      }
      fill(255);
      textSize(80);
      textAlign(CENTER, CENTER);
      text(winner, width/2, height/2 - 200);
      textSize(24);
      text("Leaderboard", width/2, height/2 - 100);
      ArrayList<ScoreEntry> entries = leaderboard.getEntries();
      for(int i = 0; i < entries.size(); i++){
        ScoreEntry e = entries.get(i);
        text((i+1) + ". " + e.name + " - " + e.score, width/2, height/2 - 60 + i * 30);
      }
      textSize(20);
      text("Press R to Restart or Q to Quit", width/2, height/2 + 100);
    }
    ui.draw();
  }
  
  void handleKey(char k, int code, boolean down) {
    if (!down) {
      return;
    }
    if (k == 'q' || k == 'Q') {
      gm.switchScene(new HallScene());
    }
    if (k == 'r' || k == 'R') {
      enter();
    }
  }
}
