import 'package:flutter/material.dart';

class TournamentDetailScreen extends StatelessWidget {
  final String title;
  final String description;
  final int players;
  final int fee;
  final String time;

  const TournamentDetailScreen({
    super.key,
    required this.title,
    required this.description,
    required this.players,
    required this.fee,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ✅ FIXED APP BAR (PURPLE + WHITE TEXT)
      appBar: AppBar(
        backgroundColor: Colors.purple,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Tournament Details",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "Time: $time",
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),

            const SizedBox(height: 10),

            Text(
              "Players: $players",
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),

            const SizedBox(height: 10),

            Text(
              "Entry Fee: Rs $fee",
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),

            const SizedBox(height: 20),

            const Text(
              "Description",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              description,
              style: const TextStyle(
                fontSize: 15,
                height: 1.4,
                color: Colors.black,
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Back"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}