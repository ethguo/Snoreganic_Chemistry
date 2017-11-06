class Carbon {
  Carbon[] children;
  int numChildren;
  int numBonds; // Single, double or triple
  color lineColor;
  float bondLength = 50;

  Carbon() {
    this(defaultLineColor);
  }

  Carbon(color lineColor) {
    this.lineColor = lineColor;
    this.children = new Carbon[3];
    this.numBonds = 1;
  }

  void addChild(Carbon child) {
    children[numChildren] = child;
    numChildren++;
  }

  void draw(PVector fromCoords, float angle) {
    PVector direction = PVector.fromAngle(angle);

    PVector bondLength = direction.copy();
    bondLength.setMag(this.bondLength);

    PVector newCoords = bondLength.copy();
    newCoords.add(fromCoords);

    stroke(lineColor);
    line(fromCoords.x, fromCoords.y, newCoords.x, newCoords.y);

    if (this.numBonds > 1) {
      PVector bond2Start = direction.copy();
      bond2Start.rotate(PI/2);
      bond2Start.setMag(bondOffset);
      PVector bond2End = bond2Start.copy();
      bond2End.add(bondLength);
      bond2Start.add(fromCoords);
      bond2End.add(fromCoords);
      line(bond2Start.x, bond2Start.y, bond2End.x, bond2End.y);
    }

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