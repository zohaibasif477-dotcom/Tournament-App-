import 'package:flutter/material.dart';
import 'package:my_app/screen/free_fire_screen.dart';
import 'profile_screen.dart';
import 'dart:async';
import '../service/api_service.dart';

// ================= HOME SCREEN =================

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int coins = 0;
  int selectedCardIndex = 0;
  TabController? _tabController;
  int _currentBottomIndex = 0;

  PageController _pageController = PageController();
  int _currentPage = 0;

  List<String> bannerImages = [
    "assets/banner1.jpg",
    "assets/banner2.jpg",
    "assets/banner3.jpg"
  ];

  List<String> tournamentModes = [
    "SOLO SURVIVAL",
    "SOLO PERKILL",
    "CLASH SQUAD",
    "BERMUDA"
  ];

  List<String> tournamentImages = [
    "assets/solo_survival.jpg",
    "assets/solo_perkill.jpg",
    "assets/clash_squad.jpg",
    "assets/bermuda.jpg"
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    // Auto banner slider
    Timer.periodic(Duration(seconds: 3), (timer) {
      if (_currentPage < bannerImages.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _pageController.dispose();
    super.dispose();
  }

  // ================= TOP BAR =================
  Widget buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          // LEFT SIDE: Logo + App Name
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.purple,
                child: Icon(Icons.gamepad, color: Colors.white),
              ),
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Welcome back",
                      style: TextStyle(color: Colors.white70, fontSize: 12)),
                  Text("Tournament Hub",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),

          // RIGHT SIDE: Notification Bell + Coins + Profile
          Row(
            children: [
              Icon(Icons.notifications_none, color: Colors.white),
              SizedBox(width: 16),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WalletPage(coins: coins)),
                  );
                },
                child: Row(
                  children: [
                    Icon(Icons.monetization_on, color: Colors.yellow),
                    Text("$coins", style: TextStyle(color: Colors.white))
                  ],
                ),
              ),
              SizedBox(width: 16),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProfileScreen(userId: "1"), // existing ProfileScreen use ho raha
                    ),
                  );
                },
                child: CircleAvatar(
                  backgroundColor: Colors.deepPurple,
                  child: Icon(Icons.person, color: Colors.white),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget buildBanner() {
    return Stack(
      children: [
        Container(
          height: 150,
          margin: EdgeInsets.symmetric(horizontal: 16),
          child: PageView.builder(
            controller: _pageController,
            itemCount: bannerImages.length,
            itemBuilder: (_, i) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  bannerImages[i],
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
        ),

        // LEFT ARROW
        Positioned(
          left: 20,
          top: 60,
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {
              _pageController.previousPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeIn);
            },
          ),
        ),

        // RIGHT ARROW
        Positioned(
          right: 20,
          top: 60,
          child: IconButton(
            icon: Icon(Icons.arrow_forward_ios, color: Colors.white),
            onPressed: () {
              _pageController.nextPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeIn);
            },
          ),
        ),
      ],
    );
  }

  // ================= UPDATED CARD =================
  Widget buildCard(int index) {
    return GestureDetector(
      onTap: () {
        // Card click -> FreeFireScreen with filter
        String selectedMode = tournamentModes[index];
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FreeFireTournamentsScreen(
              initialFilter: selectedMode, // New param
            ),
          ),
        );
      },
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: AssetImage(tournamentImages[index]),
            fit: BoxFit.cover,
          ),
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 6),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0x80000000),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12)),
            ),
            child: Text(
              tournamentModes[index],
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLiveSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Live Tournament",
            style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold)),
        SizedBox(height: 12),

        // LIVE BOX
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Color(0xFF660000),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Live",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF800000)),
                onPressed: () {},
                child: Text("Watch"),
              )
            ],
          ),
        ),

        SizedBox(height: 10),

        // REWARD BOX
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Color(0xFF556B2F),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Claim your Daily Reward",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  Text("Collect bonus reward",
                      style: TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF80FF00)),
                onPressed: () {},
                child: Text("Claim"),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget buildUpcomingTournament() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Upcoming Tournament",
            style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold)),
        SizedBox(height: 12),

        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color(0xFF2C003E),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Spring Championship",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              SizedBox(height: 6),
              Text("Prize: \$1000",
                  style: TextStyle(color: Colors.white70)),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF4B0082)),
                  onPressed: () {},
                  child: Text("Register Now"),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0D1117),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              SizedBox(height: 10),

              // 🔥 TOP BAR
              buildTopBar(),

              // 🔥 TOP BANNER
              buildBanner(),

              SizedBox(height: 16),

              // GRID
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: buildCard(0)),
                        SizedBox(width: 10),
                        Expanded(child: buildCard(1)),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: buildCard(2)),
                        SizedBox(width: 10),
                        Expanded(child: buildCard(3)),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: buildLiveSection(),
              ),

              SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: buildUpcomingTournament(),
              ),

              SizedBox(height: 100),
            ],
          ),
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF111827),
        selectedItemColor: Color(0xFF22C55E),
        unselectedItemColor: Colors.white70,
        currentIndex: _currentBottomIndex,
        onTap: (index) {
          setState(() {
            _currentBottomIndex = index;
          });

          if (index == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ProfileScreen(userId: "1")),
            );
          }
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.public), label: "Ranking"),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: "Team"),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: "Wallet"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

// ================= EXTRA PAGES =================

class WalletPage extends StatelessWidget {
  final int coins;
  WalletPage({required this.coins});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Wallet")),
      body: Center(child: Text("You have $coins coins")),
    );
  }
}