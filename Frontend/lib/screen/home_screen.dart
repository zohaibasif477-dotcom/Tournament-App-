import 'package:flutter/material.dart';
import 'package:my_app/screen/free_fire_screen.dart';
import 'profile_screen.dart';
import 'dart:async';
import '../service/api_service.dart';
import 'wallet_screen.dart';

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

  // ✅ FIX 1: MISSING VARIABLES ADDED
  String userId = "1";
  int points = 0;
  Timer? _bannerTimer;

  List<String> bannerImages = [
    "assets/images/banners/banner(1).png",
    "assets/images/banners/banner(2).png",
  ];

  List<String> tournamentModes = [
    "SOLO SURVIVAL",
    "SOLO PERKILL",
    "CLASH SQUAD",
    "BERMUDA"
  ];

  List<String> tournamentImages = [
    "assets/images/options/solo_survival.png",
    "assets/images/options/solo_perkill.png",
    "assets/images/options/clash_squad.png",
    "assets/images/options/bermuda.png",
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    // ✅ FIX 2: TIMER SAFE HANDLING
    _bannerTimer = Timer.periodic(Duration(seconds: 3), (timer) {
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

    // ✅ FIX 3: TIMER CANCEL ADDED (MEMORY LEAK FIX)
    _bannerTimer?.cancel();

    super.dispose();
  }

  // ================= TOP BAR =================
  Widget buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

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
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),

          Row(
            children: [
              Icon(Icons.notifications_none, color: Colors.white),
              SizedBox(width: 16),

              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WalletScreen(
                        userId: userId,
                        balance: points,
                      ),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Icon(Icons.monetization_on, color: Colors.yellow),
                    Text("$coins",
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),

              SizedBox(width: 16),

              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ProfileScreen(userId: userId),
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
          height: MediaQuery.of(context).size.width > 800
          ? 300
          : MediaQuery.of(context).size.height * 0.22,      
          margin: EdgeInsets.symmetric(horizontal: 16),
          width: MediaQuery.of(context).size.width > 600
              ? 600
              : double.infinity,          
          child: PageView.builder(
            controller: _pageController,
            itemCount: bannerImages.length,
            itemBuilder: (_, i) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  bannerImages[i],
                  fit: BoxFit.contain,
                ),
              );
            },
          ),
        ),

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

  Widget buildCard(int index) {
    return GestureDetector(
      onTap: () {
        String selectedMode = tournamentModes[index];
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FreeFireTournamentsScreen(
              initialFilter: selectedMode,
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
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Text(
              tournamentModes[index],
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            backgroundColor: Color(0xFF0D1117),

      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 10),
                  buildTopBar(),
                  buildBanner(),

                  SizedBox(height: 16),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        GridView.builder(
                          shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: 4,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: MediaQuery.of(context).size.width > 1000
                                  ? 4
                                  : MediaQuery.of(context).size.width > 600
                                      ? 2
                                      : 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 1.2,
                            ),
                            itemBuilder: (context, index) {
                              return buildCard(index);
                      },
                    ),

                    SizedBox(height: 10),

                    
                    ],
                  ),
                ),

                SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    ),
    
    bottomNavigationBar: BottomNavigationBar(
  backgroundColor: Color(0xFF111827),
  selectedItemColor: Color(0xFF22C55E),
  unselectedItemColor: Colors.white70,
  currentIndex: _currentBottomIndex,

  onTap: (index) {
    if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => WalletScreen(
            userId: userId,
            balance: points,
          ),
        ),
      );
      return;
    }

    if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProfileScreen(userId: userId),
        ),
      );
      return;
    }

    setState(() {
      _currentBottomIndex = index;
    });
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