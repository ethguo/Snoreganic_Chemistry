class Molecule {

  void draw() {
    baseChain[0].drawChildren(new PVector(100, height/2), PI/6);
  }


  static Molecule fromName(String name) {
    numCarbons = findNumMainChain(name);
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

  Carbon makeCarbonChain(int n) {
    return makeCarbonChain(n, defaultLineColor);
  }

  int findNumMainChain(String name){
    int len = name.length();
    String func = findFunctionalGroup(name);
    
    int n = findNumCarbons(name, 0, len, func);
    
    return n;
  }


  String findFunctionalGroup(String cmpd){
    int len = cmpd.length();
    String last4 = cmpd.substring(len-4);
    
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


  int findNumCarbons(String cmpd, int i1, int i2, String func){
    int n;
    String funcChunk = cmpd.substring(i1,i2);
    
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