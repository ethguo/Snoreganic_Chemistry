// These arrays store the IUPAC prefixes and their corresponding number of carbons.
// They are both necessary because "meth" is longer than but contains "eth", so we had to put it in this order for it to recognize "meth"s vs "eth"s.
String[] alkPrefixes = {"eicos","nonadec","octadec","heptadec","hexadec","pentadec","tetradec","tridec","dodec","undec","dec","non","oct","hept","hex","pent","but","prop","meth","eth"};
int[] alkPrefixNums = {20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,1,2};
// This array stores the cardinal prefixes (indicating how many of a branch there are, in ascending order.
String[] cardinalPrefixes = {"di","tri","tetra","penta","hexa","hepta","octa","nona","deca","undeca","dodeca","trideca","tetradeca","pentadeca","hexadeca","heptadeca","octadeca","nonadeca","eicosa"};

class Molecule {
  String name;
  int numCarbons;
  Atom[] baseChain;
  ArrayList<Integer> tempLocants;
  ArrayList<Atom> tempBranches;
  ArrayList<Integer> tempBondLocants;
  ArrayList<Integer> tempNumBonds;

  Molecule() {
    this.baseChain = null;

    // "temp" ArrayLists are used when the baseChain has not yet been initialized
    this.tempLocants = new ArrayList<Integer>();
    this.tempBranches = new ArrayList<Atom>();
    this.tempBondLocants = new ArrayList<Integer>();
    this.tempNumBonds = new ArrayList<Integer>();
  }

  // Calls drawRoot on the first Atom in the base chain (which will recursively draw every other Atom as well)
  void draw() {
    this.baseChain[0].drawRoot(this.numCarbons);
  }

  // Checks if the molecule was successfully created (if the baseChain was ever initialized)
  boolean isValid() {
    return (this.baseChain != null);
  }

  void addBranch(int index, Atom branch) {
    // If the basechain has not yet been initalized, store the information in the "temp" ArrayLists
    if (this.baseChain == null) {
      this.tempLocants.add(index);
      this.tempBranches.add(branch);
    }
    // Otherwise, just add the branch to the appropriate Atom in the base chain
    else {
      if (index == -1) // An index of -1 means the last carbon in the chain
        this.baseChain[this.numCarbons-1].addChild(branch);
      else
        this.baseChain[index-1].addChild(branch);
    }
  }

  void setNumBonds(int index, int numBonds) {
    // If the basechain has not yet been initalized, store the information in the "temp" ArrayLists
    if (this.baseChain == null) {
      this.tempBondLocants.add(index);
      this.tempNumBonds.add(numBonds);
    }
    // Otherwise, set the appropriate Atom in the base chain to a double or triple bond
    else {
      this.baseChain[index].setNumBonds(numBonds);
    }
  }

  // Initializes the base chain
  void setBaseChain(int numCarbons) {
    this.numCarbons = numCarbons;
    this.baseChain = new Atom[numCarbons];
    this.baseChain[numCarbons-1] = new Atom();

    for (int i = numCarbons-2; i >= 0; i--) {
      this.baseChain[i] = new Atom();
      this.baseChain[i].addChild(this.baseChain[i+1]);
    }

    // Add all the branches from the temp ArrayLists
    for (int i = 0; i < this.tempBranches.size(); i++)
      this.addBranch(this.tempLocants.get(i), this.tempBranches.get(i));

    for (int i = 0; i < this.tempNumBonds.size(); i++)
      this.setNumBonds(this.tempBondLocants.get(i), this.tempNumBonds.get(i));

    this.tempLocants = null;
    this.tempBranches = null;
    this.tempBondLocants = null;
    this.tempNumBonds = null;
  }

  //parses the locant+groupName groups matched by regex above; returns if successful or not
  boolean parseGroup(String[] group) {
    String groupName = group[2];

    int[] locants;
    if (group[1] == null) { //eg. octanol (no locant, assumed to be 1)
      locants = new int[] {1};
    }
    else {
      String[] locantStrings = group[1].split(",");
      locants = new int[locantStrings.length];
      for (int i = 0; i < locantStrings.length; i++) {
        locants[i] = parseInt(locantStrings[i]);
        if (locants[i] == 0)
          return false;
      }
    }

    boolean success = identifyGroup(locants, groupName);
    return success;
  }

