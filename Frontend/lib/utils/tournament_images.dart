class TournamentImages {

  static String getImage(String type, String subType) {
    
    type = type.toLowerCase().trim();
    subType = subType.toLowerCase().trim();

    // 🎮 SOLO
    if (type == "solo") {
      return "assets/images/Tournament/solo_default.png";
    }

    // 🎯 SOLO PERKILL
    if (type == "solo perkill") {
      return "assets/images/Tournament/solo_perkill.png";
    }

    // ⚔️ CLASH SQUAD
    if (type == "clash squad") {
      if (subType == "1v1") {
        return "assets/images/Tournament/clash_1v1.png";
      } 
      else if (subType == "2v2") {
        return "assets/images/Tournament/clash_2v2.png";
      } 
      else if (subType == "4v4") {
        return "assets/images/Tournament/clash_4v4.png";
      }
      return "assets/images/Tournament/clash_default.png";
    }

    // 🏝️ BERMUDA (PRMODA)
    if (type == "bermuda") {
      if (subType == "duo") {
        return "assets/images/Tournament/bermuda_duo.png";
      } 
      else if (subType == "squad") {
        return "assets/images/Tournament/bermuda_squad.png";
      }
      return "assets/images/Tournament/solo_default.png";
    }

    // ❌ fallback
    return "assets/images/Tournament/solo_default.png";
  }
}