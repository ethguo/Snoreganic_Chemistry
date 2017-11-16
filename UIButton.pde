class UIButton {
  // fields
  PVector position;
  int size;
  int radius;
  color colour;

  // button constructor
  UIButton(int x_, int y_, color colour_) {
    this.position = new PVector(x_, y_);
    this.size = height / 20;
    this.radius = this.size / 2;
    this.colour = colour_;
  }
  
  // draw itself on screen
  void draw() {
    fill(this.colour);
    stroke(#1A1A1A);

    rect(this.position.x, this.position.y, this.size, this.size, this.radius); // draw button as a rounded square
  }

  boolean overButton() {
    return (mouseX > this.position.x && mouseX < this.position.x + this.size
          && mouseY > this.position.y && mouseY < this.position.y + this.size); // check if mouse cursor is within the button's boundaries for mouse click detection
  }
}