import 'package:blog_front_end/screens/login.dart';
import 'package:blog_front_end/services/user_services.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Blog App',
            style: TextStyle(
                color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  await logout();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: ((context) => const Login())),
                    (route) => false,
                  );
                },
                icon: const Icon(
                  Icons.exit_to_app,
                  color: Colors.white,
                ))
          ],
          backgroundColor: Colors.blue,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Colors.blue,
          child: Icon(
            Icons.add,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
