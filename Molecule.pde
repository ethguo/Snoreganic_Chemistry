String[] alkPrefixes = {"eicos","nonadec","octadec","heptadec","hexadec","pentadec","tetradec","tridec","dodec","undec","dec","non","oct","hept","hex","pent","but","prop","meth","eth"};
int[] alkPrefixNums = {20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,1,2};

class Molecule {
  String name;
  int numCarbons;
  Atom[] baseChain;
  ArrayList<Integer> tempLocants;
  ArrayList<Atom> tempBranches;
  ArrayList<Integer> tempBondLocants;
  ArrayList<Integer> tempNumBonds;

  Molecule(String name) {
    this.name = name;
    this.baseChain = null;

    this.tempLocants = new ArrayList<Integer>();
    this.tempBranches = new ArrayList<Atom>();

    this.tempBondLocants = new ArrayList<Integer>();
    this.tempNumBonds = new ArrayList<Integer>();

    String[][] groups = matchAll(name, "(?:(\\d+(?:,\\d+)*)-)?(\\w+(?: acid)?)");
    for (int i = 0; i < groups.length; i++) {
      this.parseGroup(groups[i]);
    }
  }

  void draw() {
    this.baseChain[0].drawChildren(new PVector(width/2 -20*numCarbons, height/2), PI/6);
  }

  void addBranch(int index, Atom branch) {
    if (this.baseChain == null) {
      this.tempLocants.add(index);
      this.tempBranches.add(branch);
    }
    else {
      this.baseChain[index-1].addChild(branch);
    }
  }

  void setNumBonds(int index, int numBonds) {
    if (this.baseChain == null) {
      this.tempBondLocants.add(index);
      this.tempNumBonds.add(numBonds);
    }
    else {
      this.baseChain[index].setNumBonds(numBonds);
    }
  }

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

  void parseGroup(String[] group) {
    String groupName = group[2];

    int[] locants;
    if (group[1] == null) {
      locants = new int[] {1};
    }
    else {
      String[] locantStrings = group[1].split(",");
      locants = new int[locantStrings.length];
      for (int i = 0; i < locantStrings.length; i++)
        locants[i] = parseInt(locantStrings[i]);
    }
    addGroup(locants, groupName);
  }

