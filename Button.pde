class Button {
  PVector position;
  int size;
  int radius;
  color colour;

  Button(int x_, int y_, color colour_) {
    position = new PVector(x_, y_);
    size = height / 20;
    radius = size / 2;
    colour = colour_;
  }

  void display() {
    fill(colour);
    stroke(#1a1a1a);

    rect(position.x, position.y, size, size, radius);
  }
}