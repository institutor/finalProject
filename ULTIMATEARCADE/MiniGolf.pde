class MiniGolf extends CabinetScene {
  float bx, by, vx, vy;
  boolean dragging;
  PVector dragStart;
  int strokes;
  int currentHole = 1;
  int totalHoles = 5;
  boolean ballInHole = false;
  int holeCompleteTimer = 0;
  ArrayList<PVector> obstacles = new ArrayList<PVector>();
  PVector holePos;
  ArrayList<Rectangle> sandTiles = new ArrayList<Rectangle>();
  ArrayList<Rectangle> iceTiles = new ArrayList<Rectangle>();

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
    ui.messages.clear();
    ui.add("Mini-Golf  |  Drag to shoot  |  Q to exit");
    setupHole();
  }

  void setupHole() {
    obstacles.clear();
    sandTiles.clear();
    iceTiles.clear();
    ballInHole = false;
    holeCompleteTimer = 0;
    if (currentHole == 1) {
      holePos = new PVector(width - 100, height - 100);
      obstacles.add(new PVector(400, 200));
      obstacles.add(new PVector(600, 350));
    } else if (currentHole == 2) {
      holePos = new PVector(100, 100);
      obstacles.add(new PVector(300, 150));
      obstacles.add(new PVector(500, 250));
      obstacles.add(new PVector(700, 350));
      sandTiles.add(new Rectangle(0 , height / 2 , 2000, 100));
    } else if (currentHole == 3) {
      holePos = new PVector(width / 2, 100);
      obstacles.add(new PVector(200, 200));
      obstacles.add(new PVector(width / 2, 300));
      obstacles.add(new PVector(width - 200, 400));
      iceTiles.add(new Rectangle(width / 4 , height / 2 , 500, 500));
      iceTiles.add(new Rectangle(width * 3 / 4 , height / 2 , 500, 100));
    } else if (currentHole == 4) {
      holePos = new PVector(50, height / 2);
      obstacles.add(new PVector(200, 150));
      obstacles.add(new PVector(200, 400));
      obstacles.add(new PVector(width - 200, 150));
      obstacles.add(new PVector(width - 200, 400));
      sandTiles.add(new Rectangle(width / 2 , 200 , 1000, 100));
      sandTiles.add(new Rectangle(width / 2 , 300 , 1000, 200));
    } else if (currentHole == 5) {
      holePos = new PVector(width / 2, height - 200 );
      obstacles.add(new PVector(100, 200));
      obstacles.add(new PVector(width - 100, 200));
      obstacles.add(new PVector(width / 2, 250));
      iceTiles.add(new Rectangle(250, height / 2 , 1040, 100));
      iceTiles.add(new Rectangle(300 , height / 2 , 1050, 100));
      sandTiles.add(new Rectangle(0 , height / 2 + 100 , 10340, 1500));
    }
  }

  void update() {
    if (!ballInHole) {
      bx += vx;
      by += vy;
      float friction = 0.98;
      for (Rectangle sand : sandTiles) {
        if (bx > sand.x && bx < sand.x + sand.width && by > sand.y && by < sand.y + sand.height) {
          friction = 0.90;
          break;
        }
      }
      for (Rectangle ice : iceTiles) {
        if (bx > ice.x && bx < ice.x + ice.width && by > ice.y && by < ice.y + ice.height) {
          friction = 0.992;
          break;
        }
      }
      vx *= friction;
      vy *= friction;
      if (abs(vx) < 0.1) vx = 0;
      if (abs(vy) < 0.1) vy = 0;
      if (bx < 10) {
        bx = 10;
        vx *= -0.7;
      }
      if (bx > width - 10) {
        bx = width - 10;
        vx *= -0.7;
      }
      if (by < 60) {
        by = 60;
        vy *= -0.7;
      }
      if (by > height - 10) {
        by = height - 10;
        vy *= -0.7;
      }
      for (PVector obs : obstacles) {
        float d = dist(bx, by, obs.x, obs.y);
        if (d < 35) {
          PVector bounce = new PVector(bx - obs.x, by - obs.y);
          bounce.normalize();
          bounce.mult(2);
          vx = bounce.x;
          vy = bounce.y;
          bx = obs.x + bounce.x * 35;
          by = obs.y + bounce.y * 35;
        }
      }
      if (dist(bx, by, holePos.x, holePos.y) < 15 && abs(vx) < 3.5 && abs(vy) < 3.5) {
        ballInHole = true;
        vx = vy = 0;
        holeCompleteTimer = 60;
      }
    } else {
      holeCompleteTimer--;
      if (holeCompleteTimer <= 0) {
        if (currentHole < totalHoles) {
          currentHole++;
          reset();
          setupHole();
        } else {
          ui.add("Course Complete! Final Score: " + strokes + " strokes" + "\n Press Q to exit");
        }
      }
    }
  }

  void draw() {
    background(20, 90, 20);
    for (Rectangle sand : sandTiles) {
      fill(210, 180, 140);
      rect(sand.x, sand.y, sand.width, sand.height);
    }
    for (Rectangle ice : iceTiles) {
      fill(180, 230, 255);
      rect(ice.x, ice.y, ice.width, ice.height);
    }
    fill(10, 60, 10);
    ellipse(holePos.x, holePos.y, 30, 30);
    fill(0);
    ellipse(holePos.x, holePos.y, 20, 20);
    fill(139, 70, 19);
    for (PVector obs : obstacles) {
      ellipse(obs.x, obs.y, 60, 60);
    }
    if (ballInHole) {
      fill(255, 255, 0);
    } else {
      fill(255);
    }
    ellipse(bx, by, 20, 20);
    if (dragging && !ballInHole) {
      stroke(0, 255, 0);
      strokeWeight(3);
      line(dragStart.x, dragStart.y, mouseX, mouseY);
      noStroke();
    }
    ui.draw();
    fill(255);
    textAlign(LEFT, TOP);
    text("Hole: " + currentHole + "/" + totalHoles, 10, 60);
    text("Strokes: " + strokes, 10, 80);
    if (ballInHole && holeCompleteTimer > 30) {
      fill(255, 255, 0);
      textAlign(CENTER, CENTER);
      textSize(24);
      text("HOLE IN!", width / 2, height / 2);
      textSize(12);
    }
  }

  void handleKey(char k, int code, boolean down) {
    if (down && (k == 'q' || k == 'Q')) gm.switchScene(new HallScene());
    if (down && (k == 'r' || k == 'R')) {
      if (currentHole > totalHoles) {
        currentHole = 1;
        strokes = 0;
        reset();
        setupHole();
      }
    }
  }

  void handleMouse(boolean pressed) {
    if (ballInHole) return;
    if (pressed) {
      if (dist(mouseX, mouseY, bx, by) < 15 && abs(vx) < 0.5 && abs(vy) < 0.5) {
        dragging = true;
        dragStart = new PVector(mouseX, mouseY);
      }
    } else {
      if (dragging) {
        dragging = false;
        PVector imp = PVector.sub(dragStart, new PVector(mouseX, mouseY)).mult(0.1);
        vx = imp.x;
        vy = imp.y;
        strokes++;
      }
    }
  }

  void handleDrag() {
  }

  void reset() {
    bx = 100;
    by = height - 100;
    vx = vy = 0;
    if (currentHole == 1) strokes = 0;
  }
}

class Rectangle {
  float x, y, width, height;
  Rectangle(float x, float y, float width, float height) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
  }
}
