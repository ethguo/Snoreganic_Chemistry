color defaultLineColor = #000000;
int textMargin = 15;
float bondOffset = 8;

Molecule molecule;

void setup() {
  size(800, 600);
  strokeWeight(2);
  textAlign(CENTER, CENTER);
  PFont font = createFont("Arial", 20);
  textFont(font);

  molecule = new Molecule("decane");

  // 2-methyl-3-ethyl-6-butyl
  molecule.addBranch(2, makeCarbonChain(1, #FF0000));
  molecule.addBranch(3, makeCarbonChain(2, #00FF00));
  molecule.addBranch(6, makeCarbonChain(4, #0000FF));

  // 4-ene
  molecule.baseChain[4].numBonds = 2;

  // 7-chloro-10-bromo
  molecule.addBranch(7, new Halogen("Cl", #CCCC00));
  molecule.addBranch(10, new Halogen("Br", #FF00FF));
}

void draw() {
  background(255);
  molecule.draw();
}