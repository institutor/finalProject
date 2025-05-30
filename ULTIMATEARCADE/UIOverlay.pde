class UIOverlay {
  ArrayList<String> messages = new ArrayList<String>();
  void add(String m) { 
    messages.clear();  
    messages.add(m); 
  }
  void draw() {
    fill(0, 200);
    rect(0, 0, width, 100);
    fill(255);
    textSize(25);
    textAlign(LEFT, CENTER);
    float y = 25;  
    for (String m : messages) {
      text(m, 30, y);  
      y += 18;
    }
  }
}
