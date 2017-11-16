class CyclicAtom extends Atom {
  int numCarbons;

  CyclicAtom(int numCarbons, color lineColor) {
    super("C", 4, lineColor);
    this.numCarbons = numCarbons;
  }

  void draw(PVector fromCoords, float angle) {
    // On the "root" of the cyclic branch, draw an extra line to close off the polygon.
    if (!(this.parent instanceof CyclicAtom)) {
      // Set the line weight and color
      strokeWeight(2);
      if (fullColour) {
        stroke(lineColor);
        fill(lineColor);
      }
      else {
        stroke(defaultLineColor);
        fill(defaultLineColor);
      }

      // Find where the line should start
      PVector newCoords = PVector.fromAngle(angle);
      newCoords.setMag(this.bondLength);
      newCoords.add(fromCoords);

      // Find where the line should end
      float bondAngle = angle + PI/2 - PI / this.numCarbons;
      PVector bondEnd = PVector.fromAngle(bondAngle);
      bondEnd.setMag(this.bondLength);
      bondEnd.add(newCoords);

      line(newCoords.x, newCoords.y, bondEnd.x, bondEnd.y);
    }

    // Call the regular Atom's draw method
    super.draw(fromCoords, angle);
  }

  void drawChildren(PVector fromCoords, float angle) {
    if (this.numChildren >= 1) {
      float deltaAngle = 2*PI / this.numCarbons;

      // The first child will always be the next carbon in the chain
      float angle1;
      if (this.parent instanceof CyclicAtom)
        angle1 = angle + deltaAngle; // If the parent of this Atom was also a CyclicAtom, just draw the next side of the polygon
      else
        angle1 = angle - PI/2 + deltaAngle/2; // If the parent of this Atom was a regular Atom, calculate the angle to have the polygon sit "symmetrically" on the branch

      this.children[0].draw(fromCoords, angle1);

      // If the cycle has branches (ie. on cyclic base chains), put the branches on the outside of the cycle
      if (numChildren == 2) {
        float angle2 = angle - (PI + deltaAngle) / 2;
        this.children[1].draw(fromCoords, angle2);
      }
      else if (numChildren == 3) {
        float angle2 = angle - (PI + deltaAngle) / 3;
        float angle3 = angle2 * 2;
        this.children[1].draw(fromCoords, angle2);
        this.children[2].draw(fromCoords, angle3);
      }
    }
  }
}