import 'dart:convert';
import 'dart:ffi';

import 'package:blog_front_end/constant.dart';
import 'package:blog_front_end/models/User.dart';
import 'package:blog_front_end/models/api_responce.dart';
import 'package:http/http.dart ' as http;
import 'package:shared_preferences/shared_preferences.dart';

// fetch login api
Future<ApiResponce> login(String email, String password) async {
  ApiResponce apiResponce = ApiResponce();
  try {
    final responce = await http.post(Uri.parse(loginURL),
        headers: {'Accept': 'application/json'},
        body: {'email': email, 'password': password});
    switch (responce.statusCode) {
      case 200:
        apiResponce.data = User.fromJson(jsonDecode(responce.body));
        break;
      case 422:
        final errors = jsonDecode(responce.body)['errors'];
        apiResponce.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 403:
        apiResponce.error = jsonDecode(responce.body)['msg'];
        break;
      default:
        apiResponce.error = somethingwentwrongError;
        break;
    }
  } catch (e) {
    apiResponce.error = serverError;
  }
  return apiResponce;
}

// fetch register user api
Future<ApiResponce> register(String name, String email, String password) async {
  ApiResponce apiResponce = ApiResponce();
  try {
    final responce = await http.post(Uri.parse(registerURL), headers: {
      'Accept': 'application/json'
    }, body: {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': password
    });
    switch (responce.statusCode) {
      case 200:
        apiResponce.data = User.fromJson(jsonDecode(responce.body));
        break;
      case 422:
        final errors = jsonDecode(responce.body)['errors'];
        apiResponce.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 403:
        apiResponce.error = jsonDecode(responce.body)['msg'];
        break;
      default:
        apiResponce.error = somethingwentwrongError;
        break;
    }
  } catch (e) {
    apiResponce.error = serverError;
  }
  return apiResponce;
}

// get all user api
Future<ApiResponce> getUserDetail() async {
  ApiResponce apiResponce = ApiResponce();
  try {
    String token = await getToken();
    final responce = await http.post(Uri.parse(registerURL), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    switch (responce.statusCode) {
      case 200:
        apiResponce.data = User.fromJson(jsonDecode(responce.body));
        break;
      case 422:
        final errors = jsonDecode(responce.body)['errors'];
        apiResponce.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 401:
        apiResponce.error = unauthorizedError;
        break;
      default:
        apiResponce.error = somethingwentwrongError;
        break;
    }
  } catch (e) {
    apiResponce.error = serverError;
  }
  return apiResponce;
}

// get token from shared preferences
Future<String> getToken() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('token') ?? '';
}

// get user id from shared preferences
Future<bool> logout() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return await pref.remove('userid');
}

// get user id from shared preferences
Future<int> getUserId() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getInt('userid') ?? 0;
}
