abstract class GraphicObject {
  PVector location;
  PVector velocity;
  PVector acceleration;

  color fillColor = color(255);
  color strokeColor = color(255);
  float strokeWeight = 1;

  abstract void update(int deltaTime);
  abstract void display();

  void keepInBounds(float x0, float y0, float x1, float y1) {
    location.x = constrain(location.x, x0, x1);
    location.y = constrain(location.y, y0, y1);
  }
}
