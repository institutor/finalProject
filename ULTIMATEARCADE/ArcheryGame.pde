class ArcheryGame extends CabinetScene {
  private Leaderboard leaderboard;
  private PVector bowPos, targetPos;
  private PVector arrowPos, arrowVel;
  private boolean isAiming = false;
  private boolean arrowInFlight = false;
  private boolean gameOver = false;
  private int score = 0;
  private int arrowsLeft = 5;
  private SoundFile shootSound, hitSound, gameOverSound;
  private float[] targetRadii = {20, 40, 60, 80};
  private int[] targetScores = {100, 50, 20, 10};
  private color[] targetColors = {#ff0000, #ffff00, #0000ff, #000000};
  
  String getLabel() {
    return "Archery";
  }
  
  int getColor() {
    return color(139, 69, 19);
  }

  void enter() {
    leaderboard = new Leaderboard("archery_scores.txt");
    initGame();
    ui.messages.clear();
    ui.messages.add("Archery | Drag and release to shoot | Q to quit | P to pause");
    try {
      shootSound = new SoundFile(papplet, "bow_shoot.wav");
      hitSound = new SoundFile(papplet, "arrow_hit.wav");
      gameOverSound = new SoundFile(papplet, "gameover.wav");
    } 
    catch(Exception e) {
      println("archery files not working");
    }
  }
  
  void initGame() {
    score = 0;
    arrowsLeft = 5;
    gameOver = false;
    bowPos = new PVector(150, height / 2);
    targetPos = new PVector(width - 200, height / 2);
    resetArrow();
  }
  
  void resetArrow() {
    arrowInFlight = false;
    arrowPos = bowPos.copy();
    arrowVel = new PVector(0, 0);
    if (arrowsLeft <= 0) {
      gameOver = true;
      leaderboard.addScore(gm.playerName, score);
      if (gameOverSound != null) {
        gameOverSound.play();
      }
    }
  }
  
  void update() {
    if (gameOver) {
      return;
    }
    if (arrowInFlight) {
      arrowVel.y += 0.08;
      arrowPos.add(arrowVel);
      float distToTarget = dist(arrowPos.x, arrowPos.y, targetPos.x, targetPos.y);
      if (distToTarget < targetRadii[3]) {
        if (distToTarget < targetRadii[0]) {
          score += targetScores[0];
        } else if (distToTarget < targetRadii[1]) {
          score += targetScores[1];
        } else if (distToTarget < targetRadii[2]) {
          score += targetScores[2];
        } else {
          score += targetScores[3];
        }
        if (hitSound != null) {
          hitSound.play();
        }
        resetArrow();
      }
      if (arrowPos.y > height || arrowPos.x > width || arrowPos.x < 0) {
        resetArrow();
      }
    }
  }
  
  void draw() {
    background(135, 206, 250);
    fill(0, 155, 0);
    rect(0, height - 100, width, 100);
    for (int i = targetRadii.length - 1; i >= 0; i--) {
      fill(targetColors[i]);
      ellipse(targetPos.x, targetPos.y, targetRadii[i] * 2, targetRadii[i] * 2);
    }
    noFill();
    stroke(101, 67, 33);
    strokeWeight(5);
    arc(bowPos.x, bowPos.y, 80, 120, -HALF_PI, HALF_PI);
    if (!arrowInFlight && arrowsLeft > 0) {
      line(bowPos.x, bowPos.y, bowPos.x + 50, bowPos.y);
    } else if (arrowInFlight) {
      float angle = arrowVel.heading();
      pushMatrix();
      translate(arrowPos.x, arrowPos.y);
      rotate(angle);
      line(0, 0, 50, 0);
      popMatrix();
    }
    if (isAiming) {
      stroke(255, 0, 0, 150);
      line(bowPos.x, bowPos.y, mouseX, mouseY);
    }
    noStroke();
    fill(255);
    textSize(24);
    textAlign(LEFT, TOP);
    text("Score: " + score, 20, ui.getHeight() + 20);
    text("Arrows: " + arrowsLeft, 20, ui.getHeight() + 50);
    if (gameOver) {
      fill(0, 150);
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
      text("Press R to play again", width/2, height/2 + 100);
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
  
  void handleMouse(boolean p) {
    if (gameOver || arrowInFlight || arrowsLeft <= 0) {
      return;
    }
    if (p) {
      isAiming = true;
    } else {
      if (isAiming) {
        arrowsLeft--;
        arrowInFlight = true;
        isAiming = false;
        PVector launch = PVector.sub(bowPos, new PVector(mouseX, mouseY));
        arrowVel = launch.mult(0.2);
        if(shootSound != null) {
          shootSound.play();
        }
      }
    }
  }

  void handleDrag() {
  }
}
