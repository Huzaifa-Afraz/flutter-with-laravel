import 'dart:convert';

import 'package:blog_front_end/constant.dart';
import 'package:blog_front_end/models/User.dart';
import 'package:blog_front_end/models/api_responce.dart';
import 'package:blog_front_end/services/user_services.dart';
import 'package:http/http.dart ' as http;

// get all posts
Future<ApiResponce> getPosts() async {
  ApiResponce apiResponce = ApiResponce();
  try {
    String token = await getToken();
    final responce = await http.get(Uri.parse(postsURL), headers: {
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
      case 403:
        apiResponce.error = jsonDecode(responce.body)['msg'];
        break;
      default:
        apiResponce.error =
            'Unexpected status code: ${responce.statusCode}' + loginURL;
        break;
    }
  } catch (e) {
    apiResponce.error = serverError;
  }
  return apiResponce;
}

// insert a new post
Future<ApiResponce> insertPost(String body, String? image) async {
  ApiResponce apiResponce = ApiResponce();
  try {
    String token = await getToken();
    final responce = await http.post(Uri.parse(postsURL),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: image != null ? {'body': body, 'image': image} : {'body': body});
    switch (responce.statusCode) {
      case 200:
        apiResponce.data = jsonDecode(responce.body);
        break;
      case 422:
        final errors = jsonDecode(responce.body)['errors'];
        apiResponce.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 401:
        apiResponce.error = unauthorizedError;
        break;
      default:
        apiResponce.error = postsURL;
        break;
    }
  } catch (e) {
    apiResponce.error = serverError;
  }
  return apiResponce;
}

// update a post
Future<ApiResponce> updatePost(int postId, String body) async {
  ApiResponce apiResponce = ApiResponce();
  try {
    String token = await getToken();
    final responce = await http.put(Uri.parse('$postsURL/$postId'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    switch (responce.statusCode) {
      case 200:
        apiResponce.data = jsonDecode(responce.body)['msg'];
        break;
      case 403:
        apiResponce.data = jsonDecode(responce.body)['msg'];
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

// delete a post
Future<ApiResponce> deletePost(int postId) async {
  ApiResponce apiResponce = ApiResponce();
  try {
    String token = await getToken();
    final responce = await http.delete(Uri.parse('$postsURL/$postId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });
    switch (responce.statusCode) {
      case 200:
        apiResponce.data = jsonDecode(responce.body)['msg'];
        break;
      case 403:
        apiResponce.data = jsonDecode(responce.body)['msg'];
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