  boolean identifyGroup(int[] locants, String groupName) {
    // In general, this function works from the end of the groupName, right-to-left, by checking the last few characters (using endsWith)
    // and then chopping off those characters (using trimEnding), and checking the new last few characters again, etc.
    // Returns true if successfully identified the branch, false otherwise.
    boolean success = false;
    try {
      success = this.identifyBranch(locants, groupName);

      if (success == false) {
        // If any functional groups match, remainder will contain the rest of the string
        // (minus the functional group suffix).
        String remainder = groupName;

        //identifies main functional group
        // Alkene
        if (endsWith(groupName, "ene")) {
          success = true;
          remainder = trimEnding(groupName, "ene");
          for (int i = 0; i < locants.length; i++)
            this.setNumBonds(locants[i], 2);
        }

        // Alkyne
        else if (endsWith(groupName, "yne")) {
          success = true;
          remainder = trimEnding(groupName, "yne");
          for (int i = 0; i < locants.length; i++)
            this.setNumBonds(locants[i], 3);
        }

        // Amine
        else if (endsWith(groupName, "amine") || endsWith(groupName, "amino")) {
          success = true;
          remainder = trimEnding(groupName, "amine");
          for (int i = 0; i < locants.length; i++)
            this.addBranch(locants[i], new Atom("N", 3, #035606));
        }

        // Alcohol
        else if (endsWith(groupName, "ol") || endsWith(groupName, "hydroxyl")) {
          success = true;
          remainder = trimEnding(groupName, "ol");
          for (int i = 0; i < locants.length; i++)
            this.addBranch(locants[i], new Atom("O", 2, #FF9900));
        }

        // Ketone
        else if (endsWith(groupName, "one") || endsWith(groupName, "oxo")) {
          success = true;
          remainder = trimEnding(groupName, "one");
          for (int i = 0; i < locants.length; i++) {
            Atom carbonyl = new Atom("O", 2, #0000FF);
            carbonyl.setNumBonds(2);
            this.addBranch(locants[i], carbonyl);
          }
        }

        // Aldehyde
        else if (endsWith(groupName, "al") || endsWith(groupName, "formyl")) {
          success = true;
          remainder = trimEnding(groupName, "al");
          Atom carbonyl = new Atom("O", 2, #0080FF);
          carbonyl.setNumBonds(2);
          this.addBranch(1, carbonyl);

          // -dial, diformyl
          if(endsWith(remainder, "di")) {
            remainder = trimEnding(remainder, "di");
            Atom carbonyl2 = new Atom("O", 2, #0080FF);
            carbonyl2.setNumBonds(2);
            this.addBranch(-1, carbonyl2);
          }
        }

        // Carboxylic acid
        else if (endsWith(groupName, "oic acid")) {
          success = true;
          remainder = trimEnding(groupName, "oic acid");
          Atom carbonyl = new Atom("O", 2, #00FFFF);
          carbonyl.setNumBonds(2);
          this.addBranch(1, carbonyl);
          this.addBranch(1, new Atom("O", 2, #00FFFF));

          // -dioic acid
          if(endsWith(remainder, "di")) {
            remainder = trimEnding(remainder, "di");
            Atom carbonyl2 = new Atom("O", 2, #00FFFF);
            carbonyl2.setNumBonds(2);
            this.addBranch(-1, carbonyl2);
            this.addBranch(-1, new Atom("O", 2, #00FFFF));
          }
        }

        // Trim off the optional cardinal prefix, ex. the "di" in "hexandiol"
        if (locants.length > 1) {
          String cardinalPrefix = cardinalPrefixes[locants.length - 2];
          if (endsWith(remainder, cardinalPrefix))
            remainder = trimEnding(remainder, cardinalPrefix);
        }

        // "hexane" or "hexan" -> "hex"
        if (endsWith(remainder, "ane")) {
          remainder = trimEnding(remainder, "ane");
        }
        if (endsWith(remainder, "an")) {
          remainder = trimEnding(remainder, "an");
        }

        if (remainder != null) {
          // This group might contain the prefix identifying the base chain
          for (int i = 0; i < alkPrefixes.length; i++) {
            String alkPrefix = alkPrefixes[i];
            if (endsWith(remainder, alkPrefix)) {
              success = true;
              this.setBaseChain(alkPrefixNums[i]);

              // In a case like "2-methylhexane", we still need to parse the "2-methyl" as a branch.
              String branchName = remainder.substring(0, remainder.length() - alkPrefix.length());
              if (!branchName.equals(""))
                success = this.identifyGroup(locants, branchName);
              break;
            }
          }
        }
      }
    }
    catch (RuntimeException e) {
      println(e.getMessage());
      return false;
    }
    return success;
  }

  boolean identifyBranch(int[] locants, String branchName) {
    boolean success = false;

    // Alkyl halide branches (Halogens)
    if (endsWith(branchName, "fluoro")) {
      success = true;
      for (int i = 0; i < locants.length; i++)
        this.addBranch(locants[i], new Atom("F", 1, #66FF00));
    }
    else if (endsWith(branchName, "chloro")) {
      success = true;
      for (int i = 0; i < locants.length; i++)
        this.addBranch(locants[i], new Atom("Cl", 1, #66FF00));
    }
    else if (endsWith(branchName, "bromo")) {
      success = true;
      for (int i = 0; i < locants.length; i++)
        this.addBranch(locants[i], new Atom("Br", 1, #66FF00));
    }
    else if (endsWith(branchName, "iodo")) {
      success = true;
      for (int i = 0; i < locants.length; i++)
        this.addBranch(locants[i], new Atom("I", 1, #66FF00));
    }

    // Alkyl branch, ex. "methyl"
    else if (endsWith(branchName, "yl")) {
      String alkPrefix = trimEnding(branchName, "yl");
      for (int i = 0; i < alkPrefixes.length; i++) {
        if (endsWith(alkPrefix, alkPrefixes[i])) {
          success = true;
          String remainder = trimEnding(alkPrefix, alkPrefixes[i]);
          boolean isCyclic = endsWith(remainder, "cyclo");
          for (int j = 0; j < locants.length; j++) {
            Atom alkyl;
            if (isCyclic)
              alkyl = makeCyclic(alkPrefixNums[i], #FF0000);
            else
              alkyl = makeCarbonChain(alkPrefixNums[i], #FF0000);
            this.addBranch(locants[j], alkyl);
          }
          break;
        }
      }
    }

    // Alkoxy branch, ex. "methoxy"
    else if (endsWith(branchName, "oxy")) {
      String alkPrefix = trimEnding(branchName, "oxy");
      for (int i = 0; i < alkPrefixes.length; i++) {
        if (endsWith(alkPrefix, alkPrefixes[i])) {
          success = true;
          String remainder = trimEnding(alkPrefix, alkPrefixes[i]);
          boolean isCyclic = endsWith(remainder, "cyclo");
          for (int j = 0; j < locants.length; j++) {
            Atom alkoxy = new Atom("O", 2, #9933FF);
            Atom alkyl;
            if (isCyclic)
              alkyl = makeCyclic(alkPrefixNums[i], #9933FF);
            else
              alkyl = makeCarbonChain(alkPrefixNums[i], #9933FF);
            alkoxy.addChild(alkyl);
            this.addBranch(locants[j], alkoxy);
          }
          break;
        }
      }
    }
    return success;
  }
}

// Returns true if the last few characters matches the given end string
boolean endsWith(String s, String end) {
  return (s.length() >= end.length()
        && s.substring(s.length() - end.length()).equals(end));
}

// Returns the string with the given end string "chopped off"
String trimEnding(String s, String end) {
  return s.substring(0, s.length() - end.length());
}

// Call the method below, with the default color
Atom makeCarbonChain(int numCarbons) {
  return makeCarbonChain(numCarbons, defaultLineColor);
}

// Returns an n-carbon chain
Atom makeCarbonChain(int numCarbons, color lineColor) {
  Atom chain = new Atom(lineColor);
  if (numCarbons > 1)
    chain.addChild(makeCarbonChain(numCarbons-1, lineColor));
  return chain;
}

// Call the method below, with the default color
CyclicAtom makeCyclic(int numCarbons) {
  return makeCyclic(numCarbons, defaultLineColor);
}

// Returns an n-carbon cyclic chain
CyclicAtom makeCyclic(int numCarbons, color lineColor) {
  CyclicAtom chain = new CyclicAtom(numCarbons, lineColor);
  for (int i = 1; i < numCarbons; i++) {
    CyclicAtom newChain = new CyclicAtom(numCarbons, lineColor);
    newChain.addChild(chain);
    chain = newChain;
  }
  return chain;
}