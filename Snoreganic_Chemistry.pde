color defaultLineColor = #000000;
int textMargin = 15;
float bondOffset = 8;

Molecule molecule;

Button grey, green, yellow, red;
String input = "";
int cursor = 0;
boolean drawUpdate = false;

void setup() {
  size(960, 540);
  noLoop();
  strokeWeight(2);

  textAlign(CENTER, CENTER);
  PFont font = createFont("Arial", 20);
  textFont(font);

  grey = new Button(height / 40, height / 40, #999999);
  grey.display();

  green = new Button(width - height * 9 / 40, height / 40, #80ff80);
  green.display();

  yellow = new Button(width - height * 3 / 20, height / 40, #ffff80);
  yellow.display();

  red = new Button(width - height * 3 / 40, height / 40, #ff8080);
  red.display();
}

void draw() {
  background(#ffffff);

  fill(#333333);
  noStroke();

  rect(0, 0, width, height * 2 / 20);

  grey.display();

  fill(#666666);
  stroke(#1a1a1a);

  rect(height / 10, height / 40, width - height * 7 / 20, height / 20, height / 40);

  green.display();
  yellow.display();
  red.display();

  fill(#ffffff);
  textSize(15);
  String textWithCursor;
  if (cursor == input.length())
    textWithCursor = input + " \u0332";
  else
    textWithCursor = insertChar(input, '\u0332', cursor+1);  
  text(textWithCursor, height / 10 + (width - height * 7 / 20) / 2, height / 20);

  if (molecule != null) {
    molecule.draw();
  }
}

void createMolecule() {
  molecule = new Molecule(input);

  // 2-methyl-3-ethyl-4-butyl
  molecule.addBranch(2, makeCarbonChain(1, #FF0000));
  molecule.addBranch(3, makeCarbonChain(2, #00FF00));
  molecule.addBranch(4, makeCarbonChain(4, #0000FF));

  // 6-ene-9-yne
  molecule.baseChain[6].setNumBonds(2);
  molecule.baseChain[9].setNumBonds(3);

  // 4-bromo-5-chloro
  molecule.addBranch(4, new Atom("Br", 1, #FF00FF));
  molecule.addBranch(5, new Atom("Cl", 1, #CCCC00));

  // 12-hydroxy
  molecule.addBranch(12, new Atom("O", 2, #FF9900));

  // 12-oxo
  Atom oxoBranch = new Atom("O", 2, #00FFFF);
  oxoBranch.setNumBonds(2);
  molecule.addBranch(12, oxoBranch);
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == LEFT && cursor > 0)
      cursor--;
    else if (keyCode == RIGHT && cursor < input.length())
      cursor++;
    else if (keyCode == UP)
      cursor = 0;
    else if (keyCode == DOWN)
      cursor = input.length();
  }
  else {
    if (key == ENTER) {
      createMolecule();
    }
    else if (key == BACKSPACE && cursor > 0) {
      cursor--;
      input = popChar(input, cursor);
    }
    else if (key == DELETE && cursor < input.length()) {
      input = popChar(input, cursor);
    }
    else if (key > 31 && key < 127) {
      input = insertChar(input, key, cursor);
      cursor++;
    }
  }

  redraw();
}

String insertChar(String string, char character, int index) {
  String start = string.substring(0, index);
  String end = string.substring(index);

  return start + character + end;
}

String popChar(String string, int index) {
  String start = string.substring(0, index);
  String end = string.substring(index+1);

  return start + end;
}