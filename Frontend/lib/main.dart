import 'package:flutter/material.dart';
import 'service/api_service.dart'; // ✅ Correct ApiService import
import 'auth/signup_screen.dart';
import 'auth/login_screen.dart';

// ================= MAIN APP =================
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tournament App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),

      // ✅ Home screen start
      home: SignupScreen(),

      // ✅ Routes for navigation
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}

// ================= HOME SCREEN =================
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List tournaments = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchTournaments();
  }

  void fetchTournaments() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final data = await ApiService.getTournaments();

      setState(() {
        tournaments = data;
        isLoading = false;
      });
    } catch (e) {
      print("Error: $e");
      setState(() {
        errorMessage = "Failed to load tournaments";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tournaments"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchTournaments,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error, color: Colors.red, size: 50),
                      const SizedBox(height: 10),
                      Text(errorMessage!),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: fetchTournaments,
                        child: const Text("Retry"),
                      )
                    ],
                  ),
                )
              : tournaments.isEmpty
                  ? const Center(child: Text("No tournaments found"))
                  : ListView.builder(
                      itemCount: tournaments.length,
                      itemBuilder: (context, index) {
                        final tournament = tournaments[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          child: ListTile(
                            title: Text(
                              tournament['title'] ?? 'No Title',
                            ),
                            subtitle: Text(
                              "Game: ${tournament['gameName'] ?? 'N/A'}\n"
                              "Prize: ${tournament['prizePool'] ?? 0}",
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Players",
                                  style: TextStyle(fontSize: 12),
                                ),
                                Text(
                                  "${tournament['joinedPlayers'] ?? 0}/${tournament['maxPlayers'] ?? 0}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            onTap: () async {
                              bool success =
                                  await ApiService.joinTournament(
                                "user123",
                                tournament['_id'],
                              );

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(success
                                      ? "Joined Successfully"
                                      : "Join Failed"),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
    );
  }
}