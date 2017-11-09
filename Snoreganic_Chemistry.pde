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
  PFont font = createFont("Arial", 20);
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
  molecule.baseChain[6].numBonds = 2;
  molecule.baseChain[9].numBonds = 3;

  // 4-chloro-12-bromo
  molecule.addBranch(4, new Halogen("Cl", #CCCC00));
  molecule.addBranch(12, new Halogen("Br", #FF00FF));
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