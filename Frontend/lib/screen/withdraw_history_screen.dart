import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WithdrawHistoryScreen extends StatefulWidget {
  final String userId;

  const WithdrawHistoryScreen({super.key, required this.userId});

  @override
  State<WithdrawHistoryScreen> createState() =>
      _WithdrawHistoryScreenState();
}

class _WithdrawHistoryScreenState extends State<WithdrawHistoryScreen> {

  List history = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchHistory();
  }

  Future<void> fetchHistory() async {
    try {
      final res = await http.get(
        Uri.parse("http://localhost:5000/api/withdraw/history/${widget.userId}")
      );

      final data = jsonDecode(res.body);

      setState(() {
        history = data['data'];
        loading = false;
      });

    } catch (e) {
      loading = false;
    }
  }

  Color statusColor(String status) {
    switch (status) {
      case "approved":
        return Colors.green;
      case "rejected":
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text("Withdraw History"),
        backgroundColor: const Color(0xFF1E293B),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                final item = history[index];

                return Card(
                  color: const Color(0xFF1E293B),
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(
                      "Rs ${item['amount']}",
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      "${item['method']} • ${item['accountNumber']}",
                      style: const TextStyle(color: Colors.grey),
                    ),
                    trailing: Text(
                      item['status'],
                      style: TextStyle(
                        color: statusColor(item['status']),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}