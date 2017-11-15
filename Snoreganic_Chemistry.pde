// configurations for drawing the molecule
color defaultLineColor = #000000;
int textMargin = 15;
float bondOffset = 8;


TextField textField;
Button buttonMenu, buttonEnter, buttonSave, buttonClear;
DropDownMenu menu;

Molecule molecule;

void setup() {
  size(960, 540);
  background(#FFFFFF);
  noLoop();

  strokeWeight(2);
  
  textAlign(CENTER, CENTER);
  PFont font = createFont("Arial Unicode", 30);
  textFont(font);

  textField = new TextField();

  buttonMenu = new Button(height / 40, height / 40, #999999);
  buttonEnter = new Button(width - height * 9 / 40, height / 40, #80FF80);
  buttonSave = new Button(width - height * 3 / 20, height / 40, #FFFF80);
  buttonClear = new Button(width - height * 3 / 40, height / 40, #FF8080);

  menu = new DropDownMenu();
}

void draw() {
  if (molecule == null) {
    if (menu.state == true)
      menu.draw();
    else
      drawLandingPage();
  }
  else {
    menu.state = false;

    background(#FFFFFF);
    molecule.draw();
  }


  fill(#333333);
  noStroke();
  rect(0, 0, width, height * 2 / 20);

  buttonMenu.draw();
  buttonEnter.draw();
  buttonSave.draw();
  buttonClear.draw();

  textField.draw();
}

void drawLandingPage() {
  background(#666666);

  fill(#FFFFFF);
  textSize(30);
  text("Welcome to Snore-ganic Chemistry™!", width / 2, height * 12 / 40);

  fill(#99D6FF);
  textSize(20);
  text("Designed to help SCH 4U students pass.", width / 2, height * 15 / 40);

  fill(#FFFFFF);
  textSize(18);
  text("To get started, type in a valid IUPAC name in the text field above,", width / 2, height * 20 / 40);
  text("or choose an organic compound from our list by pressing the grey button.", width / 2, height * 22 / 40);

  fill(#FFFFFF);
  textSize(18);
  text("Press the green button or hit ENTER to draw your IUPAC name.", width / 2, height * 27 / 40);
  text("Press the yellow button to save your line diagram as an image file.", width / 2, height * 29 / 40);
  text("Press the red button to clear and return to this welcome screen.", width / 2, height * 31 / 40);

  fill(#FFFFFF);
  textSize(12);
  text("Copyright © 2017 Julia Baribeau, Fred Chun, Ethan Guo. All rights reserved.", width / 2, height * 36 / 40);

  stroke(#999999);
  line(height / 20, height * 5 / 40, height / 20, height * 22 / 40);
  line(width * 3 / 20, height * 22 / 40, height / 20, height * 22 / 40);

  stroke(#80FF80);
  line(width - height * 9 / 40 + height / 40, height * 5 / 40, width - height * 9 / 40 + height / 40, height * 27 / 40);
  line(width * 17 / 20, height * 27 / 40, width - height * 9 / 40 + height / 40, height * 27 / 40);

  stroke(#FFFF80);
  line(width - height * 3 / 20 + height / 40, height * 5 / 40, width - height * 3 / 20 + height / 40, height * 29 / 40);
  line(width * 17 / 20, height * 29 / 40, width - height * 3 / 20 + height / 40, height * 29 / 40);

  stroke(#FF8080);
  line(width - height * 3 / 40 + height / 40, height * 5 / 40, width - height * 3 / 40 + height / 40, height * 31 / 40);
  line(width * 17 / 20, height * 31 / 40, width - height * 3 / 40 + height / 40, height * 31 / 40);
}

void keyPressed() {
  if (key == ENTER)
    createMolecule();
  else
    textField.keyPressed();

  redraw();
}

void mousePressed() {
  if (buttonMenu.overButton() == true) {
    buttonMenu.colour = #4C4C4C;

    molecule = null;

    menu.state = true;
  }
  else if (buttonEnter.overButton() == true) {
    buttonEnter.colour = #408040;

    if (textField.notEmpty()) {
      createMolecule();
    }
  }
  else if (buttonSave.overButton() == true) {
    if (molecule != null) {
      buttonSave.colour = #808040;

      saveFrame("Screenshots/" + textField.getText() + ".png");
    }
  }
  else if (buttonClear.overButton() == true) {
    buttonClear.colour = #804040;

    textField.clearText();

    molecule = null;

    menu.state = false;
  }

  if (menu.state == true) {
    for (int i = 0; i < menu.buttonPositions.length; i++) {
      if (mouseX > menu.buttonPositions[i].x
        && mouseX < menu.buttonPositions[i].x + menu.rectWidth
        && mouseY > menu.buttonPositions[i].y
        && mouseY < menu.buttonPositions[i].y + menu.rectHeight) {

        textField.setText(menu.commonNamesIUPACLines[i]);
        createMolecule();
      }
    }
  }

  redraw();
}

void mouseReleased() {
  buttonMenu.colour = #999999;
  buttonEnter.colour = #80FF80;
  buttonSave.colour = #FFFF80;
  buttonClear.colour = #FF8080;

  redraw();
}

void createMolecule() {
  String name = textField.getText();
  if (name.equals("")) {
    textField.setError(true);
    return;
  }

  Molecule m = new Molecule();
  boolean success;

  String[][] groups = matchAll(name, "(?:(\\d+(?:,\\d+)*)-)?(\\w+(?: acid)?)");

  for (int i = 0; i < groups.length; i++) {
    success = m.parseGroup(groups[i]);
    if (success == false) {
      print("Failed: ");
      println(groups[i][0]);
      textField.setError(true);
      return;
    }
  }

  success = m.isValid();
  if (success) {
    textField.setError(false);
    molecule = m;

    molecule.addBranch(2, makeCyclic(5, #900000));
  }
  else {
    textField.setError(true);
  }
}