import 'package:blog_front_end/screens/login.dart';
import 'package:blog_front_end/services/user_services.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () async {
            await logout();
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const Login()),
              (route) => false,
            );
          },
          child: const Text('press to logout'), // Add your child widget here
        ),
      ),
    );
  }
}
