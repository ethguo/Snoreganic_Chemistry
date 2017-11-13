class Atom {
  String element;
  int bondingNumber;

  //atoms directly attached to and following the object in question are considered children
  Atom[] children;
  int numChildren;
  int numBonds; // Single, double or triple

  color lineColor;
  float bondLength = 50;

  //constructor 1
  Atom() {
    this("C", 4, defaultLineColor);
  }

  //constructor 2
  Atom(color lineColor) {
    this("C", 4, lineColor);
  }

  //constructor 3
  Atom(String element, int bondingNumber, color lineColor) {
    this.element = element;
    this.bondingNumber = bondingNumber;
    this.lineColor = lineColor;
    this.children = new Atom[3];
    this.numBonds = 1;
  }

  void addChild(Atom child) {
    children[numChildren] = child;
    numChildren++;
  }

  //for double or triple bonds
  void setNumBonds(int numBonds) {
    this.numBonds = numBonds;
  }

  //Draws each line segment in the molecule
  void draw(PVector fromCoords, float angle) {
    stroke(lineColor);
    fill(lineColor);
    strokeWeight(2);

    if (this.numBonds == 3) { // Molecules are linear around a triple bond
      if (angle > 0)
        angle -= PI/3;
      else
        angle += PI/3;
    }
    PVector direction = PVector.fromAngle(angle);

    PVector newCoords = direction.copy();
    newCoords.setMag(this.bondLength);
    newCoords.add(fromCoords);

    //Carbons have no need for a text symbol
    PVector bondLine = direction.copy();
    bondLine.setMag(this.bondLength);
    if (this.element.equals("C"))
      bondLine.setMag(this.bondLength);
    else
      bondLine.setMag(this.bondLength - textMargin);

    // Draws the single bond
    //TODO: need a bond1Start for if we're branching off of a N or O etc.
    PVector bond1End = bondLine.copy();
    bond1End.add(fromCoords);
    line(fromCoords.x, fromCoords.y, bond1End.x, bond1End.y);

    if (this.numBonds > 1) {
      // Draws the double bond
      PVector bond2Start = direction.copy();
      bond2Start.rotate(PI/2);
      bond2Start.setMag(bondOffset);
      PVector bond2End = bond2Start.copy();
      bond2End.add(bondLine);
      bond2Start.add(fromCoords);
      bond2End.add(fromCoords);
      line(bond2Start.x, bond2Start.y, bond2End.x, bond2End.y);

      if (this.numBonds > 2) {
        // Draws the triple bond
        PVector bond3Start = direction.copy();
        bond3Start.rotate(-PI/2);
        bond3Start.setMag(bondOffset);
        PVector bond3End = bond3Start.copy();
        bond3End.add(bondLine);
        bond3Start.add(fromCoords);
        bond3End.add(fromCoords);
        line(bond3Start.x, bond3Start.y, bond3End.x, bond3End.y);
      }
    }

    //adds appropriate number of hydrogens for certain branches (eg. OH, NH2)
    if (!this.element.equals("C")) {
      String symbol = this.element;
      int numHydrogens = this.bondingNumber - this.numChildren - this.numBonds;
      if (numHydrogens >= 1) {
        symbol += "H";
        if (numHydrogens == 2)
          symbol += "\u2082"; //subscript 2
        if (numHydrogens == 3)
          symbol += "\u2083"; //subscript 3
      }
      text(symbol, newCoords.x, newCoords.y);
    }

    drawChildren(newCoords, angle);
  }

  void drawChildren(PVector fromCoords, float angle) {
    if (numChildren == 3) {
      // Handles a 4-way intersection (90 degree angles)
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

      //unless triple bond, zig-zag the line angles
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