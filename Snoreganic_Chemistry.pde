// configurations for drawing the molecule
color defaultLineColor = #000000;
int textMargin = 15;
float bondOffset = 8;

//set up the user interface and molecule to be drawn
UI ui;
Molecule molecule;

void setup() {
  //set up the interface
  size(960, 540);
  background(#ffffff);
  noLoop();

  textAlign(CENTER, CENTER);
  PFont font = createFont("Arial Unicode", 20);
  textFont(font);
  
  ui = new UI();
}

//draw the user interface and the molecule, if possible
void draw() {
  ui.draw();
  
  if (molecule != null) {
    molecule.draw();
  }
}

//create molecule from the inputted name
void createMolecule(String input) {
  molecule = new Molecule(input); 

}

//event handling
void keyPressed() {
  ui.keyPressed();
}

void mousePressed() {
  ui.mousePressed();
}

void mouseReleased() {
  ui.mouseReleased();
}