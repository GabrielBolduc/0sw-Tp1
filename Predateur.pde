enum PredatorState { WAITING, CHASING }

class Predator extends GraphicObject {
  
  float angle = 0.0;
  float size  = 10;       
  
  PredatorState state = PredatorState.WAITING;

  // 0.25–0.5 tour/s ; 80% horaire / 20% anti-horaire
  float turnsPerSec = random(0.25, 0.5);
  int rotDir = (random(1) < 0.8) ? +1 : -1;

  // Cône de vision: 120, distance 50px (écart-type 5)
  float fovDeg       = 120;
  float fovDistMean  = 50;
  float fovDistSd    = 5;

  // Poursuite: 3 px/frame (écart-type 1)
  float chaseSpeedMean = 3.0;
  float chaseSpeedSd   = 1.0;

  Predator (int x, int y) {
    instantiate();
    angle = random (0, TWO_PI);
    location.x = x;
    location.y = y;
  }
  
  void instantiate() {
    location     = new PVector();
    velocity     = new PVector();
    acceleration = new PVector();
  }

  void updateAI(int deltaTime, Proie prey) {
    // portée de vision tirer  N(50,5), bornée (stabilité)
    float sight = constrain( fovDistMean + fovDistSd * (float)randomGaussian(), 10, 120 );

    // vecteur vers la proie
    PVector toPrey = PVector.sub(prey.location, location);
    float dist = toPrey.mag();


    boolean inDist = dist <= sight;
    float bearing  = atan2(toPrey.y, toPrey.x);
    float dA       = angleDiff(angle, bearing);
    boolean inCone = abs(degrees(dA)) <= fovDeg * 0.5f;

    if (inDist && inCone) {
      state = PredatorState.CHASING;
    } else if (state == PredatorState.CHASING) {
      state = PredatorState.WAITING;
    }

    if (state == PredatorState.WAITING) {
      float dTheta = rotDir * TWO_PI * turnsPerSec * (deltaTime / 1000.0f);
      angle += dTheta;
      velocity.set(0, 0);
    } else { // CHASING
      float speed = max(0.5f, chaseSpeedMean + chaseSpeedSd * (float)randomGaussian());
      if (dist > 1e-3) {
        PVector dir = toPrey.copy().normalize().mult(speed);
        velocity.set(dir);
        angle = atan2(velocity.y, velocity.x); // oriente le triangle dans la direction de course
      } else {
        velocity.set(0, 0);
      }
    }
  }
  
  void update(int deltaTime) {
    velocity.add(acceleration);
    location.add(velocity);
    acceleration.mult(0);
  }
  
  void display(){
    pushMatrix();
      translate(location.x, location.y);
      rotate(angle);
      fill (200, 0, 0);
      triangle (0, -size,  size, size,  -size, size);
    popMatrix();
  }

  // Collision
  boolean touches(Proie p) {
    float predatorRadius = size;        // rayon du triangle
    float preyRadius     = p.size * 0.5; // p.size est le DIAMÈTRE
    return PVector.dist(location, p.location) <= (predatorRadius + preyRadius);
  }

  // utilitaire : différence angulaire signée [-PI, PI]
  float angleDiff(float a, float b) {
    float d = (b - a + PI) % (TWO_PI);
    if (d < 0) d += TWO_PI;
    return d - PI;
  }
}
