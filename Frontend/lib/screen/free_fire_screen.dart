import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: FreeFireTournamentsScreen(initialFilter: ""), // optional initial filter
  ));
}

class FreeFireTournamentsScreen extends StatefulWidget {
  final String initialFilter;
  final String initialSubFilter;

  FreeFireTournamentsScreen({this.initialFilter = "", this.initialSubFilter = ""});

  @override
  _FreeFireTournamentsScreenState createState() =>
      _FreeFireTournamentsScreenState();
}

class _FreeFireTournamentsScreenState
    extends State<FreeFireTournamentsScreen> {
  late String selectedMain;
  late String selectedSub;

  List<Map<String, dynamic>> tournaments = [
    {
      "name": "Solo Survival Challenge",
      "category": "Survival",
      "type": "Solo",
      "subType": "",
      "entryFee": "50",
      "prize": "1000",
      "players": 50,
      "date": "25 Mar 2026",
      "image":
          "https://wallpapercave.com/wp/wp5128415.jpg",
    },
    {
      "name": "Solo Perkill Battle",
      "category": "Perkill",
      "type": "Solo Perkill",
      "subType": "",
      "entryFee": "60",
      "prize": "1200",
      "players": 45,
      "date": "26 Mar 2026",
      "image":
          "https://wallpapercave.com/wp/wp5128416.jpg",
    },
    {
      "name": "Clash Squad Masters",
      "category": "Clash Squad",
      "type": "Clash Squad",
      "subType": "2v2",
      "entryFee": "100",
      "prize": "2000",
      "players": 40,
      "date": "27 Mar 2026",
      "image":
          "https://wallpapercave.com/wp/wp7417813.jpg",
    },
    {
      "name": "Bermuda Duo Fight",
      "category": "Bermuda",
      "type": "Bermuda",
      "subType": "DUO",
      "entryFee": "70",
      "prize": "1500",
      "players": 60,
      "date": "28 Mar 2026",
      "image":
          "https://wallpapercave.com/wp/wp7417816.jpg",
    },
  ];

  List<Map<String, dynamic>> get filtered {
    return tournaments.where((t) {
      if (selectedMain.isEmpty) return true;
      if (selectedSub.isEmpty) {
        return t["type"] == selectedMain;
      }
      return t["subType"] == selectedSub;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    selectedMain = widget.initialFilter;
    selectedSub = widget.initialSubFilter;
  }

  // 🔥 CATEGORY BUTTON
  Widget buildFilterButton(String text, bool selected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (selectedMain == text) {
            selectedMain = "";
            selectedSub = "";
          } else {
            selectedMain = text;
            selectedSub = "";
          }
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        margin: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          gradient: selected
              ? LinearGradient(
                  colors: [Color(0xFF7C3AED), Color(0xFF2E2E3A)])
              : null,
          color: selected ? null : Color(0xFF2E2E3A),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(text,
            style: TextStyle(
              color: selected ? Colors.white : Color(0xFF9CA3AF),
              fontWeight: FontWeight.w500,
            )),
      ),
    );
  }

  // 🔥 SUB FILTER
  Widget buildSubFilter(String text) {
    bool selected = selectedSub == text;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedSub = selected ? "" : text;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        margin: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: selected ? Color(0xFF00FFE5) : Color(0xFF121827),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(text,
            style: TextStyle(color: Colors.white)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFF0A0F24),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Free Fire Tournaments",
                      style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                ),

                SizedBox(height: 15),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      buildFilterButton("Solo", selectedMain == "Solo"),
                      buildFilterButton(
                          "Solo Perkill", selectedMain == "Solo Perkill"),
                      buildFilterButton(
                          "Clash Squad", selectedMain == "Clash Squad"),
                      buildFilterButton(
                          "Bermuda", selectedMain == "Bermuda"),
                    ],
                  ),
                ),

                SizedBox(height: 10),

                if (selectedMain == "Clash Squad")
                  Row(
                    children: [
                      buildSubFilter("1v1"),
                      buildSubFilter("2v2"),
                      buildSubFilter("4v4"),
                    ],
                  ),

                if (selectedMain == "Bermuda")
                  Row(
                    children: [
                      buildSubFilter("DUO"),
                      buildSubFilter("SQUAD"),
                    ],
                  ),

                SizedBox(height: 15),

                Expanded(
                  child: ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final t = filtered[index];

                      return Container(
                        margin: EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: Color(0xFF111827),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: Colors.white.withOpacity(0.08)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.6),
                              blurRadius: 12,
                            )
                          ],
                        ),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20)),
                              child: Image.network(
                                t["image"],
                                height: 150,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),

                            Padding(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(t["category"],
                                          style: TextStyle(
                                              color: Color(0xFFFFFFFF),
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        children: [
                                          Icon(Icons.emoji_events,
                                              color: Color(0xFFFFD700),
                                              size: 18),
                                          SizedBox(width: 5),
                                          Text("Rs ${t["prize"]}",
                                              style: TextStyle(
                                                  color: Color(0xFF00FFE5))),
                                        ],
                                      )
                                    ],
                                  ),

                                  SizedBox(height: 10),

                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.monetization_on,
                                              color: Color(0xFFFFD700),
                                              size: 18),
                                          SizedBox(width: 5),
                                          Text("Rs ${t["entryFee"]}",
                                              style: TextStyle(
                                                  color: Color(0xFF9CA3AF))),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Icon(Icons.people,
                                              color: Color(0xFF00FFE5),
                                              size: 18),
                                          SizedBox(width: 5),
                                          Text("${t["players"]} Players",
                                              style: TextStyle(
                                                  color: Color(0xFF9CA3AF))),
                                        ],
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 8),

                                  Row(
                                    children: [
                                      Icon(Icons.access_time,
                                          color: Color(0xFF6C7293),
                                          size: 18),
                                      SizedBox(width: 5),
                                      Text(t["date"],
                                          style: TextStyle(
                                              color: Color(0xFF6C7293))),
                                    ],
                                  ),

                                  SizedBox(height: 15),

                                  Column(
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Color(0xFF3B82F6),
                                          minimumSize:
                                              Size(double.infinity, 45),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      16)),
                                        ),
                                        child: Text("Tournament Details"),
                                      ),

                                      SizedBox(height: 10),

                                      Container(
                                        width: double.infinity,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Color(0xFF7C3AED),
                                              Color(0xFF7C3AED)
                                            ],
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(18),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color(0xFF7C3AED)
                                                  .withOpacity(0.5),
                                              blurRadius: 15,
                                            )
                                          ],
                                        ),
                                        child: ElevatedButton(
                                          onPressed: () {},
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Colors.transparent,
                                            shadowColor:
                                                Colors.transparent,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        18)),
                                          ),
                                          child:
                                              Text("Join Tournament"),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}