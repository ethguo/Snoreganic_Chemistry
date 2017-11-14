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

  strokeWeight(2);
  
  textAlign(CENTER, CENTER);
  PFont font = createFont("Arial Unicode", 30);
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

boolean createMolecule(String name) {
  if (name.equals(""))
    return false;

  Molecule m = new Molecule();
  boolean success;

  String[][] groups = matchAll(name, "(?:(\\d+(?:,\\d+)*)-)?(\\w+(?: acid)?)");

  for (int i = 0; i < groups.length; i++) {
    success = m.parseGroup(groups[i]);
    if (success == false) {
      print("Failed: ");
      println(groups[i][0]);
      return false;
    }
  }

  success = m.isValid();
  if (success)
    molecule = m;

  return success;
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