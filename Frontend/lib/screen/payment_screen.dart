import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  final int fee;
  final int selectedSeat;

  const PaymentScreen({
    super.key,
    required this.fee,
    required this.selectedSeat,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int walletBalance = 100; // dummy balance

  bool loading = false;

  void joinTournament() {
    setState(() {
      loading = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        loading = false;
      });

      if (walletBalance >= widget.fee) {
        walletBalance -= widget.fee;

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Success"),
            content: const Text("You joined the tournament successfully"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context, true);
                },
                child: const Text("OK"),
              )
            ],
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => const AlertDialog(
            title: Text("Error"),
            content: Text("Insufficient Balance"),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "Selected Seat: ${widget.selectedSeat}",
              style: const TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 20),

            Text(
              "Entry Fee: Rs ${widget.fee}",
              style: const TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 20),

            Text(
              "Wallet Balance: Rs $walletBalance",
              style: const TextStyle(fontSize: 18),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loading ? null : joinTournament,
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Join Tournament"),
              ),
            )
          ],
        ),
      ),
    );
  }
}