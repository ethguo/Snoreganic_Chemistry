class CyclicAtom extends Atom {
  int numCarbons;

  CyclicAtom(int numCarbons, color lineColor) {
    super("C", 4, lineColor);
    this.numCarbons = numCarbons;
  }
  void draw(PVector fromCoords, float angle) {

    if (!(this.parent instanceof CyclicAtom)) {
      stroke(lineColor);
      fill(lineColor);
      strokeWeight(2);

      PVector newCoords = PVector.fromAngle(angle);
      newCoords.setMag(this.bondLength);
      newCoords.add(fromCoords);

      float bondAngle = angle + PI/2 - PI / this.numCarbons;
      PVector bond1Start = PVector.fromAngle(bondAngle);
      PVector bond1End = bond1Start.copy();

      if (this.parent.element.equals("C"))
        bond1Start.setMag(0);
      else
        bond1Start.setMag(textMargin);

      if (this.element.equals("C"))
        bond1End.setMag(this.bondLength);
      else
        bond1End.setMag(this.bondLength - textMargin);

      bond1Start.add(newCoords);
      bond1End.add(newCoords);
      line(bond1Start.x, bond1Start.y, bond1End.x, bond1End.y);
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