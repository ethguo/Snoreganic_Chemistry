class Halogen extends Carbon {
  String symbol;

  Halogen(String symbol) {
    super();
    this.symbol = symbol;
  }

  Halogen(String symbol, color lineColor) {
    super(lineColor);
    this.symbol = symbol;
  }

  void draw(PVector fromCoords, float angle) {
    PVector newCoords = PVector.fromAngle(angle);
    PVector lineEnd = newCoords.copy();
    newCoords.setMag(this.bondLength);
    lineEnd.setMag(this.bondLength - textMargin);
    newCoords.add(fromCoords);
    lineEnd.add(fromCoords);

    stroke(lineColor);
    fill(lineColor);
    line(fromCoords.x, fromCoords.y, lineEnd.x, lineEnd.y);
    text(this.symbol, newCoords.x, newCoords.y);

    drawChildren(newCoords, angle);
  }

  void drawChildren(PVector fromCoords, float angle) {
    float newAngle = angle;

    for (int i = 0; i < numChildren; i++) {
      if (angle > 0)
        newAngle = (angle - PI/3) + i * 2*PI/3;
      else
        newAngle = (angle + PI/3) - i * 2*PI/3;

      this.children[i].draw(fromCoords, newAngle);
    }
  }
}