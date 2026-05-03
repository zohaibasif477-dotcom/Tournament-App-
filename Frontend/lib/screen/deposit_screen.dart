import 'dart:io';
import 'package:flutter/material.dart';
import '../service/image_picker_service.dart';

class DepositScreen extends StatefulWidget {
  final String userId;

  const DepositScreen({super.key, required this.userId});

  @override
  State<DepositScreen> createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController amountController = TextEditingController();
  final ImagePickerService pickerService = ImagePickerService();

  File? selectedImage;
  bool isLoading = false;

  late AnimationController _controller;
  late Animation<double> _fadeAnim;

  final List<int> amounts = [100, 200, 500, 1000];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();
  }

  Future<void> pickImage() async {
    final image = await pickerService.pickImageFromGallery();
    if (image != null) {
      setState(() {
        selectedImage = image;
      });
    }
  }

  void submitDeposit() async {
    if (amountController.text.isEmpty || selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Amount and screenshot required")),
      );
      return;
    }

    setState(() => isLoading = true);

    await Future.delayed(const Duration(seconds: 2));

    setState(() => isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Deposit request submitted")),
    );

    amountController.clear();
    setState(() {
      selectedImage = null;
    });
  }

  @override
  void dispose() {
    amountController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Widget infoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("EasyPaisa: 03274453465",
              style: TextStyle(color: Colors.black)),
          SizedBox(height: 8),
          Text("JazzCash: 03274453465",
              style: TextStyle(color: Colors.black)),
          SizedBox(height: 8),
          Text("Name: Muhammad Zohaib",
              style: TextStyle(color: Colors.black)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text("Deposit"),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),

      body: FadeTransition(
        opacity: _fadeAnim,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [

              // ✅ REMOVED OPTIONS + ADDED INFO CARD
              infoCard(),

              const SizedBox(height: 20),

              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: "Enter Amount",
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Wrap(
                spacing: 10,
                children: amounts.map((e) {
                  return ChoiceChip(
                    label: Text("$e"),
                    selected: amountController.text == "$e",
                    onSelected: (_) {
                      setState(() {
                        amountController.text = "$e";
                      });
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),

              GestureDetector(
                onTap: pickImage,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: selectedImage == null
                      ? const Center(
                          child: Text(
                            "Tap to upload screenshot",
                            style: TextStyle(color: Colors.black54),
                          ),
                        )
                      : Image.file(selectedImage!, fit: BoxFit.cover),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : submitDeposit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Submit Deposit"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}