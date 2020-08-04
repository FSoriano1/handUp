import 'package:test1/models/post.dart';

class User {
  final String uid;
  final String username;

  User({this.uid, this.username});
}

class UserData {
  final String uid;
  final List<Post> posts;
  final String username;

  UserData({this.uid, this.username, this.posts});
}
