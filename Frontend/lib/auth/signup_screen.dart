import 'package:flutter/material.dart';
import '../service/api_service.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.purpleAccent, Colors.pinkAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Create Account",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Sign up to get started!",
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
              SizedBox(height: 40),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    buildTextField("Full Name", Icons.person, nameController),
                    SizedBox(height: 20),
                    buildTextField("Email", Icons.email, emailController),
                    SizedBox(height: 20),
                    buildTextField("Password", Icons.lock, passwordController, isPassword: true),
                    SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            print("🚀 Signup button pressed");
                            String name = nameController.text;
                            String email = emailController.text;
                            String password = passwordController.text;
                            print("📝 Input: name=$name, email=$email, password=$password");

                            final response = await ApiService.signup(name, email, password);
                            print("✅ Signup response: $response");

                            if (response['success'] == true) {
                              print("🚀 Signup successful, navigating to HomeScreen");
                              Navigator.pushReplacementNamed(context, '/home');
                            } else {
                              print("❌ Signup failed");
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Signup failed: ${response['message'] ?? 'Unknown error'}")),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                        ),
                        child: Text(
                          "Sign Up",
                          style: TextStyle(color: Colors.deepPurple, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account? ", style: TextStyle(color: Colors.white70)),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/login'),
                    child: Text("Login", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String hintText, IconData icon, TextEditingController controller, {bool isPassword = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      style: TextStyle(color: Colors.white),
      validator: (value) => value!.isEmpty ? 'This field cannot be empty' : null,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}