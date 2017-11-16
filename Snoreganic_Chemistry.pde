// Global properties for drawing
color defaultLineColor = #000000;
int textMargin = 15;
float bondOffset = 8;

// global variables
Molecule molecule;
boolean fullColour;

// UI components
UITextField textField;
UIButton buttonMenu, buttonEnter, buttonSave, buttonClear, buttonColours;
UIMenu menu;

void setup() {
  size(960, 540);
  noLoop();
  background(#FFFFFF);

  strokeWeight(2);

  // Set font
  textAlign(CENTER, CENTER);
  PFont font = createFont("Arial Unicode", 30);
  textFont(font);

  // initialize UI elements
  textField = new UITextField();

  buttonMenu = new UIButton(height / 40, height / 40, #999999);
  buttonEnter = new UIButton(width - height * 9 / 40, height / 40, #80FF80);
  buttonSave = new UIButton(width - height * 3 / 20, height / 40, #FFFF80);
  buttonClear = new UIButton(width - height * 3 / 40, height / 40, #FF8080);

  buttonColours = new UIButton(height / 40, height - height * 3/40, #667fff);
  fullColour = true;

  menu = new UIMenu();
}

void draw() {
  if (molecule == null) { // If there is no molecule currently displayed
    if (menu.state == true)
      menu.draw(); // display menu of example organic compounds if grey button is clicked
    else
      drawLandingPage(); // else display welcome screen
  }
  else {
    menu.state = false; // hide menu
    background(#FFFFFF);
    molecule.draw(); // draw line diagram
  }

  // Dark gray background for the header section
  fill(#333333);
  noStroke();
  rect(0, 0, width, height * 2 / 20);

  buttonMenu.draw();
  buttonEnter.draw();
  buttonSave.draw();
  buttonClear.draw();

  if (molecule != null) {
    buttonColours.draw(); // special button for toggling colours to and from black lines

    fill(#666666);
    textSize(15);
    text("Toggle colour", height * 7/40, height - height * 2/40);
  }

  textField.draw();
}

// display welcome screen
void drawLandingPage() {
  background(#666666);

  fill(#FFFFFF);
  textSize(30);
  text("Welcome to Snore-ganic Chemistry™!", width / 2, height * 12 / 40);

  fill(#99D6FF);
  textSize(20);
  text("Helping SCH 4U students pass organic chemistry", width / 2, height * 15 / 40);

  fill(#FFFFFF);
  textSize(18);
  text("To get started, type in a valid IUPAC name in the text field above,", width / 2, height * 20 / 40);
  text("or choose an organic compound from our list by pressing the grey button.", width / 2, height * 22 / 40);

  textSize(18);
  text("Press the green button or hit ENTER to draw your IUPAC name.", width / 2, height * 27 / 40);
  text("Press the yellow button to save your line diagram as an image file.", width / 2, height * 29 / 40);
  text("Press the red button to clear and return to this welcome screen.", width / 2, height * 31 / 40);

  textSize(10);
  text("Copyright © 2017 Julia Baribeau, Fred Chun, Ethan Guo. All rights reserved.", width / 2, height * 36 / 40);

  // Gray line pointing to the menu button
  stroke(#999999);
  line(height / 20, height * 5 / 40, height / 20, height * 22 / 40);
  line(width * 3 / 20, height * 22 / 40, height / 20, height * 22 / 40);

  // Green line pointing to enter button
  stroke(#80FF80);
  line(width - height * 9 / 40 + height / 40, height * 5 / 40, width - height * 9 / 40 + height / 40, height * 27 / 40);
  line(width * 17 / 20, height * 27 / 40, width - height * 9 / 40 + height / 40, height * 27 / 40);

  // Yellow line pointing to save button
  stroke(#FFFF80);
  line(width - height * 3 / 20 + height / 40, height * 5 / 40, width - height * 3 / 20 + height / 40, height * 29 / 40);
  line(width * 17 / 20, height * 29 / 40, width - height * 3 / 20 + height / 40, height * 29 / 40);

  // Red line pointing to clear button
  stroke(#FF8080);
  line(width - height * 3 / 40 + height / 40, height * 5 / 40, width - height * 3 / 40 + height / 40, height * 31 / 40);
  line(width * 17 / 20, height * 31 / 40, width - height * 3 / 40 + height / 40, height * 31 / 40);
}

// keyboard detection for user input for IUPAC names
void keyPressed() {
  if (key == ENTER)
    createMolecule(); // draw line diagram if ENTER is pressed
  else
    // Let the textField handle any other key
    textField.keyPressed();

  redraw();
}

// mouse pressed detection for menu items and buttons
void mousePressed() {
  if (buttonMenu.overButton() == true) {
    // If the grey button was clicked, toggle the menu
    buttonMenu.colour = #4C4C4C;

    if (menu.state == true)
      menu.state = false;
    else {
      molecule = null;
      menu.state = true;
    }
  }
  else if (buttonEnter.overButton() == true) {
    // If the green button was clicked, draw the molecule
    buttonEnter.colour = #408040;

    if (textField.notEmpty())
      createMolecule();
  }
  else if (buttonSave.overButton() == true) {
    // If the yellow button was clicked, take a screenshot
    if (molecule != null) {
      buttonSave.colour = #808040;

      saveFrame("Screenshots/" + textField.getText() + ".png");
    }
  }
  else if (buttonClear.overButton() == true) {
    // If the red button was clicked, clear the screen
    buttonClear.colour = #804040;

    molecule = null;
    textField.clearText();
    menu.state = false;
  }
  else if (buttonColours.overButton() == true) {
    // If the toggle button was clicked, toggle between black lines and coloured lines
    if (fullColour)
      buttonColours.colour = #111111;
    else
      buttonColours.colour = #667fff;
    fullColour = !fullColour;
  }

  // Tell the menu to handle the mousePressed event
  menu.mousePressed();

  redraw();
}

// 3d button effect with colour change
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
    // If the name box is blank, that's not a valid molecule. Stop right away.
    textField.setError(true);
    return;
  }

  Molecule m = new Molecule();
  boolean success;

  // Using a regex, split the name into "locant-groupName" groups (ex. "2,3-dimethyl" is one group)
  String[][] groups = matchAll(name, "(?:(\\d+(?:,\\d+)*)-)?(\\w+(?: acid)?)");

  // Try parsing each group
  for (int i = 0; i < groups.length; i++) {
    success = m.parseGroup(groups[i]);
    if (success == false) {
      // If there's a problem, stop right away
      println("Failed: " + groups[i][0]);
      textField.setError(true);
      return;
    }
  }

  // Check if the molecule as a whole is valid
  success = m.isValid();
  // Indicate on the text field whether the name was successfully parsed
  textField.setError(!success);

  // Only assign this molecule to the "global" molecule variable if everything was successful
  if (success)
    molecule = m;
  else
    println("Failed: No base chain");
}