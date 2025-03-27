import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
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

    final user = await _dbHelper.getUser(email, password);

    if (user != null) {
      await Provider.of<UserProvider>(context, listen: false)
          .setUser(user['id'], user['name']);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Welcome, ${user['name']}')),
      );

      // Redirect admin to the admin panel
      if (email == 'admin@sneakers.com') {
        Navigator.pushNamed(context, '/admin');
      } else {
        Navigator.pushNamed(context, '/home');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid email or password')),
      );
    }
  }

  TextStyle strokeTextStyle({
    double fontSize = 32,
    FontWeight fontWeight = FontWeight.bold,
    Color textColor = Colors.white,
  }) {
    return GoogleFonts.lato(
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
            colorFilter: ColorFilter.mode(
              Colors.black54,
              BlendMode.darken,
            ),
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 5),
                Center(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        height: 150,
                      ),
                      const SizedBox(height: 2),
                      Text('Sneakers', style: strokeTextStyle(fontSize: 44)),
                      Text(
                        'Special footwear for everyday use',
                        style: strokeTextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
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
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () {},
                    child: Text('Forgot Password?', style: strokeTextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                  ),
                ),
                const SizedBox(height: 16),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  child: ElevatedButton(
                    onPressed: () => _loginUser(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                      shadowColor: Colors.white.withOpacity(0.5),
                    ),
                    child: const Text(
                      'Sign In',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _socialButton('assets/icons/apple.png'),
                    _socialButton('assets/icons/facebook.png'),
                    _socialButton('assets/icons/google.png'),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: strokeTextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/signUp');
                      },
                      child: const Text(
                        "Sign Up here",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.redAccent,
                          shadows: [
                            Shadow(offset: Offset(0.5, 0.5), color: Colors.black),
                            Shadow(offset: Offset(0.5, 0.5), color: Colors.black),
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

  Widget _socialButton(String assetPath) {
    return GestureDetector(
      onTap: () {},
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
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
        ),
      ),
    );
  }
}
