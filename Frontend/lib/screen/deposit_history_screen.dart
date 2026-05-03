import 'package:flutter/material.dart';

class DepositHistoryScreen extends StatelessWidget {
  final String userId;

  const DepositHistoryScreen({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> history = [
      {
        "amount": 500,
        "status": "Pending",
        "date": "2026-04-28"
      },
      {
        "amount": 200,
        "status": "Approved",
        "date": "2026-04-27"
      },
      {
        "amount": 100,
        "status": "Rejected",
        "date": "2026-04-26"
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xff0f172a),
      appBar: AppBar(
        title: const Text("Deposit History"),
        backgroundColor: const Color(0xff1e293b),
      ),
      body: ListView.builder(
        itemCount: history.length,
        itemBuilder: (context, index) {
          final item = history[index];

          Color statusColor;
          if (item["status"] == "Approved") {
            statusColor = Colors.green;
          } else if (item["status"] == "Rejected") {
            statusColor = Colors.red;
          } else {
            statusColor = Colors.orange;
          }

          return Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Rs ${item['amount']}",
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    Text(
                      item['date'],
                      style: const TextStyle(color: Colors.white54),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    item['status'],
                    style: const TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}