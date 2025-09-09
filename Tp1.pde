
enum GameState { RUNNING, WIN, LOSE }
GameState gameState = GameState.RUNNING;
int restartAtMs = 0;               // millis() auquel on relance

int forestWidth = 100;

// entite
ArrayList<Predator> predators = new ArrayList<Predator>();
Proie proie;

int currentTime, previousTime, deltaTime;

final int MIN_PREDS = 10;
final int MAX_PREDS = 15;

void setup() {
  size(900, 600);
  frameRate(60);
  resetGame();
}

void draw() {
  // timing
  currentTime = millis();
  deltaTime   = currentTime - previousTime;
  previousTime = currentTime;

  // fond
  drawBackground();

  if (gameState == GameState.RUNNING) {
    updateRunning();
  } else { 
    drawEntities();
    if (millis() >= restartAtMs) {
      resetGame();
    }
  }
}


// Logique du jeu 
void updateRunning() {
  // 1) Proie (contrôle WASD dans Proie.update)
  proie.update(deltaTime);
  // empecher de sortir de l'écran
  proie.location.x = constrain(proie.location.x, 0, width);
  proie.location.y = constrain(proie.location.y, 0, height);

  // 2) Victoire si la proie atteint la forêt de droite
  if (proie.location.x + proie.size/2f >= width - forestWidth) {
    if (gameState == GameState.RUNNING) {
      System.out.println("Jeu gagnant");
      gameState = GameState.WIN;
      restartAtMs = millis() + 2000; // redemarage
    }
  }

  // 3) IA + update des predateurs
  for (Predator p : predators) {
    p.updateAI(deltaTime, proie);  
    p.update(deltaTime);
  }

  // 4) Défaite si contact avec un predateur
  if (gameState == GameState.RUNNING) {
    for (Predator p : predators) {
      if (p.touches(proie)) {
        println("Jeu termine");
        gameState = GameState.LOSE;
        restartAtMs = millis() + 2000;
        break;
      }
    }
  }

  // 5) rendu
  drawEntities();
}

void resetGame() {
  proie = new Proie(forestWidth/2, height/2);

  // Renere predateurs
  predators.clear();
  int n = (int)random(MIN_PREDS, MAX_PREDS + 1);
  for (int i = 0; i < n; i++) {
    PVector spawn;
    do {
      float x = random(forestWidth + 50, width - forestWidth - 50);
      float y = random(50, height - 50);
      spawn = new PVector(x, y);
    } while (PVector.dist(spawn, proie.location) < 50);
    predators.add(new Predator((int)spawn.x, (int)spawn.y));
  }

  // repart
  gameState = GameState.RUNNING;
  previousTime = currentTime = millis();
}


// Visuel
void drawBackground() {
  background(35);
  noStroke();

  fill(0, 100, 0);
  rect(0, 0, forestWidth, height);
  rect(width - forestWidth, 0, forestWidth, height);
 
  fill(224, 188, 25);
  rect(forestWidth, 0, width - 2*forestWidth, height);
}

void drawEntities() {
  for (Predator p : predators) p.display();
  proie.display();
}
