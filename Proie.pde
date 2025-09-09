class Proie extends GraphicObject {
  
  // 
  float angle = 0.0;
  float size  = 40;   // diamètre = 40 → rayon = 20 
  
  // vitesse de deplacement (4.5 px/frame)
  float speed = 4.5;
  
  Proie (int x, int y) {
    instantiate();
    location.x = x;
    location.y = y;
  }
  
  void instantiate() {
    location     = new PVector();
    velocity     = new PVector();
    acceleration = new PVector();
  }
  
  void update(int deltaTime) {
    PVector dir = new PVector(0, 0);
    if (keyPressed) {
      if (key=='w' || key=='W') dir.y -= 1;
      if (key=='s' || key=='S') dir.y += 1;
      if (key=='a' || key=='A') dir.x -= 1;
      if (key=='d' || key=='D') dir.x += 1;
    }
    if (dir.magSq() > 0) {
      dir.normalize().mult(speed);
      velocity.set(dir);
      angle = atan2(velocity.y, velocity.x);
    } else {
      velocity.mult(0);
    }

    velocity.add(acceleration);
    location.add(velocity);
    acceleration.mult(0);
  }
  
  void display(){
    pushMatrix();
      translate(location.x, location.y);
      fill (0, 0, 200);
      ellipse (0, 0, size, size); // diametre = 40 → rayon = 20
    popMatrix();
  }
}
