import 'package:blog_front_end/constant.dart';
import 'package:blog_front_end/models/api_responce.dart';
import 'package:blog_front_end/screens/login.dart';
import 'package:blog_front_end/screens/post_form.dart';
import 'package:blog_front_end/services/post_services.dart';
import 'package:blog_front_end/services/user_services.dart';
import 'package:flutter/material.dart';

import '../models/post.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  List<dynamic> _postList = [];
  int userId = 0;
  bool _loading = true;

  get index => null;
  Future<void> retrivePosts() async {
    userId = await getUserId();
    ApiResponce responce = await getPosts();
    if (responce.error == null) {
      setState(() {
        _postList = responce.data as List<dynamic>;
        _loading = _loading ? !_loading : _loading;
      });
    } else if (responce.error == unauthorizedError) {
      logout().then((value) => Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: ((context) => const Login())),
            (route) => false,
          ));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${responce.error}')));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    retrivePosts();
    super.initState();
  }

  Widget build(BuildContext context) {
    return _loading
        ? Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: () {
              return retrivePosts();
            },
            child: ListView.builder(
                itemCount: _postList.length,
                itemBuilder: (BuildContext context, int index) {
                  Post post = _postList[index];
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6),
                              child: Row(
                                children: [
                                  Container(
                                    width: 38,
                                    height: 38,
                                    decoration: BoxDecoration(
                                        image: post.user!.image != null
                                            ? DecorationImage(
                                                image: NetworkImage(
                                                    '${post.user!.image}'))
                                            : null,
                                        borderRadius: BorderRadius.circular(25),
                                        color: Colors.amber),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    '${post.user!.name}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 17),
                                  )
                                ],
                              ),
                            ),
                            post.user!.id == userId
                                ? PopupMenuButton(
                                    child: Padding(
                                        padding: EdgeInsets.only(right: 10),
                                        child: Icon(
                                          Icons.more_vert,
                                          color: Colors.black,
                                        )),
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                          child: Text('Edit'), value: 'edit'),
                                      PopupMenuItem(
                                          child: Text('Delete'),
                                          value: 'delete')
                                    ],
                                    onSelected: (val) {
                                      if (val == 'edit') {
                                      } else {}
                                    },
                                  )
                                : const SizedBox()
                          ],
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Text('${post.body}'),
                        post.image != null
                            ? Container(
                                width: MediaQuery.of(context).size.width,
                                height: 180,
                                margin: const EdgeInsets.only(top: 5),
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage('${post.image}'),
                                        fit: BoxFit.cover)),
                              )
                            : SizedBox(
                                height: post.image != null ? 0 : 10,
                              ),
                        Row(
                          children: [
                            LikeAndComment(
                                post.likeCount ?? 0,
                                post.selfLiked == true
                                    ? Icons.favorite
                                    : Icons.favorite_outline,
                                post.selfLiked == true
                                    ? Colors.red
                                    : Colors.black54,
                                () {}),
                            Container(
                              height: 25,
                              width: 0.5,
                              color: Colors.black38,
                            ),
                            LikeAndComment(post.commentCount ?? 0,
                                Icons.sms_outlined, Colors.black54, () {}),
                          ],
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 0.5,
                          color: Colors.black26,
                        ),
                      ],
                    ),
                  );
                }),
          );
  }
}
