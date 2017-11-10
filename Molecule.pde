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
    activateFunctionalGroup();
    
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

  void activateFunctionalGroup() {
    String funcGroupRegex = "-?(?:(\d+(?:,\d+)*)-)?(\w+(?: acid)?)$";
    String[] m1 = match(this.name, funcGroupRegex);
    while (m1 != null) {
      String[] locants = m1[1].split(",");

      if (m1[2].contains("ane"))
        {}  
        
      else if (m1[2].contains("ene")){
        for (int i=0; i<locants.length;i++)
          this.baseChain[parseInt(locants[i])].setNumBonds(2);        
      }
      
      else if (m1[2].contains("yne")){
        for (int i=0; i<locants.length;i++)
          this.baseChain[parseInt(locants[i])].setNumBonds(3);        
      }
          
      else if (m1[2].contains("ol")){
        for (int i=0; i<locants.length;i++)
          this.addBranch(parseInt(locants[i]), new Atom("O", 2, #FF9900));       
      }
        
      else if (m1[2].contains("al")){
        Atom carbonyl = new Atom("O", 2, #00FFFF);
        carbonyl.setNumBonds(2);
        this.addBranch(1, carbonyl);
        
        if(m1[2].contains("dial")){
          Atom carbonyl2 = new Atom("O", 2, #00FFFF);
          carbonyl2.setNumBonds(2);
          this.addBranch(this.numCarbons, carbonyl2);
        }      
      }
        
      else if (m1[2].contains("one")){
        for (int i=0; i<locants.length;i++){
          Atom carbonyl = new Atom("O", 2, #00FFFF);
          carbonyl.setNumBonds(2);
          this.addBranch(parseInt(locants[i]), carbonyl); //is it possible to replace "carbonyl" with "new Atom("O", 2, #00FFFF)setNumBonds(2)"
        }    
      }
      
      else if (m1[2].contains("oic acid")){
        Atom carbonyl = new Atom("O", 2, #00FFFF);
        carbonyl.setNumBonds(2);
        this.addBranch(1, carbonyl);
        this.addBranch(1, new Atom("O", 2, #00FFFF));
        
        if(m1[2].contains("dioic acid")){
          Atom carbonyl2 = new Atom("O", 2, #00FFFF);
          carbonyl2.setNumBonds(2);
          this.addBranch(this.numCarbons, carbonyl2);
          this.addBranch(this.numCarbons, new Atom("O", 2, #00FFFF));
        }  
      }
              
      else {}

      this.name = this.name.substring(0, this.name.length() - m1[0].length());
      m1 = match(this.name, funcGroupRegex);
    }
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

    if (funcChunk.contains("eicos"))
      n = 20;
    else if (funcChunk.contains("nonadec"))
      n = 19;
    else if (funcChunk.contains("octadec"))
      n = 18;
    else if (funcChunk.contains("heptadec"))
      n = 17;
    else if (funcChunk.contains("hexadec"))
      n = 16;
    else if (funcChunk.contains("pentadec"))
      n = 15;
    else if (funcChunk.contains("tetradec"))
      n = 14;
    else if (funcChunk.contains("tridec"))
      n = 13;
    else if (funcChunk.contains("dodec"))
      n = 12;
    else if (funcChunk.contains("undec"))
      n = 11;
    else if (funcChunk.contains("dec"))
      n = 10;
    else if (funcChunk.contains("non"))
      n = 9;
    else if (funcChunk.contains("oct"))
      n = 8;
    else if (funcChunk.contains("hept"))
      n = 7;
    else if (funcChunk.contains("hex"))
      n = 6;
    else if (funcChunk.contains("pent"))
      n = 5;
    else if (funcChunk.contains("but"))
      n = 4;
    else if (funcChunk.contains("prop"))
      n = 3;
    else if (funcChunk.contains("eth"))
      n = 2;
    else if (funcChunk.contains("meth"))
      n = 1;
    else
      n = 0;

    return n;
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
}