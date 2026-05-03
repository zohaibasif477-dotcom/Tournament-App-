import 'package:flutter/material.dart';
import 'withdraw_screen.dart';
import 'withdraw_history_screen.dart';
import 'deposit_history_screen.dart';
import 'deposit_screen.dart';

class WalletScreen extends StatelessWidget {
  final String userId;
  final int balance;

  const WalletScreen({
    super.key,
    required this.userId,
    required this.balance,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text(
          "My Wallet",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // 💰 Balance Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Total Coins",
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Rs $balance",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // 🔥 Buttons Grid
            Column(
              children: [

                // 🔼 Row 1 (Deposit + Withdraw)
                Row(
                  children: [
                    Expanded(
                      child: _walletButton(
                        context,
                        Icons.arrow_downward,
                        "Deposit",
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DepositScreen(userId: userId),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _walletButton(
                        context,
                        Icons.arrow_upward,
                        "Withdraw",
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => WithdrawScreen(userId: userId),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // 🔽 Row 2 (Deposit History + Withdraw History)
                Row(
                  children: [
                    Expanded(
                      child: _walletButton(
                        context,
                        Icons.history,
                        "Deposit History",
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  DepositHistoryScreen(userId: userId),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _walletButton(
                        context,
                        Icons.history_toggle_off,
                        "Withdraw History",
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  WithdrawHistoryScreen(userId: userId),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 🔥 Custom Button Widget
  Widget _walletButton(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.black),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}