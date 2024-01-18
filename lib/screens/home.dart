import 'package:blog_front_end/screens/login.dart';
import 'package:blog_front_end/screens/post_form.dart';
import 'package:blog_front_end/screens/post_screen.dart';
import 'package:blog_front_end/screens/profile.dart';
import 'package:blog_front_end/services/user_services.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentindex = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Blog App',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                  onPressed: () async {
                    await logout();
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: ((context) => const Login())),
                      (route) => false,
                    );
                    // Navigator.of(context).push();
                  },
                  icon: const Icon(
                    Icons.exit_to_app,
                    color: Colors.white,
                  ))
            ],
            backgroundColor: Colors.blue,
          ),
          body: currentindex == 0 ? const PostScreen() : const Profile(),
          floatingActionButton: Padding(
            padding: EdgeInsets.all(5.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30.2),
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: ((context) => const PostForm())),
                    (route) => false,
                  );
                },
                backgroundColor: Colors.blue,
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: Container(
            height: 85,
            color: Colors.white,
            child: BottomAppBar(
              notchMargin: 5,
              elevation: 10,
              clipBehavior: Clip.antiAlias,
              shape: const CircularNotchedRectangle(),
              color: Colors.transparent,
              child: Container(
                height: 0,
                color: Colors.white,
                child: BottomNavigationBar(
                  items: const [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        label: '',
                        backgroundColor: Colors.red),
                    BottomNavigationBarItem(icon: Icon(Icons.person), label: '')
                  ],
                  currentIndex: currentindex,
                  selectedItemColor: Colors.blue,
                  // backgroundColor: Color.fromARGB(0, 255, 246, 246),
                  onTap: (value) => setState(() {
                    currentindex = value;
                  }),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
