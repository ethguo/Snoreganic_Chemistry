color defaultLineColor = #000000;
int textMargin = 15;
float bondOffset = 8;

Carbon[] baseChain;

int numCarbons;
String name;

void setup() {
  size(800, 600);
  strokeWeight(2);
  textAlign(CENTER, CENTER);
  PFont font = createFont("Arial", 20);
  textFont(font);
}

void draw() {
  background(255);
}

Carbon makeCarbonChain(int n, color lineColor) {
  Carbon chain = new Carbon(lineColor);
  if (n > 1)
    chain.addChild(makeCarbonChain(n-1, lineColor));
  return chain;
}