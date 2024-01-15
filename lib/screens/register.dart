import 'package:blog_front_end/constant.dart';
import 'package:blog_front_end/models/User.dart';
import 'package:blog_front_end/models/api_responce.dart';
import 'package:blog_front_end/screens/home.dart';
import 'package:blog_front_end/screens/login.dart';
import 'package:blog_front_end/services/user_services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmationController = TextEditingController();
  bool loading = false;
  void _registerUser() async {
    ApiResponce responce = await register(
        nameController.text, emailController.text, passwordController.text);
    if (responce.error == null) {
      _saveAndRedirectToHome(responce.data as User);
    } else {
      setState(() {
        loading = false;
      });
      // ignore: use_build_context_synchronously
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
                controller: nameController,
                validator: (value) =>
                    value!.isEmpty ? "Please enter name" : null,
                decoration: inpDecoration('Name'),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                validator: (value) =>
                    value!.isEmpty ? "Please enter name" : null,
                decoration: inpDecoration('Email'),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: passwordController,
                validator: (value) =>
                    value!.isEmpty ? "Please enter Password" : null,
                decoration: inpDecoration('Password'),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: confirmationController,
                validator: (value) => value != passwordController.text
                    ? "Conform password does not match"
                    : null,
                decoration: inpDecoration('Conform Password'),
              ),
              const SizedBox(
                height: 10,
              ),
              loading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : txtButton('Resister', () {
                      if (formkey.currentState!.validate()) {
                        setState(() {
                          loading = !loading;
                          _registerUser();
                        });
                      }
                    }),
              const SizedBox(
                height: 10,
              ),
              remRegister('Already have an account? ', "Login", () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const Login()),
                    (route) => false);
              })
            ],
          )),
    );
  }
}
