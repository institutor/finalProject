class HallScene extends Scene {
  ArrayList<CabinetRep> cabinets;
  Player player;
  UIOverlay tutorialOverlay;
  boolean showTutorial = true;
  float camPan = 0; 
  HallScene(GameManager manager) {
    super(manager);
    cabinets = new ArrayList<CabinetRep>();
    player = new Player(new PVector(0, 0, 0), new KeyBinds()); 
    tutorialOverlay = new UIOverlay();
    println("HallScene: Initialized");
  }

  @Override
  void enter() {
    super.enter();
    println("HallScene: Loading player and cabinets...");
    player.position = new PVector(0, 20, 250); 
    cabinets.clear(); 
    cabinets.add(new CabinetRep("MiniGolf", new PVector(-200, 0, -100), this)); 
    cabinets.add(new CabinetRep("TetrisGame", new PVector(0, 0, -150), this));
    cabinets.add(new CabinetRep("ArcheryGame", new PVector(200, 0, -100), this));
    if (showTutorial) {
      tutorialOverlay.clearMessages();
      tutorialOverlay.showMessage("Welcome to ULTIMATE-ARCADE!");
      tutorialOverlay.showMessage("W/S: Move Fwd/Back | A/D: Strafe Left/Right");
      tutorialOverlay.showMessage("Mouse: Look Around (Basic)");
      tutorialOverlay.showMessage("Walk to a cabinet (highlighted) and press 'E' to play.");
      tutorialOverlay.showMessage("Press 'T' to toggle this tutorial.");
    }
  }

  @Override
  void update() {
    super.update();
    player.updateInHall(camPan); 
    float lookSensitivity = 0.005;
    camPan -= (mouseX - pmouseX) * lookSensitivity; 
    player.wantsToInteract = false; 
    if (player.interactionKeyPressed) {
        player.wantsToInteract = true;
        player.interactionKeyPressed = false; 
    }
    for (CabinetRep cabinet : cabinets) {
      float distToCabinet = dist(player.position.x, player.position.z, cabinet.position.x, cabinet.position.z);
      cabinet.isPlayerClose = (distToCabinet < 80); 
      if (cabinet.isPlayerClose && player.wantsToInteract) {
        cabinet.tryInteract();
        break; 
      }
    }
  }
