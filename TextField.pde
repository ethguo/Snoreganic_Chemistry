class TextField {
  int cursor = 0;
  String string = "";
  color colour;

  TextField() {
    this.colour = #666666;
  }

  void draw() {

    fill(this.colour);
    stroke(#1a1a1a);

    rect(height / 10, height / 40, width - height * 7 / 20, height / 20, height / 40);

    String stringWithCursor;

    fill(#ffffff);
    textSize(15);

    if (cursor == this.string.length()) {
      stringWithCursor = this.string + " \u0332";
    } else {
      stringWithCursor = this.insertChar('\u0332', this.cursor + 1);
    }

    text(stringWithCursor, height / 10 + (width - height * 7 / 20) / 2, height / 20);
  }

  void keyPressed() {
    if (key == CODED) {
      if (keyCode == LEFT && this.cursor > 0) {
        this.cursor--;
      } else if (keyCode == RIGHT && this.cursor < this.string.length()) {
        this.cursor++;
      } else if (keyCode == UP) {
        this.cursor = 0;
      } else if (keyCode == DOWN) {
        this.cursor = this.string.length();
      }
    } else {
      if (key == BACKSPACE && this.cursor > 0) {
        this.cursor--;
        this.string = this.popChar(this.cursor);
      } else if (key == DELETE && this.cursor < this.string.length()) {
        this.string = this.popChar(this.cursor);
      } else if (key > 31 && key < 127 && this.string.length() < 90) {
        this.string = this.insertChar(key, this.cursor);
        this.cursor++;
      }
    }
  }

  boolean notEmpty() {
    return (this.string.length() > 0);
  }

  String getText() {
    return this.string.toLowerCase();
  }

  void setText(String t) {
    this.string = t;
    this.cursor = t.length();
  }

  void clearText() {
    this.string = "";
    this.cursor = 0;
  }

  void setError(boolean error) {
    if (error)
      this.colour = #B85858;
    else
      this.colour = #666666;
  }

  private String insertChar(char character, int index) {
    String start = this.string.substring(0, index);
    String end = this.string.substring(index);

    return start + character + end;
  }

  private String popChar(int index) {
    String start = this.string.substring(0, index);
    String end = this.string.substring(index + 1);

    return start + end;
  }
}