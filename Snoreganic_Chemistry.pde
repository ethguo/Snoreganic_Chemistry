// configurations for drawing the molecule
color defaultLineColor = #000000;
int textMargin = 15;
float bondOffset = 8;

UI ui;

Molecule molecule;

void setup() {
  size(960, 540);
  background(#ffffff);
  noLoop();

  textAlign(CENTER, CENTER);
  PFont font = createFont("Arial Unicode", 20);
  textFont(font);

  ui = new UI();
}

void draw() {
  ui.draw();

  if (molecule != null) {
    ui.ddm.state = false;

    molecule.draw();
  }
}

void createMolecule(String input) {
  molecule = new Molecule(input); 
}

void keyPressed() {
  ui.keyPressed();
}

void mousePressed() {
  ui.mousePressed();
}

void mouseReleased() {
  ui.mouseReleased();
}