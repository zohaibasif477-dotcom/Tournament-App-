import 'package:flutter/material.dart';
import 'service/api_service.dart';

class TournamentPage extends StatefulWidget {
  @override
  _TournamentPageState createState() => _TournamentPageState();
}

class _TournamentPageState extends State<TournamentPage> {
  List<dynamic> tournaments = [];
  bool _isLoading = false; // 🔄 Loading state
  String? _errorMessage; // ❌ Error handling

  @override
  void initState() {
    super.initState();
    fetchTournaments();
  }

  void fetchTournaments() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await ApiService.getTournaments();
      setState(() {
        tournaments = data;
      });
    } catch (e) {
      print("Error fetching tournaments: $e");
      setState(() {
        _errorMessage =
            "Failed to load tournaments. Check your internet connection or try again.";
      });
    } finally {
      setState(() {
        _isLoading = false; // ✅ Spinner stop
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tournaments')),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text("Loading tournaments..."),
                ],
              ),
            )
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error, color: Colors.red, size: 48),
                      const SizedBox(height: 8),
                      Text(
                        _errorMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: fetchTournaments,
                        child: const Text("Retry"),
                      ),
                    ],
                  ),
                )
              : tournaments.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.info_outline, size: 48),
                          SizedBox(height: 8),
                          Text(
                            "No tournaments found",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: tournaments.length,
                      itemBuilder: (context, index) {
                        final tournament = tournaments[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 12),
                          child: ListTile(
                            title:
                                Text(tournament['title'] ?? 'No Title Found'),
                            subtitle: Text(
                                'Prize: ${tournament['prizePool'] ?? 0}\nMax Players: ${tournament['maxPlayers'] ?? 0}'),
                            trailing: Text(
                                'Joined: ${tournament['joinedPlayers'] ?? 0}'),
                          ),
                        );
                      },
                    ),
    );
  }
}