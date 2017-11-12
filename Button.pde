class Button {
  PVector position;
  int size;
  int radius;
  color colour;

  Button(int x_, int y_, color colour_) {
    this.position = new PVector(x_, y_);
    this.size = height / 20;
    this.radius = this.size / 2;
    this.colour = colour_;
  }

  void draw() {
    fill(this.colour);
    stroke(#1a1a1a);

    rect(this.position.x, this.position.y, this.size, this.size, this.radius);
  }

  boolean overButton() {
    if ((mouseX > this.position.x && mouseX < this.position.x + this.size) && (mouseY > this.position.y && mouseY < this.position.y + this.size)) {
      return true;
    } else {
      return false;
    }
  }
}