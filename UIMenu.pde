class UIMenu {
  boolean state;
  PVector[] buttonPositions;
  String[] commonNamesLines, IUPACNamesLines, IUPACNamesDisplayLines;
  int marginWidth, marginHeight, rectWidth, rectHeight;

  UIMenu() {
    this.state = false;
    this.buttonPositions = new PVector[12];

    // Load the data files containing the names
    this.commonNamesLines = loadStrings("data/commonNames.txt");
    this.IUPACNamesLines = loadStrings("data/IUPACNames.txt");
    this.IUPACNamesDisplayLines = loadStrings("data/IUPACNamesDisplay.txt");

    // 
    this.marginWidth = width / 40;
    this.marginHeight = (height * 9 / 10) / 30;
    this.rectWidth = width / 5;
    this.rectHeight = (height * 9 / 10) * 8 / 30;

    // Set each menu item's x,y position on the screen
    int index = 0;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 4; j++) {
        this.buttonPositions[index] = new PVector(j * width / 4, i * (height * 9 / 10) / 3 + (height / 10));
        index++;
      }
    }
  }

  void draw() {
    background(#FFFFFF);

    for (int i = 0; i < this.buttonPositions.length; i++) {
      fill(#FFFFFF);
      stroke(#1A1A1A);

      // Draw the box containing this menu item
      float x = this.buttonPositions[i].x + marginWidth;
      float y = this.buttonPositions[i].y + marginHeight;
      rect(x, y, this.rectWidth, this.rectHeight);
      
      // Turn literal "\n" strings in the IUPACNamesDisplay file into actual newline characters
      IUPACNamesDisplayLines[i] = IUPACNamesDisplayLines[i].replace("\\n", "\n");

      fill(#666666);
      textSize(15);

      String commonName = commonNamesLines[i];
      if (commonName.equals(" ")) {
        // Display the IUPAC name in the center of the box
        float xIUPACName = x + this.rectWidth / 2;
        float yIUPACName = y + this.rectHeight * 2 / 4;
        text(IUPACNamesDisplayLines[i], xIUPACName, yIUPACName);
      }
      else {
        // Display
        float xCommonName = x + this.rectWidth / 2;
        float yCommonName = y + this.rectHeight / 3;
        text(commonName, xCommonName, yCommonName);
        float xIUPACName = x + this.rectWidth / 2;
        float yIUPACName = y + this.rectHeight * 2 / 3;
        text("(" + IUPACNamesDisplayLines[i] + ")", xIUPACName, yIUPACName);
      }
    }
  }

  void mousePressed() {
    // Check if the mouse was clicked inside any of the menu buttons
    if (this.state == true) {
      for (int i = 0; i < this.buttonPositions.length; i++) {
        if (mouseX > this.buttonPositions[i].x
          && mouseX < this.buttonPositions[i].x + this.rectWidth
          && mouseY > this.buttonPositions[i].y
          && mouseY < this.buttonPositions[i].y + this.rectHeight) {

          // If so, set the text input field to this name, and draw the molecule
          textField.setText(this.IUPACNamesLines[i]);
          createMolecule();
        }
      }
    }
  }
}