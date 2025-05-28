abstract class CabinetScene extends Scene {
  PVector cabPos = new PVector(0, 0);
  UIOverlay ui = new UIOverlay();
  void drawCabinet() {
    fill(getColor());
    rect(cabPos.x - 40, cabPos.y - 40, 80, 80);
    fill(0);
    textAlign(CENTER, CENTER);
    text(getLabel(), cabPos.x, cabPos.y);
  }
  boolean isNear(PVector p) {
    return PVector.dist(p, cabPos) < 60;
  }
  abstract String getLabel();
  abstract int getColor();
}
