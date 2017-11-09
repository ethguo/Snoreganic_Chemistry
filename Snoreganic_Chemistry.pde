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
    molecule.draw();
  }
}

void createMolecule() {
  molecule = new Molecule(ui.input);

  // 2-methyl-3-ethyl-4-butyl
  molecule.addBranch(2, makeCarbonChain(1, #FF0000));
  molecule.addBranch(3, makeCarbonChain(2, #00FF00));
  molecule.addBranch(4, makeCarbonChain(4, #0000FF));

  // 6-ene-9-yne
  if (molecule.mainFunc == "alkene")
    molecule.baseChain[6].setNumBonds(2);
  else if (molecule.mainFunc == "alkyne")
    molecule.baseChain[6].setNumBonds(3);
  //molecule.baseChain[9].numBonds = 3;

  // 4-bromo-5-chloro
  molecule.addBranch(4, new Atom("Br", 1, #FF00FF));
  molecule.addBranch(5, new Atom("Cl", 1, #CCCC00));

  // 11-amino-12-hydroxy
  molecule.addBranch(11, new Atom("N", 3, #00FF99));
  molecule.addBranch(12, new Atom("O", 2, #FF9900));

  // 12-oxo
  Atom oxoBranch = new Atom("O", 2, #00FFFF);
  oxoBranch.setNumBonds(2);
  molecule.addBranch(12, oxoBranch);
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