import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WithdrawScreen extends StatefulWidget {
  final String userId;

  const WithdrawScreen({super.key, required this.userId});

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController accountController = TextEditingController();

  String method = "JazzCash";
  bool isLoading = false;

  double userBalance = 500; // 🔥 demo balance (API se replace karna hoga)

  late AnimationController _controller;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  double get enteredAmount {
    return double.tryParse(amountController.text) ?? 0;
  }

  bool get isInsufficientBalance {
    return enteredAmount > userBalance || enteredAmount <= 0;
  }

  Future<void> submitWithdraw() async {
    final amount = amountController.text;
    final account = accountController.text;

    if (amount.isEmpty || account.isEmpty) {
      showSnack("All fields required");
      return;
    }

    if (isInsufficientBalance) {
      showSnack("Insufficient balance in your account");
      return;
    }

    setState(() => isLoading = true);

    try {
      final res = await http.post(
        Uri.parse("http://localhost:5000/api/withdraw/create"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "userId": widget.userId,
          "amount": int.parse(amount),
          "accountNumber": account,
          "method": method,
        }),
      );

      final data = jsonDecode(res.body);

      if (res.statusCode == 201) {
        showSnack("Withdraw Request Sent ✅");
        amountController.clear();
        accountController.clear();
      } else {
        showSnack(data['message'] ?? "Error");
      }
    } catch (e) {
      showSnack("Error: $e");
    }

    setState(() => isLoading = false);
  }

  void showSnack(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  Widget inputField(String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      onChanged: (_) => setState(() {}),
      style: const TextStyle(color: Colors.black),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget methodTile(String title) {
    final isSelected = method == title;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => method = title),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? Colors.black : Colors.white,
                  border: Border.all(color: Colors.black),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    amountController.dispose();
    accountController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final disableButton = isInsufficientBalance;

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.purple,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Withdraw",
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: FadeTransition(
        opacity: _fade,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Account Number FIRST
              inputField("Account Number", accountController),
              const SizedBox(height: 12),

              // Method
              Row(
                children: [
                  methodTile("JazzCash"),
                  methodTile("EasyPaisa"),
                ],
              ),

              const SizedBox(height: 12),

              // Amount
              inputField("Enter Amount", amountController),

              const SizedBox(height: 8),

              if (isInsufficientBalance && amountController.text.isNotEmpty)
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Insufficient balance in your account",
                    style: TextStyle(color: Colors.red),
                  ),
                ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (isLoading || disableButton)
                      ? null
                      : submitWithdraw,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        disableButton ? Colors.grey : Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Withdraw",
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}