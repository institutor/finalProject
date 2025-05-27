import peasy.*;
import fisica.*;
import controlP5.*;

PeasyCam cam;
Player3D  player;
ArrayList<Cabinet> cabinets = new ArrayList<Cabinet>();

ControlP5 ui;
boolean showTutorial = true;   
GameState state = GameState.HALL;

MiniGolf golf;               

enum GameState { HALL, MINIGOLF }

void settings() { size(1280, 720, P3D); }

void setup() {
  cam = new PeasyCam(this, 400);
  cam.setRotations(0, 0, 0);
  cam.setMinimumDistance(50);
  cam.setMaximumDistance(800);

  player = new Player3D();
  ui = new ControlP5(this);

  createHall();
  Fisica.init(this); // for minigolf later
}

void createHall() {
  for (int i=0; i<6; i++) {
    float angle = TWO_PI * i/6.0;
    PVector pos = new PVector(cos(angle)*150, 0, sin(angle)*150);
    Cabinet c   = new Cabinet(pos, i==0 ? "Mini-Golf" : "TBA");
    cabinets.add(c);
  }
}

void draw() {
  background(25);
  lights();
  if (state == GameState.HALL) {
    player.update();
    cam.setPosition(player.pos.x, player.pos.y + 60, player.pos.z);
    cam.lookAt(player.pos.x + player.look.x,
               player.pos.y + 60 + player.look.y,
               player.pos.z + player.look.z);
    drawFloor();
    for (Cabinet c : cabinets) c.render();
    if (showTutorial) drawTutorial();
  }
  else if (state == GameState.MINIGOLF) {
    golf.updateAndRender();
  }
}
