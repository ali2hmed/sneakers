import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../db_helper.dart';
import '../providers/user_provider.dart';

class SneakersSignInScreen extends StatelessWidget {
  SneakersSignInScreen({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final DBHelper _dbHelper = DBHelper();

  void _loginUser(BuildContext context) async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All fields are required')),
      );
      return;
    }

    // Fetch the user by email and password
    final user = await _dbHelper.getUser(email, password);

    if (user != null) {
      // Set the user in the provider
      await Provider.of<UserProvider>(context, listen: false)
          .setUser(user['id'], user['name']);
          
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Welcome, ${user['name']}')),
      );
      Navigator.pushNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid email or password')),
      );
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
                    'Sneakers',
                    style: strokeTextStyle(fontSize: 42),
                  ),
                ),
                Center(
                  child: Text(
                    'Special footwear for everyday use',
                    style: strokeTextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // Email Input
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
                // Password Input
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
                const SizedBox(height: 8),
                // Forgot Password
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'Forgot Password?',
                      style: strokeTextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Sign In Button
                ElevatedButton(
                  onPressed: () => _loginUser(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text(
                    'Sign In',
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
                // Sign Up Link
// Sign In Link
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account? ",
                                style: strokeTextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, '/signUp');
                                },
                            child: Text(
                              "Sign Up here",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.black, // Black text color
                                shadows: const [
                                  Shadow(offset: Offset(0.5, 0.5), color: Colors.white),
                                  Shadow(offset: Offset(0.5, 0.5), color: Colors.white),
                                  Shadow(offset: Offset(0.5, 0.5), color: Colors.white),
                                  Shadow(offset: Offset(0.5, 0.5), color: Colors.white),
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