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
    if (this.numBonds == 3) {
      if (angle > 0)
        angle -= PI/3;
      else
        angle += PI/3;
    }
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

      if (this.numBonds > 2) {
        PVector bond3Start = direction.copy();
        bond3Start.rotate(-PI/2);
        bond3Start.setMag(bondOffset);
        PVector bond3End = bond3Start.copy();
        bond3End.add(bondLength);
        bond3Start.add(fromCoords);
        bond3End.add(fromCoords);
        line(bond3Start.x, bond3Start.y, bond3End.x, bond3End.y);
      }
    }

    drawChildren(newCoords, angle);
  }

  void drawChildren(PVector fromCoords, float angle) {
    if (numChildren == 3) {
      // The first child should be the next carbon; should go straight out
      this.children[0].draw(fromCoords, angle);
      this.children[1].draw(fromCoords, angle + PI/2);
      this.children[2].draw(fromCoords, angle - PI/2);
    }
     else {
      float sign;
      if (angle > 0)
        sign = 1;
      else
        sign = -1;

      float baseAngle;
      if (numBonds == 3)
        baseAngle = angle;
      else
        baseAngle = angle - sign * PI/3;

      for (int i = 0; i < numChildren; i++) {
        float newAngle = baseAngle + sign * i * 2*PI/3;

        this.children[i].draw(fromCoords, newAngle);
      }
    }
  }
}