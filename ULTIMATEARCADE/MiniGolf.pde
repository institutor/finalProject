class MiniGolf extends CabinetScene {
  float bx, by, vx, vy;
  boolean dragging;
  PVector dragStart;
  int strokes;

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
  }

  void update() {
    bx += vx;
    by += vy;
    vx *= 0.98;
    vy *= 0.98;
    if (bx < 10 || bx > width - 10) vx *= -1;
    if (by < 60 || by > height - 10) vy *= -1;
  }

  void draw() {
    background(20, 90, 120);
    fill(255);
    ellipse(bx, by, 20, 20);
    if (dragging) {
      stroke(0, 255, 0);
      line(dragStart.x, dragStart.y, mouseX, mouseY);
      stroke(0);
    }
    ui.draw();
    fill(255);
    text("Strokes: " + strokes, 10, 40);
  }

  void handleKey(char k, int code, boolean down) {
    if (down && (k == 'q' || k == 'Q')) gm.switchScene(new HallScene());
  }

  void handleMouse(boolean pressed) {
    if (pressed) {
      if (dist(mouseX, mouseY, bx, by) < 12) {
        dragging = true;
        dragStart = new PVector(mouseX, mouseY);
      }
    } else {
      if (dragging) {
        dragging = false;
        PVector imp = PVector.sub(dragStart, new PVector(mouseX, mouseY)).mult(0.15);
        vx = imp.x;
        vy = imp.y;
        strokes++;
      }
    }
  }

  void handleDrag() {
  }

  void reset() {
    bx = 200;
    by = height / 2;
    vx = vy = 0;
    strokes = 0;
  }
}
