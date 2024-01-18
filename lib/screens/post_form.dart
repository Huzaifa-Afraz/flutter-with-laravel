import 'dart:io';

import 'package:blog_front_end/constant.dart';
import 'package:blog_front_end/models/api_responce.dart';
import 'package:blog_front_end/models/post.dart';
import 'package:blog_front_end/screens/home.dart';
import 'package:blog_front_end/screens/loading.dart';
import 'package:blog_front_end/screens/login.dart';
import 'package:blog_front_end/services/post_services.dart';
import 'package:blog_front_end/services/user_services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PostForm extends StatefulWidget {
  const PostForm({super.key, required String title, required Post post});

  @override
  State<PostForm> createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _textControllerbody = TextEditingController();
  bool _loading = false;
  File? _imagefile;
  final ImagePicker _picker = ImagePicker();
  Future<void> GetImage() async {
    final pickedfile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedfile != null) {
      setState(() {
        _imagefile = File(pickedfile.path);
      });
    }
  }

  void _createpost() async {
    String? image = _imagefile == null ? null : getStringImage(_imagefile);
    ApiResponce responce = await insertPost(_textControllerbody.text, image);
    if (responce.error == null) {
      Navigator.of(context).pop();
    } else if (responce.error == unauthorizedError) {
      logout().then((value) => Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: ((context) => const Login())),
            (route) => false,
          ));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${responce.error}')));
      setState(() {
        _loading = !_loading;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add New Post',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 30,
            color: Colors.white,
          ),
          onPressed: () {
            // Navigator.of(context).pop(); // Navigate back to the previous page
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: ((context) => const Home())),
              (route) => false,
            );
          },
        ),
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  decoration: BoxDecoration(
                      image: _imagefile == null
                          ? null
                          : DecorationImage(
                              image: FileImage(_imagefile ?? File('')),
                              fit: BoxFit.cover)),
                  child: Center(
                      child: IconButton(
                    icon: const Icon(
                      Icons.image,
                      size: 50,
                      color: Colors.black38,
                    ),
                    onPressed: () {
                      GetImage();
                    },
                  )),
                ),
                Form(
                    key: _formkey,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: TextFormField(
                        controller: _textControllerbody,
                        keyboardType: TextInputType.multiline,
                        maxLines: 9,
                        validator: (value) =>
                            value!.isEmpty ? "Post data is required" : null,
                        decoration: const InputDecoration(
                            hintText: "write post...",
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1, color: Colors.black38))),
                      ),
                    )),
                // const Padding(
                //   padding: EdgeInsets.symmetric(horizontal: 8),
                //   child: txtButton('Post', () {}),
                // ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  child: txtButton(
                      'Post',
                      () => {
                            if (_formkey.currentState!.validate())
                              {
                                setState(() => _loading = !_loading),
                                _createpost()
                              }
                          }),
                )
              ],
            ),
    );
  }
}
