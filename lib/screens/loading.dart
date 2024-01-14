import 'package:blog_front_end/constant.dart';
import 'package:blog_front_end/models/api_responce.dart';
import 'package:blog_front_end/screens/home.dart';
import 'package:blog_front_end/screens/login.dart';
import 'package:blog_front_end/services/user_services.dart';
import 'package:flutter/material.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  void _loadUserInfo() async {
    String token = await getToken();
    if (token == '') {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: ((context) => const Login())),
        (route) => false,
      );
    } else {
      ApiResponce responce = await getUserDetail();
      if (responce.error == null) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: ((context) => const Home())),
          (route) => false,
        );
      } else if (responce.error == unauthorizedError) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: ((context) => const Login())),
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('${responce.error}')));
      }
    }
  }

  @override
  void initState() {
    _loadUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
