import 'package:flutter/material.dart';

class TournamentCodeScreen extends StatelessWidget {
  final String tournamentName;
  final String code;
  final bool isCodeAvailable;

  const TournamentCodeScreen({
    super.key,
    required this.tournamentName,
    required this.code,
    this.isCodeAvailable = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tournament Code"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.lock_open,
              size: 90,
              color: Colors.blue,
            ),

            const SizedBox(height: 20),

            Text(
              tournamentName,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 30),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: isCodeAvailable
                  ? Text(
                      code,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    )
                  : const Text(
                      "Code will be available soon...\nWait for admin update",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
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