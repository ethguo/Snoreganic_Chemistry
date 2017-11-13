//prefixes and corresponding numerical values
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

  //constructor
  Molecule(String name) {
    this.name = name;
    this.baseChain = null;

    //"temp-" arrayLists are used when the baseChain has not yet been initialized
    this.tempLocants = new ArrayList<Integer>();
    this.tempBranches = new ArrayList<Atom>();

    this.tempBondLocants = new ArrayList<Integer>();
    this.tempNumBonds = new ArrayList<Integer>();

    //regular expression describing a search pattern for locant+groupName groups
    String[][] groups = matchAll(name, "(?:(\\d+(?:,\\d+)*)-)?(\\w+(?: acid)?)");
    for (int i = 0; i < groups.length; i++) {
      this.parseGroup(groups[i]);
    }
  }

  //draws molecule in centre of screen
  void draw() {
    this.baseChain[0].drawChildren(new PVector(width/2 -20*numCarbons, height/2), PI/6);
  }

  //immediately adds a branch if baseChain has been initialized, or stores info to be added later
  void addBranch(int index, Atom branch) {
    if (this.baseChain == null) { 
      this.tempLocants.add(index);
      this.tempBranches.add(branch);
    }
    else {
      this.baseChain[index-1].addChild(branch);
    }
  }

  //immediately add double or triple bond if baseChain exists; else store for later
  void setNumBonds(int index, int numBonds) {
    if (this.baseChain == null) {
      this.tempBondLocants.add(index);
      this.tempNumBonds.add(numBonds);
    }
    else {
      this.baseChain[index].setNumBonds(numBonds);
    }
  }

  //initializes the base chain
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
      addBranch(this.tempLocants.get(i), this.tempBranches.get(i));

    this.tempLocants = null;
    this.tempBranches = null;
  }
  
  //parses the locant+groupName groups matched by regex above
  void parseGroup(String[] group) {
    String groupName = group[2];
    int[] locants;
    if (group[1] == null) { //eg. octanol (no locant, assumed to be 1)
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

  // Returns true if successfully identified the branch, false otherwise.
  boolean addGroup(int[] locants, String groupName) {
    println("locants:");
    printArray(locants);
    println("groupName: " + groupName);
    boolean success = false; //TODO: catch if success is still false after the loop
    int len = groupName.length();
    // try {
      //identifies main functional group
      if (endsWith(groupName, "ene")) { //alkene
        for (int i=0; i<locants.length;i++)
          //-enes and -ynes should only come after the base chain number identifier, so this should be safe
          this.baseChain[locants[i]].setNumBonds(2);
      }

      else if (endsWith(groupName, "yne")) { //alkyne
        for (int i=0; i<locants.length;i++)
          this.baseChain[locants[i]].setNumBonds(3);
      }

      else if (endsWith(groupName, "amine")) { //amine
        for (int i=0; i<locants.length; i++)
          this.addBranch(locants[i], new Atom("N", 3, #035606));
      }

      else if (endsWith(groupName, "ol")) { //alcohol
        for (int i=0; i<locants.length;i++)
          this.addBranch(locants[i], new Atom("O", 2, #FF9900));
      }

      else if (endsWith(groupName, "one")) { //ketone
        for (int i=0; i<locants.length;i++) {
          Atom carbonyl = new Atom("O", 2, #00FFFF);
          carbonyl.setNumBonds(2);
          this.addBranch(locants[i], carbonyl); //is it possible to replace "carbonyl" with "new Atom("O", 2, #00FFFF)setNumBonds(2)"
        }
      }

      else if (endsWith(groupName, "al")) { //aldehyde
        Atom carbonyl = new Atom("O", 2, #00FFFF);
        carbonyl.setNumBonds(2);
        this.addBranch(1, carbonyl);

        if(endsWith(groupName, "dial")) { //di-aldehyde
          Atom carbonyl2 = new Atom("O", 2, #00FFFF);
          carbonyl2.setNumBonds(2);
          this.addBranch(this.numCarbons, carbonyl2);
        }
      }

      else if (endsWith(groupName, "oic acid")) { //carboxylic acid
        Atom carbonyl = new Atom("O", 2, #00FFFF);
        carbonyl.setNumBonds(2);
        this.addBranch(1, carbonyl);
        this.addBranch(1, new Atom("O", 2, #00FFFF));

        if(endsWith(groupName, "dioic acid")) { //di-carboxylic acid
          Atom carbonyl2 = new Atom("O", 2, #00FFFF);
          carbonyl2.setNumBonds(2);
          this.addBranch(this.numCarbons, carbonyl2);
          this.addBranch(this.numCarbons, new Atom("O", 2, #00FFFF));
        }
      }

      //TODO: Halogens

      // identifies branch groups
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
        // Likely contains the base chain number
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

//if no line colour specified, use default
Atom makeCarbonChain(int n) {
  return makeCarbonChain(n, defaultLineColor);
}

Atom makeCarbonChain(int n, color lineColor) {
  Atom chain = new Atom(lineColor);
  if (n > 1)
    chain.addChild(makeCarbonChain(n-1, lineColor));
  return chain;
}