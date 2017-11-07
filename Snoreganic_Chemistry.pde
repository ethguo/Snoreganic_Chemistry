color defaultLineColor = #000000;
int textMargin = 15;
float bondOffset = 8;

Molecule molecule;

Button grey, green, yellow, red;
String input = "";
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
  text(input + "_", height / 10 + (width - height * 7 / 20) / 2, height / 20);

  if (molecule != null) {
    molecule.draw();
  }
}

void createMolecule() {
  molecule = new Molecule(input);

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

void keyPressed() {
  if (key == CODED) {
    //
  } else {
    if (key == BACKSPACE) {
      if (input.length() > 0) {
        input = input.substring(0, input.length() - 1);
      }
    } else if (key == ENTER) {
      createMolecule();
    } else {
      input += key;
    }
  }

  redraw();
}