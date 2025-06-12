class MiniGolf extends CabinetScene {
  private float bx, by, vx, vy;
  private boolean dragging;
  private PVector dragStart;
  private int strokes;
  private int holeStrokes;
  private int currentHole = 1;
  private int totalHoles = 5;
  private boolean ballInHole = false;
  private int holeCompleteTimer = 0;
  private ArrayList<PVector> obstacles = new ArrayList<PVector>();
  private PVector holePos;
  private ArrayList<Rectangle> sandTiles = new ArrayList<Rectangle>();
  private ArrayList<Rectangle> iceTiles = new ArrayList<Rectangle>();
  private SoundFile hitSound, holeSound, shootSound;
  private Leaderboard leaderboard;
  private boolean courseComplete = false;

  MiniGolf() {
    reset(); 
  }

  String getLabel() { 
    return "Mini-Golf";
  }

  int getColor() { 
    return color(0, 200, 0); 
  }

  void enter() {
    leaderboard = new Leaderboard("minigolf_scores.txt");
    courseComplete = false;
    currentHole = 1;
    reset();
    ui.messages.clear();
    ui.messages.add("Mini-Golf  |  Drag to shoot  |  Q exit  |  P pause");
    ui.messages.add("Sand slows  |  Ice is slidey  |  Rocks bounce");
    ui.messages.add("Cup = black   Ball = white");
    setupHole();
    try {
      hitSound = new SoundFile(papplet, "hit.wav");
      holeSound = new SoundFile(papplet, "hole.wav");
      shootSound = new SoundFile(papplet, "shoot.wav");
    } catch (Exception e) {
      println("Could not load MiniGolf sound files.");
    }
  }

  void setupHole() {
    obstacles.clear();
    sandTiles.clear();
    iceTiles.clear();
    ballInHole = false;
    holeCompleteTimer = 0;
    if (currentHole == 1) {
      holePos = new PVector(width - 150, height - 150); 
      obstacles.add(new PVector(width * .55f, height * .70f));
      obstacles.add(new PVector(width * .70f, height * .55f));
      obstacles.add(new PVector(width * .80f, height * .35f));
      obstacles.add(new PVector(width * .45f, height * .45f));
    } else if (currentHole == 2) {
      holePos = new PVector(150, 150);
      obstacles.add(new PVector(width * .35f, height * .20f));
      obstacles.add(new PVector(width * .60f, height * .35f));
      obstacles.add(new PVector(width * .80f, height * .55f));
      sandTiles.add(new Rectangle(0, height * .45f, width, 300));
      iceTiles.add(new Rectangle(0, 60, width * 2.0f, 250));
    } else if (currentHole == 3) {
      holePos = new PVector(width / 2, 150);
      obstacles.add(new PVector(width * .25f, height * .30f));
      obstacles.add(new PVector(width * .50f, height * .60f));
      obstacles.add(new PVector(width * .75f, height * .30f));
      iceTiles.add(new Rectangle(width * 0f, height * .50f, width * 2.8f, 180));
      sandTiles.add(new Rectangle(width * 0f, height * .78f, width * 2.0f, 240));
    } else if (currentHole == 4) {
      holePos = new PVector(100, height / 2);
      obstacles.add(new PVector(width * .30f, height * .25f));
      obstacles.add(new PVector(width * .30f, height * .70f));
      obstacles.add(new PVector(width * .60f, height * .25f));
      obstacles.add(new PVector(width * .60f, height * .70f));
      sandTiles.add(new Rectangle(width * .38f, height * .25f, width * .24f, 450));
      iceTiles.add(new Rectangle(0, height * .10f, width * .15f, height * 2.0f));
    } else if (currentHole == 5) {
      holePos = new PVector(width / 2, height - 250);
      obstacles.add(new PVector(width * .10f, height * .30f));
      obstacles.add(new PVector(width * .90f, height * .30f));
      obstacles.add(new PVector(width * .20f, height * .50f));
      obstacles.add(new PVector(width * .80f, height * .50f));
      obstacles.add(new PVector(width * .50f, height * .40f));
      iceTiles.add(new Rectangle(0, height * .40f, width, 160));
      sandTiles.add(new Rectangle(0, height * .60f, width, 320));
    }
  }

  void update() {
    if (courseComplete) {
      return;
    }

    if (!ballInHole) {
      bx += vx;
      by += vy;
      float friction = 0.98f;
      for (Rectangle s : sandTiles)
        if (bx > s.x && bx < s.x + s.width && by > s.y && by < s.y + s.height) { friction = 0.90f; break; }
      for (Rectangle i : iceTiles)
        if (bx > i.x && bx < i.x + i.width && by > i.y && by < i.y + i.height) { friction = 0.992f; break; }
      vx *= friction;
      vy *= friction;
      if (abs(vx) < .1f) vx = 0;
      if (abs(vy) < .1f) vy = 0;
      if (bx < 10) { bx = 10; vx *= -0.7f; if (hitSound != null) hitSound.play(); }
      if (bx > width - 10) { bx = width - 10; vx *= -0.7f; if (hitSound != null) hitSound.play(); }
      if (by < 60) { by = 60; vy *= -0.7f; if (hitSound != null) hitSound.play(); }
      if (by > height - 10) { by = height - 10; vy *= -0.7f; if (hitSound != null) hitSound.play(); }
      for (PVector o : obstacles) {
        float d = dist(bx, by, o.x, o.y);
        if (d < 40) {
          vx *= -0.7;
          vy *= -0.7;
          if (hitSound != null) hitSound.play();
        }
      }
      if (dist(bx, by, holePos.x, holePos.y) < 15 && abs(vx) < 3.5f && abs(vy) < 3.5f) {
        ballInHole = true;
        vx = vy = 0;
        holeCompleteTimer = 60;
        if (holeSound != null) holeSound.play();
      }
    } else {
      holeCompleteTimer--;
      if (holeCompleteTimer <= 0) {
        if (currentHole < totalHoles) {
          currentHole++;
          reset();
          setupHole();
        } else {
          courseComplete = true;
          leaderboard.addScore(gm.playerName, -strokes); 
        }
      }
    }
  }

  void draw() {
    background(20, 90, 20);
    
    if (courseComplete) {
       textAlign(CENTER, CENTER);
       fill(255);
       textSize(40);
       text("Course Complete! Final Score: " + strokes, width/2, height/2 - 200);
       
       textSize(24);
       text("Leaderboard (Lowest Score Wins)", width/2, height/2 - 100);
       ArrayList<ScoreEntry> entries = leaderboard.getEntries();
       for(int i = 0; i < entries.size(); i++){
         ScoreEntry e = entries.get(i);
         text((i+1) + ". " + e.name + " - " + (-e.score), width/2, height/2 - 60 + i * 30);
       }
       
       textSize(20);
       text("Press R to Play Again or Q to Quit", width/2, height/2 + 100);
       return;
    }
    
    for (Rectangle s : sandTiles) {
      fill(210, 180, 140);
      rect(s.x, s.y, s.width, s.height);
    }
    for (Rectangle i : iceTiles) {
      fill(180, 230, 255);
      rect(i.x, i.y, i.width, i.height);
    }
    fill(10, 60, 10);
    ellipse(holePos.x, holePos.y, 30, 30);
    fill(0);
    ellipse(holePos.x, holePos.y, 20, 20);
    fill(139, 70, 19);
    for (PVector o : obstacles) ellipse(o.x, o.y, 60, 60);
    fill(ballInHole ? color(255, 255, 0) : 255);
    ellipse(bx, by, 20, 20);
    if (dragging && !ballInHole) {
      stroke(0, 255, 0);
      strokeWeight(3);
      line(dragStart.x, dragStart.y, mouseX, mouseY);
      noStroke();
    }
    ui.draw();
    float top = ui.getHeight();
    fill(255);
    textAlign(LEFT, TOP);
    text("Hole: " + currentHole + "/" + totalHoles, 10, top + 10);
    text("Strokes (hole): " + holeStrokes, 10, top + 30);
    text("Strokes (total): " + strokes, 10, top + 50);
    if (ballInHole && holeCompleteTimer > 30) {
      fill(255, 255, 0);
      textAlign(CENTER, CENTER);
      textSize(24);
      text("HOLE IN!", width / 2, height / 2);
      textSize(12);
    }
  }

  void handleKey(char k, int c, boolean d) {
    if (d && (k == 'q' || k == 'Q')) {
      gm.switchScene(new HallScene());
    }
    if (d && (k == 'r' || k == 'R')) {
      enter();
    }
  }

  void handleMouse(boolean p) {
    if (ballInHole || courseComplete) {
      return;
    }
    if (p) {
      if (dist(mouseX, mouseY, bx, by) < 15 && abs(vx) < .5f && abs(vy) < .5f) {
        dragging = true;
        dragStart = new PVector(mouseX, mouseY);
      }
    } else {
      if (dragging) {
        dragging = false;
        PVector imp = PVector.sub(dragStart, new PVector(mouseX, mouseY)).mult(.1f);
        vx = imp.x;
        vy = imp.y;
        strokes++;
        holeStrokes++;
        if (shootSound != null) {
          shootSound.play();
        }
      }
    }
  }

  void handleDrag() {
  }

  void reset() {
    bx = 200;
    by = height - 150;
    vx = vy = 0;
    if (currentHole == 1) {
      strokes = 0;
    }
    holeStrokes = 0;
  }
}
