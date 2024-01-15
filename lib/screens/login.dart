import 'dart:math';

import 'package:blog_front_end/constant.dart';
import 'package:blog_front_end/models/User.dart';
import 'package:blog_front_end/models/api_responce.dart';
import 'package:blog_front_end/screens/home.dart';
import 'package:blog_front_end/screens/register.dart';
import 'package:blog_front_end/services/user_services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController emailText = TextEditingController();
  TextEditingController passwordText = TextEditingController();
  bool loading = false;
  void _loginUser() async {
    ApiResponce responce = await login(emailText.text, passwordText.text);
    if (responce.error == null) {
      _saveAndRedirectToHome(responce.data as User);
    } else {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${responce.error}')));
    }
  }

  void _saveAndRedirectToHome(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token ?? '');
    await pref.setInt('userid', user.id ?? 0);
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: ((context) => const Home())),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: Form(
          key: formkey,
          child: ListView(
            padding: const EdgeInsets.all(32),
            children: [
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: emailText,
                validator: (value) => value!.isEmpty ? "Invalid email" : null,
                decoration: inpDecoration('Email'),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: passwordText,
                obscureText: true,
                validator: (value) => value!.length < 5
                    ? "password length should be at least 5 char"
                    : null,
                decoration: inpDecoration('password'),
              ),
              const SizedBox(
                height: 10,
              ),
              loading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : txtButton('Login', () {
                      if (formkey.currentState!.validate()) {
                        setState(() {
                          loading = true;
                          _loginUser();
                        });
                      }
                    }),
              const SizedBox(
                height: 10,
              ),
              remRegister('Dont have ann account? ', "Register", () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const Register()),
                    (route) => false);
              })
            ],
          )),
    );
  }
}
