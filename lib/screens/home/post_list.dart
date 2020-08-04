import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test1/models/post.dart';
import 'package:test1/screens/home/post_tile.dart';

class PostList extends StatefulWidget {
  final Function switchPosting;
  PostList({this.switchPosting});
  @override
  _PostListState createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  void switchPosting2(String id) {
    widget.switchPosting(id);
  }

  @override
  Widget build(BuildContext context) {
    final posts = Provider.of<List<Post>>(context) ?? [];
    //print(posts.documents);

    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return PostTile(
            switchPosting: switchPosting2,
            post: posts[index],
            lat: posts[index].lat,
            lng: posts[index].lng,
            uid: posts[index].uid);
      },
    );
  }
}
