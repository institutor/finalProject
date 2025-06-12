class UIOverlay {
  private ArrayList<String> messages = new ArrayList<String>();
  float h = 50;
  void add(String m) {
    messages.clear();
    messages.add(m);
  }
  void draw() {
    h = max(50, 18 * messages.size() + 14);
    fill(0, 140);
    rect(0, 0, width, h);
    fill(255);
    textSize(14);
    textAlign(LEFT, CENTER);
    float y = h / 2 - 18 * (messages.size() - 1) / 2;
    for (String m : messages) {
      text(m, 30, y);
      y += 18;
    }
  }
  float getHeight() {
    return h; 
  }
}
