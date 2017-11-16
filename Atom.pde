class Atom {
  String element; // Symbol of element, ex. "C" or "N".
  int bondingNumber; // How many bonds that element can make, ex. C can make 4, N can make 3. Used to determine how many hydrogens to append to the name (ex. NH2).

  Atom parent; // Reference to the Atom that this Atom is a child of.
  Atom[] children; // All the Atoms that are branching off of this one.
                   // For a carbon Atom in the base chain, the next child in the chain will always be the first element of this array.
  int numChildren; // Count of how many children 
  int numBonds; // Single, double or triple bond

  color lineColor; // The color that this Atom is drawn in.
  float bondLength = 50; // The length of the bond leading to this atom.

  Atom() {
    // Default to a Carbon atom, with the default line color
    this("C", 4, defaultLineColor);
  }

  Atom(color lineColor) {
    // Default to a Carbon atom (4 bonds)
    this("C", 4, lineColor);
  }

  Atom(String element, int bondingNumber, color lineColor) {
    // Set all fields
    this.element = element;
    this.bondingNumber = bondingNumber;
    this.lineColor = lineColor;

    this.children = new Atom[3];
    this.numBonds = 1;
  }

  // Attach an Atom to this one
  void addChild(Atom child) {
    child.parent = this;
    children[numChildren] = child;
    numChildren++;
  }

  // For double or triple bonds
  void setNumBonds(int numBonds) {
    this.numBonds = numBonds;
  }

  // Draws each line segment in the molecule
  void draw(PVector fromCoords, float angle) {
    // Set line weight and color
    strokeWeight(2);
    if (fullColour) {
      stroke(lineColor);
      fill(lineColor);
    }
    else {
      stroke(defaultLineColor);
      fill(defaultLineColor);
    }

    // Molecules are linear around a triple bond -
    // If this atom is has a triple bond, cancel out the "bend"
    if (this.numBonds == 3) {
      if (angle > 0)
        angle -= PI/3;
      else
        angle += PI/3;
    }
    // newCoords is the coordinates of this atom.
    PVector newCoords = PVector.fromAngle(angle);
    newCoords.setMag(this.bondLength);
    newCoords.add(fromCoords); // At first, newCoords is relative to fromCoords. So we add on fromCoords to make it relative to the screen.

    // For the single bond, create 2 Vectors representing the start and end points of the bond.
    PVector bond1Start = PVector.fromAngle(angle);
    PVector bond1End = bond1Start.copy();

    // Since carbon atoms are drawn with no symbol (text),
    // if the parent Atom of this Atom is not a carbon atom (i.e. has text), then this bond needs to start a bit further away, so that it doesn't overlap the text.
    if (this.parent.element.equals("C"))
      bond1Start.setMag(0);
    else
      bond1Start.setMag(textMargin);

    // Similarly, if this Atom is not a carbon atom, the line needs to end a bit short, so that it doesn't go through the text.
    if (this.element.equals("C"))
      bond1End.setMag(this.bondLength);
    else
      bond1End.setMag(this.bondLength - textMargin);

    bond1Start.add(fromCoords); // Add on fromCoords, to make it relative to the screen.
    bond1End.add(fromCoords);
    line(bond1Start.x, bond1Start.y, bond1End.x, bond1End.y);

    if (this.numBonds >= 2) {
      // Draws the double bond - Almost the same as the first bond, except that the starting point is offset by some distance to one side.
      PVector bond2Offset = PVector.fromAngle(angle + PI/2);
      bond2Offset.setMag(bondOffset);
      PVector bond2Start = PVector.add(bond1Start, bond2Offset);
      PVector bond2End = PVector.add(bond1End, bond2Offset);
      line(bond2Start.x, bond2Start.y, bond2End.x, bond2End.y);

      if (this.numBonds >= 3) {
        // Draws the triple bond - Almost the same as the second bond, but offset to the other side.
        PVector bond3Offset = PVector.fromAngle(angle - PI/2);
        bond3Offset.setMag(bondOffset);
        PVector bond3Start = PVector.add(bond1Start, bond3Offset);
        PVector bond3End = PVector.add(bond1End, bond3Offset);
        line(bond3Start.x, bond3Start.y, bond3End.x, bond3End.y);
      }
    }

    // If this Atom is not a carbon, draw the symbol as text
    if (!this.element.equals("C")) {
      String symbol = this.element;
      
      // Appends the appropriate number of hydrogens to the symbol (ex. OH, NH2)
      int numHydrogens = this.bondingNumber - this.numChildren - this.numBonds;
      if (numHydrogens >= 1) {
        symbol += "H";
        if (numHydrogens == 2)
          symbol += "\u2082"; // Subscript 2
        else if (numHydrogens == 3)
          symbol += "\u2083"; // Subscript 3
      }

      textSize(15);
      text(symbol, newCoords.x, newCoords.y);
    }

    // Recursively draw all of this Atom's children
    drawChildren(newCoords, angle);
  }

  void drawChildren(PVector fromCoords, float angle) {
    if (numChildren == 3) {
      // Handles a 4-way intersection (90 degree angles)
      this.children[0].draw(fromCoords, angle); // The first child should be the next carbon, should go straight out
      this.children[1].draw(fromCoords, angle + PI/2); // the second and third branches should go on either side, at 90 degrees
      this.children[2].draw(fromCoords, angle - PI/2);
    }
    else if (numChildren >= 1) {
      // Flipping the sign each time it crosses zero ensures that the base chain (and sufficiently long side chains) will "zig-zag"
      float sign;
      if (angle > 0)
        sign = -1;
      else
        sign = 1;

      // Triple bonds are straight; single or double bonds get a 60-degree bend
      float angle1 = angle;
      if (numBonds != 3)
        angle1 += sign * PI/3;

      this.children[0].draw(fromCoords, angle1);

      if (numChildren == 2) {
        // The second child, if it exists, should just go 60 degrees the other way
        float angle2 = angle - sign * PI/3;
        this.children[1].draw(fromCoords, angle2);
      }
    }
  }

  // This method is only called for the first carbon in the chain
  void drawRoot(int numCarbons) {
    float angle = PI/6;
    // Choose a point that will approximately centre the molecule (horizontally) on the screen
    PVector fromCoords = new PVector((width - this.bondLength*cos(angle)*numCarbons) / 2, height/2);

    if (numChildren == 4) {
      // Handles a 4-way intersection (90 degree angles)
      this.children[0].draw(fromCoords, angle);
      this.children[1].draw(fromCoords, angle + PI/2);
      this.children[2].draw(fromCoords, angle + PI);
      this.children[3].draw(fromCoords, angle - PI/2);
    }
    else if (numChildren >= 1) {
      // Triple bonds are straight; single or double bonds get a 60-degree bend
      float angle1 = angle;
      if (numBonds != 3)
        angle1 -= PI/3;

      this.children[0].draw(fromCoords, angle1);

      if (numChildren >= 2) {
        float angle2 = angle + PI;
        this.children[1].draw(fromCoords, angle2);

        if (numChildren >= 3) {
          float angle3 = angle + PI/3;
          this.children[2].draw(fromCoords, angle3);
        }
      }
    }
  }
}