class UI {
  int cursor = 0;
  String input = "";

  Button grey, green, yellow, red;

  DropDownMenu ddm;

  UI() {
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

        strokeWeight(2);

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

    strokeWeight(1);

    fill(#333333);
    noStroke();

    rect(0, 0, width, height * 2 / 20);

    fill(#666666);
    stroke(#1a1a1a);

    rect(height / 10, height / 40, width - height * 7 / 20, height / 20, height / 40);

    this.grey.draw();
    this.green.draw();
    this.yellow.draw();
    this.red.draw();

    String textWithCursor;

    fill(#ffffff);
    textSize(15);

    if (cursor == this.input.length()) {
      textWithCursor = this.input + " \u0332";
    } else {
      textWithCursor = this.insertChar('\u0332', this.cursor + 1);
    }

    text(textWithCursor, height / 10 + (width - height * 7 / 20) / 2, height / 20);
  }

  void keyPressed() {
    if (key == CODED) {
      if (keyCode == LEFT && this.cursor > 0) {
        this.cursor--;
      } else if (keyCode == RIGHT && this.cursor < this.input.length()) {
        this.cursor++;
      } else if (keyCode == UP) {
        this.cursor = 0;
      } else if (keyCode == DOWN) {
        this.cursor = this.input.length();
      }
    } else {
      if (key == ENTER) {
        createMolecule();
      } else if (key == BACKSPACE && this.cursor > 0) {
        this.cursor--;
        this.input = this.popChar(this.cursor);
      } else if (key == DELETE && this.cursor < this.input.length()) {
        this.input = this.popChar(this.cursor);
      } else if (key > 31 && key < 127 && this.input.length() < 90) {
        this.input = this.insertChar(key, this.cursor);
        this.cursor++;
      }
    }

    redraw();
  }

  void mousePressed() {
    if (this.grey.overButton() == true) {
      this.grey.colour = #4C4C4C;

      molecule = null;

      this.ddm.state = true;
    } else if (this.green.overButton() == true) {
      this.green.colour = #408040;

      if (this.input.length() > 0) {
        createMolecule();
      }
    } else if (this.yellow.overButton() == true) {
      if (molecule != null) {
        this.yellow.colour = #808040;

        saveFrame("Screenshots/" + input + ".png");
      }
    } else if (this.red.overButton() == true) {
      this.red.colour = #804040;

      this.cursor = 0;
      this.input = "";

      molecule = null;

      this.ddm.state = false;
    }

    if (this.ddm.state == true) {
      for (int i = 0; i < this.ddm.buttonPositions.length; i++) {
        if ((mouseX > this.ddm.buttonPositions[i].x && mouseX < this.ddm.buttonPositions[i].x + this.ddm.rectWidth) && (mouseY > this.ddm.buttonPositions[i].y && mouseY < this.ddm.buttonPositions[i].y + this.ddm.rectHeight)) {
          this.input = this.ddm.commonNamesIUPACLines[i];
          this.cursor = this.input.length();

          createMolecule();
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

  String insertChar(char character, int index) {
    String start = this.input.substring(0, index);
    String end = this.input.substring(index);

    return start + character + end;
  }

  String popChar(int index) {
    String start = this.input.substring(0, index);
    String end = this.input.substring(index + 1);

    return start + end;
  }
}