class UI {
  TextField textField;

  Button grey, green, yellow, red;

  DropDownMenu ddm;

  UI() {
    this.textField = new TextField();

    this.grey = new Button(height / 40, height / 40, #999999);
    this.green = new Button(width - height * 9 / 40, height / 40, #80ff80);
    this.yellow = new Button(width - height * 3 / 20, height / 40, #ffff80);
    this.red = new Button(width - height * 3 / 40, height / 40, #ff8080);

    this.ddm = new DropDownMenu();
  }

  void draw() {
    if (molecule == null) {
      if (this.ddm.state == true) {
        background(#ffffff);

        ddm.draw();
      } else {
        background(#666666);

        fill(#ffffff);
        textSize(30);
        text("Welcome to Snore-ganic Chemistry™!", width / 2, height * 12 / 40);

        fill(#99d6ff);
        textSize(20);
        text("Designed to help SCH 4U students pass.", width / 2, height * 15 / 40);

        fill(#ffffff);
        textSize(18);
        text("To get started, type in a valid IUPAC name in the text field above,", width / 2, height * 20 / 40);
        text("or choose an organic compound from our list by pressing the grey button.", width / 2, height * 22 / 40);

        fill(#ffffff);
        textSize(18);
        text("Press the green button or hit ENTER to draw your IUPAC name.", width / 2, height * 27 / 40);
        text("Press the yellow button to save your line diagram as an image file.", width / 2, height * 29 / 40);
        text("Press the red button to clear and return to this welcome screen.", width / 2, height * 31 / 40);

        fill(#ffffff);
        textSize(12);
        text("Copyright © 2017 Julia Baribeau, Fred Chun, Ethan Guo. All rights reserved.", width / 2, height * 36 / 40);

        stroke(#999999);
        line(height / 20, height * 5 / 40, height / 20, height * 22 / 40);
        line(width * 3 / 20, height * 22 / 40, height / 20, height * 22 / 40);

        stroke(#80ff80);
        line(width - height * 9 / 40 + height / 40, height * 5 / 40, width - height * 9 / 40 + height / 40, height * 27 / 40);
        line(width * 17 / 20, height * 27 / 40, width - height * 9 / 40 + height / 40, height * 27 / 40);

        stroke(#ffff80);
        line(width - height * 3 / 20 + height / 40, height * 5 / 40, width - height * 3 / 20 + height / 40, height * 29 / 40);
        line(width * 17 / 20, height * 29 / 40, width - height * 3 / 20 + height / 40, height * 29 / 40);

        stroke(#ff8080);
        line(width - height * 3 / 40 + height / 40, height * 5 / 40, width - height * 3 / 40 + height / 40, height * 31 / 40);
        line(width * 17 / 20, height * 31 / 40, width - height * 3 / 40 + height / 40, height * 31 / 40);
      }
    } else {
      background(#ffffff);
    }

    fill(#333333);
    noStroke();

    rect(0, 0, width, height * 2 / 20);

    this.grey.draw();
    this.green.draw();
    this.yellow.draw();
    this.red.draw();

    this.textField.draw();
  }

  void keyPressed() {
    if (key == ENTER)
      this.updateMolecule();
    else
      this.textField.keyPressed();

    redraw();
  }

  void mousePressed() {
    if (this.grey.overButton() == true) {
      this.grey.colour = #4C4C4C;

      molecule = null;

      this.ddm.state = true;
    } else if (this.green.overButton() == true) {
      this.green.colour = #408040;

      if (this.textField.notEmpty()) {
        this.updateMolecule();
      }
    } else if (this.yellow.overButton() == true) {
      if (molecule != null) {
        this.yellow.colour = #808040;

        saveFrame("Screenshots/" + this.textField.getText() + ".png");
      }
    } else if (this.red.overButton() == true) {
      this.red.colour = #804040;

      this.textField.clearText();

      molecule = null;

      this.ddm.state = false;
    }

    if (this.ddm.state == true) {
      for (int i = 0; i < this.ddm.buttonPositions.length; i++) {
        if (mouseX > this.ddm.buttonPositions[i].x
          && mouseX < this.ddm.buttonPositions[i].x + this.ddm.rectWidth
          && mouseY > this.ddm.buttonPositions[i].y
          && mouseY < this.ddm.buttonPositions[i].y + this.ddm.rectHeight) {

          this.textField.setText(this.ddm.commonNamesIUPACLines[i]);
          this.updateMolecule();
        }
      }
    }

    redraw();
  }

  void mouseReleased() {
    this.grey.colour = #999999;
    this.green.colour = #80ff80;
    this.yellow.colour = #ffff80;
    this.red.colour = #ff8080;

    redraw();
  }

  void updateMolecule() {
    boolean success = createMolecule(this.textField.getText());
    this.textField.setStatus(success);
  }
}