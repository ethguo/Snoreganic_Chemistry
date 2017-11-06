color defaultLineColor = #000000;
int textMargin = 15;
float bondOffset = 8;

Carbon[] baseChain;

int numCarbons = 10;

void setup() {
  size(800, 600);
  strokeWeight(2);
  textAlign(CENTER, CENTER);
  PFont font = createFont("Arial", 20);
  textFont(font);

  baseChain = new Carbon[numCarbons];

  baseChain[numCarbons-1] = new Carbon();

  for (int i = numCarbons-2; i >= 0; i--) {
    baseChain[i] = new Carbon();
    baseChain[i].addChild(baseChain[i+1]);
  }

  // A methyl, ethyl and butyl
  baseChain[1].addChild(makeCarbonChain(1, #FF0000));
  baseChain[2].addChild(makeCarbonChain(2, #00FF00));
  baseChain[5].addChild(makeCarbonChain(4, #0000FF));

  baseChain[4].numBonds = 2;

  baseChain[6].addChild(new Halogen("Cl", #CCCC00));
  baseChain[9].addChild(new Halogen("Br", #FF00FF));
}

void draw() {
  background(255);
  baseChain[0].drawChildren(new PVector(100, height/2), PI/6);
}

Carbon makeCarbonChain(int n, color lineColor) {
  Carbon chain = new Carbon(lineColor);
  if (n > 1)
    chain.addChild(makeCarbonChain(n-1, lineColor));
  return chain;
}

Carbon makeCarbonChain(int n) {
  return makeCarbonChain(n, defaultLineColor);
}