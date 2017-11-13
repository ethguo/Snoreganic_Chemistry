class UI {
  int cursor = 0;
  String input = "";

  Button grey, green, yellow, red;

  //constructor
  UI() {
    this.grey = new Button(height / 40, height / 40, #999999);
    this.green = new Button(width - height * 9 / 40, height / 40, #80ff80);
    this.yellow = new Button(width - height * 3 / 20, height / 40, #ffff80);
    this.red = new Button(width - height * 3 / 40, height / 40, #ff8080);
  }

  //grey background for welcome screen
  void draw() {
    if (molecule == null) {
      background(#666666);
    } else {
      background(#ffffff);
    }

    strokeWeight(1);

    //creating top input bar
    fill(#333333);
    noStroke();
    rect(0, 0, width, height * 2 / 20);

    fill(#666666);
    stroke(#1a1a1a);
    rect(height / 10, height / 40, width - height * 7 / 20, height / 20, height / 40);

    //draw the buttons
    this.grey.draw();
    this.green.draw();
    this.yellow.draw();
    this.red.draw();

    String textWithCursor;

    fill(#ffffff);
    textSize(15);

    //managing the underscore cursor
    if (cursor == this.input.length()) {
      textWithCursor = this.input + " \u0332";
    } else {
      textWithCursor = this.insertChar('\u0332', this.cursor + 1);
    }

    text(textWithCursor, height / 10 + (width - height * 7 / 20) / 2, height / 20);
  }

  //display name as it's being typed
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
        createMolecule(this.input.toLowerCase());
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

  //identify which button was clicked
  void mousePressed() {
    if (this.grey.overButton() == true) {
      this.grey.colour = #4C4C4C;
    } else if (this.green.overButton() == true) {
      this.green.colour = #408040;

      createMolecule(this.input.toLowerCase());
    } else if (this.yellow.overButton() == true) {
      this.yellow.colour = #808040;

      saveFrame("Screenshots/" + input + ".png");
    } else if (this.red.overButton() == true) {
      this.red.colour = #804040;

      this.cursor = 0;
      this.input = "";

      molecule = null;
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