import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sneakers_app/db_helper.dart';
import 'package:sneakers_app/providers/user_provider.dart';
import 'package:sneakers_app/view/navigator.dart';
import 'package:sneakers_app/view/admin_page.dart';
import 'view/splash_screen.dart';
import 'view/sign_in_screen.dart';
import 'view/sign_up_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize database
  final dbHelper = DBHelper();
  await dbHelper.database; // Ensure database is created
  
  runApp(
    ChangeNotifierProvider(
      create: (_) => UserProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sneakers Shop App',
      theme: ThemeData(fontFamily: 'Quicksand'),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/signIn': (context) => SneakersSignInScreen(),
        '/signUp': (context) => SneakersSignUpScreen(),
        '/home': (context) => const MainNavigator(),
        '/admin': (context) => const AdminDashboardScreen(),
      },
    );
  }
}