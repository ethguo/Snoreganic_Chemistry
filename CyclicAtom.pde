class CyclicAtom extends Atom {
  int numCarbons;

  CyclicAtom(int numCarbons, color lineColor) {
    super("C", 4, lineColor)
    this.numCarbons = numCarbons;
  }

  void drawChildren(PVector fromCoords, float angle) {
    baseAngle = angle + 2*PI / this.numCarbons;

    if (!this.parent instanceof CyclicAtom)
      baseAngle = angle + PI/2 - PI / this.numCarbons;

    this.children[0].draw(fromCoords, baseAngle);

    if (numChildren == 2) {
      angle2 = angle + (PI + 2*PI / this.numCarbons) / 2;
      this.children[1].draw(fromCoords, angle2);
    }
    else if (numChildren == 3) { // 4-way intersection
      angle2 = angle + (PI + 2*PI / this.numCarbons) / 3;
      angle3 = angle2 * 2;
      this.children[1].draw(fromCoords, angle2);
      this.children[2].draw(fromCoords, angle3);
    }
  }
}