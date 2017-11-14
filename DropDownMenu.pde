class DropDownMenu {
  boolean state;
  PVector[] buttonPositions;
  String[] commonNamesLines = loadStrings("data/commonNames.txt");
  String[] commonNamesIUPACLines = loadStrings("data/commonNamesIUPAC.txt");
  String[] commonNamesIUPACDisplayLines = loadStrings("data/commonNamesIUPACDisplay.txt");
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
      strokeWeight(2);
      rect(this.buttonPositions[i].x + marginWidth, this.buttonPositions[i].y + marginHeight, this.rectWidth, this.rectHeight);
      
      commonNamesIUPACDisplayLines[i] = commonNamesIUPACDisplayLines[i].replace("\\n", "\n");

      fill(#666666);
      textSize(15);
      text("(" + commonNamesIUPACDisplayLines[i] + ")", this.buttonPositions[i].x + marginWidth + this.rectWidth / 2, this.buttonPositions[i].y + marginHeight + this.rectHeight * 2 / 4);
      text(commonNamesLines[i], this.buttonPositions[i].x + marginWidth + this.rectWidth / 2, this.buttonPositions[i].y + marginHeight + this.rectHeight / 4);
    }
  }
}