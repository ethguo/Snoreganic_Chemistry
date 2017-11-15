class CyclicAtom extends Atom {
  int numCarbons;

  CyclicAtom(int numCarbons, color lineColor) {
    super("C", 4, lineColor);
    this.numCarbons = numCarbons;
  }
  void draw(PVector fromCoords, float angle) {

    // On the "root" of the cyclic branch, draw an extra line to close off the polygon.
    if (!(this.parent instanceof CyclicAtom)) {
      strokeWeight(2);
      if (fullColour) {
        stroke(lineColor);
        fill(lineColor);
      }
      else {
        stroke(defaultLineColor);
        fill(defaultLineColor);
      }

      PVector newCoords = PVector.fromAngle(angle);
      newCoords.setMag(this.bondLength);
      newCoords.add(fromCoords);

      float bondAngle = angle + PI/2 - PI / this.numCarbons;
      PVector bondEnd = PVector.fromAngle(bondAngle);
      bondEnd.setMag(this.bondLength);
      bondEnd.add(newCoords);

      line(newCoords.x, newCoords.y, bondEnd.x, bondEnd.y);
    }

    super.draw(fromCoords, angle);
  }

  void drawChildren(PVector fromCoords, float angle) {
    float deltaAngle = 2*PI / this.numCarbons;

    float baseAngle;
    if (this.parent instanceof CyclicAtom)
      baseAngle = angle + deltaAngle;
    else
      baseAngle = angle - PI/2 + deltaAngle/2;

    if (this.numChildren > 0)
      this.children[0].draw(fromCoords, baseAngle);

    if (numChildren == 2) {
      float angle2 = angle + (PI + 2*PI / this.numCarbons) / 2;
      this.children[1].draw(fromCoords, angle2);
    }
    else if (numChildren == 3) { // 4-way intersection
      float angle2 = angle + (PI + 2*PI / this.numCarbons) / 3;
      float angle3 = angle2 * 2;
      this.children[1].draw(fromCoords, angle2);
      this.children[2].draw(fromCoords, angle3);
    }
  }
}