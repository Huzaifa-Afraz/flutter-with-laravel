import 'package:blog_front_end/models/User.dart';

class Post {
  int? id;
  String? body;
  String? image;
  int? likeCount;
  int? commentCount;
  User? user;
  bool? selfLiked;
  Post(
      {this.id,
      this.body,
      this.image,
      this.likeCount,
      this.commentCount,
      this.user,
      this.selfLiked});
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
        id: json['id'],
        body: json['body'],
        image: json['image'],
        likeCount: json['likes_count'],
        commentCount: json['comment_count'],
        selfLiked: json['likes'].lemgth > 0,
        user: User(
            id: json['user']['id'],
            name: json['user']['name'],
            image: json['user']['image']));
  }
}
