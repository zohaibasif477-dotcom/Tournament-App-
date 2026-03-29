import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  final String userId;

  ProfileScreen({required this.userId});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  int level = 1;
  int stars = 0;
  String username = "Loading...";
  String category = "Bronze";

  int matchesPlayed = 0;
  int wins = 0;
  int totalKills = 0;
  int coinWin = 0;

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  Future<void> fetchUser() async {
    final res = await http.get(
      Uri.parse("http://localhost:5000/api/user/${widget.userId}")
    );

    final data = jsonDecode(res.body);

    setState(() {
      username = data['username'];
      level = data['level'];
      stars = data['stars'];
      category = data['category'];

      matchesPlayed = data['totalMatches'] ?? 0;
      wins = data['matchesWon'] ?? 0;
      totalKills = data['totalKills'] ?? 0;
      coinWin = data['coinWin'] ?? 0;
    });
  }

  String getImage() {
    switch(category) {
      case "Bronze": return "assets/bronze.png";
      case "Silver": return "assets/silver.png";
      case "Gold": return "assets/gold.png";
      case "Platinum": return "assets/platinum.png";
      case "Diamond": return "assets/diamond.png";
      case "Heroic": return "assets/heroic.png";
      case "Master": return "assets/master.png";
      case "Grand Master": return "assets/grandmaster.png";
      default: return "assets/bronze.png";
    }
  }

  Widget starsUI() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        return Icon(
          i < stars ? Icons.star : Icons.star_border,
          color: Colors.amber,
        );
      }),
    );
  }

  // ✅ UPDATED OPTION ROW (BOX + COLORS + BOLD TEXT)
  Widget optionRow(String title, IconData icon, Color iconColor, VoidCallback onTap) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Color(0xFFF5F5F5), // box background
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold, // bold text
            fontSize: 15,
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.black, size: 16),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A0F24), // ✅ dark navy background
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 30),
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(getImage()),
            ),
            SizedBox(height: 10),
            Text(username, style: TextStyle(color: Colors.white, fontSize: 20)),
            Text("Level $level", style: TextStyle(color: Colors.grey)),
            Text(category, style: TextStyle(color: Colors.purple)),
            SizedBox(height: 10),
            starsUI(),
            SizedBox(height: 20),

            // Stats Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(children: [
                    Text("$matchesPlayed", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        Icon(Icons.sports_esports, color: Colors.white, size: 16),
                        SizedBox(width: 2),
                        Text("Matches", style: TextStyle(color: Colors.white, fontSize: 12))
                      ],
                    )
                  ]),
                  Column(children: [
                    Text("$wins", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        Icon(Icons.emoji_events, color: Colors.yellow, size: 16),
                        SizedBox(width: 2),
                        Text("Wins", style: TextStyle(color: Colors.white, fontSize: 12))
                      ],
                    )
                  ]),
                  Column(children: [
                    Text("$totalKills", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        Icon(Icons.cancel, color: Colors.red, size: 16),
                        SizedBox(width: 2),
                        Text("Kills", style: TextStyle(color: Colors.white, fontSize: 12))
                      ],
                    )
                  ]),
                  Column(children: [
                    Text("$coinWin", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        Icon(Icons.monetization_on, color: Colors.green, size: 16),
                        SizedBox(width: 2),
                        Text("Coins", style: TextStyle(color: Colors.white, fontSize: 12))
                      ],
                    )
                  ]),
                ],
              ),
            ),

            SizedBox(height: 20),

            // ✅ OPTIONS WITH COLORS
            optionRow("My Profile", Icons.person, Color(0xFFFF6B81), () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => DummyPage("My Profile")));
            }),
            optionRow("My Wallet", Icons.account_balance_wallet, Color(0xFF4CAF50), () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => DummyPage("My Wallet")));
            }),
            optionRow("Refer & Earn", Icons.card_giftcard, Color(0xFF2196F3), () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => DummyPage("Refer & Earn")));
            }),
            optionRow("Contact Us", Icons.support_agent, Color(0xFFFFD700), () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => DummyPage("Contact Us")));
            }),
            optionRow("FAQ", Icons.help, Color(0xFF9C27B0), () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => DummyPage("FAQ")));
            }),
            optionRow("About Us", Icons.info, Color(0xFFFF9800), () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => DummyPage("About Us")));
            }),
            optionRow("Privacy Policy", Icons.privacy_tip, Color(0xFF9C27B0), () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => DummyPage("Privacy Policy")));
            }),
            optionRow("Terms & Conditions", Icons.article, Color(0xFF2196F3), () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => DummyPage("Terms & Conditions")));
            }),
            optionRow("Logout", Icons.logout, Color(0xFFFF6B81), () {
              Navigator.pop(context);
            }),
          ],
        ),
      ),
    );
  }
}

// Dummy Page
class DummyPage extends StatelessWidget {
  final String title;
  DummyPage(this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text(title, style: TextStyle(fontSize: 24))),
    );
  }
}