  boolean addGroup(int[] locants, String groupName) {
    println("locants:");
    printArray(locants);
    println("groupName: " + groupName);
    // Returns true if successfully identified the branch, false otherwise.
    boolean success = false; //TODO: catch if success is still false after the loop
    int len = groupName.length();
    // try {
      if (endsWith(groupName, "ene")) {
        for (int i = 0; i < locants.length; i++)
          //-enes and -ynes should only come after the base chain number identifier, so this should be safe
          this.setNumBonds(locants[i], 2);
      }

      else if (endsWith(groupName, "yne")) {
        for (int i = 0; i < locants.length; i++)
          this.setNumBonds(locants[i], 3);
      }

      else if (endsWith(groupName, "amine")) {
        for (int i = 0; i < locants.length; i++)
          this.addBranch(locants[i], new Atom("N", 3, #035606));
      }

      else if (endsWith(groupName, "ol")) {
        for (int i = 0; i < locants.length; i++)
          this.addBranch(locants[i], new Atom("O", 2, #FF9900));
      }

      else if (endsWith(groupName, "one")) {
        for (int i = 0; i < locants.length; i++) {
          Atom carbonyl = new Atom("O", 2, #00FFFF);
          carbonyl.setNumBonds(2);
          this.addBranch(locants[i], carbonyl); //is it possible to replace "carbonyl" with "new Atom("O", 2, #00FFFF)setNumBonds(2)"
        }
      }

      else if (endsWith(groupName, "al")) {
        Atom carbonyl = new Atom("O", 2, #00FFFF);
        carbonyl.setNumBonds(2);
        this.addBranch(1, carbonyl);

        if(endsWith(groupName, "dial")) {
          Atom carbonyl2 = new Atom("O", 2, #00FFFF);
          carbonyl2.setNumBonds(2);
          this.addBranch(this.numCarbons, carbonyl2);
        }
      }

      else if (endsWith(groupName, "oic acid")) {
        Atom carbonyl = new Atom("O", 2, #00FFFF);
        carbonyl.setNumBonds(2);
        this.addBranch(1, carbonyl);
        this.addBranch(1, new Atom("O", 2, #00FFFF));

        if(endsWith(groupName, "dioic acid")) {
          Atom carbonyl2 = new Atom("O", 2, #00FFFF);
          carbonyl2.setNumBonds(2);
          this.addBranch(this.numCarbons, carbonyl2);
          this.addBranch(this.numCarbons, new Atom("O", 2, #00FFFF));
        }
      }

      else if (endsWith(groupName, "fluoro")) {
        for (int i = 0; i < locants.length; i++)
          this.addBranch(locants[i], new Atom("F", 1, #66FF00));
      }
      else if (endsWith(groupName, "chloro")) {
        for (int i = 0; i < locants.length; i++)
          this.addBranch(locants[i], new Atom("Cl", 1, #66FF00));
      }
      else if (endsWith(groupName, "bromo")) {
        for (int i = 0; i < locants.length; i++)
          this.addBranch(locants[i], new Atom("Br", 1, #66FF00));
      }
      else if (endsWith(groupName, "iodo")) {
        for (int i = 0; i < locants.length; i++)
          this.addBranch(locants[i], new Atom("I", 1, #66FF00));
      }

      else if (endsWith(groupName, "yl")) {
        // Alkyl branch, ex. "methyl"
        String alkPrefix = groupName.substring(0, len - 2);
        for (int i = 0; i < alkPrefixes.length; i++) {
          if (endsWith(alkPrefix, alkPrefixes[i])) {
            success = true;
            for (int j = 0; j < locants.length; j++) {
              Atom alkyl = makeCarbonChain(alkPrefixNums[i], #FF0000);
              this.addBranch(locants[j], alkyl);
            }
            break;
          }
        }
      }
      else if (endsWith(groupName, "oxy")) {
        // Alkoxy branch, ex. "methoxy"
        String alkPrefix = groupName.substring(0, len - 3);
        for (int i = 0; i < alkPrefixes.length; i++) {
          if (endsWith(alkPrefix, alkPrefixes[i])) {
            success = true;
            for (int j = 0; j < locants.length; j++) {
              Atom alkoxy = new Atom("O", 2, #9999FF);
              alkoxy.addChild(makeCarbonChain(alkPrefixNums[i], #9999FF));
              this.addBranch(locants[j], alkoxy);
            }
            break;
          }
        }
      }
      else {
        // Probably contains the base chain number
        if (endsWith(groupName, "ane")) {
          groupName = groupName.substring(0, len - 3);
        }
        if (endsWith(groupName, "an")) {
          groupName = groupName.substring(0, len - 2);
        }

        println("alkane!");
        println(groupName);

        for (int i = 0; i < alkPrefixes.length; i++) {
          String alkPrefix = alkPrefixes[i];
          // String prefixCandidate = groupName.substring(len - alkPrefix.length());
          if (endsWith(groupName, alkPrefix)) {
            // success = true;
            this.setBaseChain(alkPrefixNums[i]);

            // In a case like "2-methylhexane", we still need to parse the "2-methyl" as a branch.
            String branchName = groupName.substring(0, groupName.length() - alkPrefix.length());
            if (!branchName.equals(""))
              success = this.addGroup(locants, branchName);
            break;
          }
        }
      }
    // }
    // catch (RuntimeException e) {
    //   println(e.getMessage());
    // }
    return success;
  }
}

boolean endsWith(String s, String end) {
  return (s.length() >= end.length() &&
          s.substring(s.length() - end.length()).equals(end));
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