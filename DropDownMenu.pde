class DropDownMenu {
  boolean state;
  PVector[] buttonPositions;
  String[] commonNamesIUPAC = {"2-methyl-1,3-butadiene", "propanone", "", "", "", "", "", "", "", "", "", ""};
  String[] commonNames = {"Isoprene", "Acetone", "", "", "", "", "", "", "", "", "", ""};
  int marginWidth = width / 40;
  int marginHeight = (height * 9 / 10) / 30;
  int rectWidth = width / 5;
  int rectHeight = (height * 9 / 10) * 8 / 30;

  DropDownMenu() {
    this.state = false;
    this.buttonPositions = new PVector[12];

    int c = 0;

    while (c < this.buttonPositions.length) {
      for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 3; j++) {
          this.buttonPositions[c] = new PVector(i * width / 4, j * (height * 9 / 10) / 3 + (height / 10));

          c++;
        }
      }
    }
  }

  void draw() {
    for (int i = 0; i < this.buttonPositions.length; i++) {
      fill(#ffffff);
      stroke(#1a1a1a);
      strokeWeight(1);
      rect(this.buttonPositions[i].x + marginWidth, this.buttonPositions[i].y + marginHeight, this.rectWidth, this.rectHeight);

      fill(#666666);
      textSize(15);
      text("(" + commonNamesIUPAC[i] + ")", this.buttonPositions[i].x + marginWidth + this.rectWidth / 2, this.buttonPositions[i].y + marginHeight + this.rectHeight * 3 / 4);
      text(commonNames[i], this.buttonPositions[i].x + marginWidth + this.rectWidth / 2, this.buttonPositions[i].y + marginHeight + this.rectHeight / 4);
    }
  }
}