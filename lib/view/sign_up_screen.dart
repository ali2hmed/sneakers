import 'package:flutter/material.dart';
import '../db_helper.dart';

class SneakersSignUpScreen extends StatelessWidget {
  SneakersSignUpScreen({Key? key}) : super(key: key);

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final DBHelper _dbHelper = DBHelper();

  void _registerUser(BuildContext context) async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All fields are required')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    final emailExists = await _dbHelper.emailExists(email);

    if (emailExists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email is already registered')),
      );
    } else {
      await _dbHelper.insertUser(name, email, password);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created successfully')),
      );
      Navigator.pushReplacementNamed(context, '/signIn');
    }
  }

  // TextStyle with stroke (for headings)
  TextStyle strokeTextStyle({
    double fontSize = 32,
    FontWeight fontWeight = FontWeight.bold,
    Color textColor = Colors.white,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: textColor,
      shadows: const [
        Shadow(offset: Offset(1, 1), color: Colors.black),
        Shadow(offset: Offset(1, 1), color: Colors.black),
        Shadow(offset: Offset(1, 1), color: Colors.black),
        Shadow(offset: Offset(1, 1), color: Colors.black),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/splash_background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24), // Adjusted padding
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 80),
                // Title
                Center(
                  child: Text(
                    'Sign Up',
                    style: strokeTextStyle(fontSize: 42),
                  ),
                ),
                const SizedBox(height: 40),
                // Name Field
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Name',
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                // Email Field
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                // Password Field
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                // Confirm Password Field
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Confirm Password',
                    prefixIcon: const Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                // Sign Up Button
                ElevatedButton(
                  onPressed: () => _registerUser(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Social Media Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _socialButton('assets/icons/apple.png'),
                    _socialButton('assets/icons/facebook.png'),
                    _socialButton('assets/icons/google.png'),
                  ],
                ),
                const SizedBox(height: 20),
                // Already Have an Account
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: strokeTextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/signIn');
                      },
                                child: const Text(
                                  "Sign In here",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black, // Black text color
                                    shadows: [
                                    Shadow(offset: Offset(1, 1), color: Colors.white),
                                    Shadow(offset: Offset(1, 1), color: Colors.white),
                                    Shadow(offset: Offset(1, 1), color: Colors.white),
                                    Shadow(offset: Offset(1, 1), color: Colors.white),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Social Media Button
  Widget _socialButton(String assetPath) {
    return Container(
      height: 50,
      width: 50,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(assetPath, fit: BoxFit.contain),
      ),
    );
  }
}