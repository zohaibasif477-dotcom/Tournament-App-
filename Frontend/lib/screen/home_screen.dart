import 'package:flutter/material.dart';
import '../services/api_service.dart'; // API calls کے لیے import

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List tournaments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTournaments();
  }

  void fetchTournaments() async {
    try {
      final data = await ApiService.getTournaments();
      setState(() {
        tournaments = data;
        isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tournaments"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: tournaments.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(tournaments[index]['name'] ?? 'No Name'),
                  subtitle: Text("Prize: ${tournaments[index]['prize'] ?? '-'}"),
                );
              },
            ),
    );
  }
}