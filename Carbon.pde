class Carbon {
  Carbon[] children;
  int numChildren;
  color lineColor;
  float bondLength = 50;

  Carbon(color lineColor) {
    this.children = new Carbon[3];

    this.lineColor = lineColor;
  }

  Carbon() {
    this(defaultLineColor);
  }

  void addChild(Carbon child) {
    children[numChildren] = child;
    numChildren++;
  }

  void draw(PVector fromCoords, float angle) {
    PVector newCoords = PVector.fromAngle(angle);
    newCoords.setMag(this.bondLength);
    newCoords.add(fromCoords);

    stroke(lineColor);
    line(fromCoords.x, fromCoords.y, newCoords.x, newCoords.y);

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