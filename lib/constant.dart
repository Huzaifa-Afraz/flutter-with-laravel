//     url
import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:fluttertoast/fluttertoast.dart';

const baseURL = 'http://127.0.0.1:8000';
const loginURL = '$baseURL/api/login';
const registerURL = '$baseURL/api/register';
const logoutURL = '$baseURL/api/logout';
const userURL = '$baseURL/user';
const postsURL = '$baseURL/posts';
const commentsURL = '$baseURL/comments';

// errors
const serverError = 'server error';
const unauthorizedError = 'unauthorized';
const somethingwentwrongError = 'some thing went wrong';

InputDecoration inpDecoration(String label) {
  return InputDecoration(
      labelText: label,
      contentPadding: EdgeInsets.all(10),
      border: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.black)));
}

// buttons

TextButton txtButton(String name, Function onpressed) {
  return (TextButton(
    onPressed: () => onpressed(),
    child: Text(
      name,
      style: TextStyle(color: Colors.white),
    ),
    style: ButtonStyle(
      backgroundColor: MaterialStateColor.resolveWith((states) => Colors.blue),
      padding: MaterialStateProperty.resolveWith(
          (states) => const EdgeInsets.symmetric(vertical: 18)),
      shape:
          MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              )),
    ),
  ));
}

// remember register
Row remRegister(String text, String label, Function onTap) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(text),
      GestureDetector(
        child: Text(
          label,
          style: TextStyle(color: Colors.blue),
        ),
        onTap: () => onTap(),
      )
    ],
  );
}

// show SnackBar
// void showSnackBar(BuildContext context, String message) {
//   ScaffoldMessenger.of(context).showSnackBar(
//     SnackBar(content: Text(message)),
//   );
// }
void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}

void showNotification(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.red,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}
