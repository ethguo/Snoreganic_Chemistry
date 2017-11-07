class Molecule {
  String name;
  int numCarbons;
  Atom[] baseChain;

  Molecule(String name) {
    this.name = name;
    this.numCarbons = this.findNumMainChain();
    this.baseChain = new Atom[this.numCarbons];

    this.baseChain[this.numCarbons-1] = new Atom();

    for (int i = this.numCarbons-2; i >= 0; i--) {
      this.baseChain[i] = new Atom();
      this.baseChain[i].addChild(this.baseChain[i+1]);
    }
  }


  void draw() {
    this.baseChain[0].drawChildren(new PVector(100, height/2), PI/6);
  }


  void addBranch(int index, Atom branch) {
    this.baseChain[index-1].addChild(branch);
  }

  int findNumMainChain() {
    int len = this.name.length();
    String func = this.findFunctionalGroup();

    int n = this.findNumCarbons(0, len, func);

    return n;
  }

  String findFunctionalGroup() {
    int len = this.name.length();
    String last4 = this.name.substring(len-4);

    if (last4.contains("ane"))
      return "alkane";
    else if (last4.contains("ene"))
      return "alkene";
    else if (last4.contains("yne"))
      return "alkyne";
    else if (last4.contains("ol"))
      return "alcohol";
    else if (last4.contains("al"))
      return "aldehyde";
    else if (last4.contains("one"))
      return "ketone";
    else if (last4.contains("oate"))
      return "ester";
    else
      return "unknown";
  }

  int findNumCarbons(int i1, int i2, String func) {
    int n;
    String funcChunk = this.name.substring(i1,i2);

    String end;
    if (func.equals("alkane"))
      end = "ane";
    else if (func.equals("alkene"))
      end = "ene";
    else if (func.equals("alkyne"))
      end = "yne";
    else if (func.equals("alkohol"))
      end = "anol";
    else if (func.equals("aldehyde"))
      end = "anal";
    else if (func.equals("ketone"))
      end = "one";
    else if (func.equals("ester"))
      end = "anoate";
    else
      end = "";

    if (funcChunk.contains("eicos"+end))
      n = 20;
    else if (funcChunk.contains("nonadec"+end))
      n = 19;
    else if (funcChunk.contains("octadec"+end))
      n = 18;
    else if (funcChunk.contains("heptadec"+end))
      n = 17;
    else if (funcChunk.contains("hexadec"+end))
      n = 16;
    else if (funcChunk.contains("pentadec"+end))
      n = 15;
    else if (funcChunk.contains("tetradec"+end))
      n = 14;
    else if (funcChunk.contains("tridec"+end))
      n = 13;
    else if (funcChunk.contains("dodec"+end))
      n = 12;
    else if (funcChunk.contains("undec"+end))
      n = 11;
    else if (funcChunk.contains("dec"+end))
      n = 10;
    else if (funcChunk.contains("non"+end))
      n = 9;
    else if (funcChunk.contains("oct"+end))
      n = 8;
    else if (funcChunk.contains("hept"+end))
      n = 7;
    else if (funcChunk.contains("hex"+end))
      n = 6;
    else if (funcChunk.contains("pent"+end))
      n = 5;
    else if (funcChunk.contains("but"+end))
      n = 4;
    else if (funcChunk.contains("prop"+end))
      n = 3;
    else if (funcChunk.contains("eth"+end))
      n = 2;
    else if (funcChunk.contains("meth"+end))
      n = 1;
    else
      n = 0;

    return n;
  }
}


Atom makeCarbonChain(int n) {
  return makeCarbonChain(n, defaultLineColor);
}

Atom makeCarbonChain(int n, color lineColor) {
  Atom chain = new Atom(lineColor);
  if (n > 1)
    chain.addChild(makeCarbonChain(n-1, lineColor));
  return chain;
}