import 'package:flutter/material.dart';
import 'package:test1/models/post.dart';
import 'package:test1/models/user.dart';
import 'package:test1/screens/home/post_list.dart';
import 'package:test1/services/auth.dart';
import 'package:test1/services/database.dart';
import 'package:provider/provider.dart';
import 'package:test1/shared/posting.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String id = '';
  bool posting = false;
  final AuthService _auth = AuthService();
  void switchPosting(String postId) {
    setState(() {
      posting = !posting;
      if (posting) {
        id = postId;
      } else {
        id = '';
      }

      print(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return posting
        ? Posting(switchPosting: switchPosting, postId: id)
        : StreamProvider<List<Post>>.value(
            value: DatabaseService().posts,
            child: StreamProvider<List<User>>.value(
              value: DatabaseService().names,
              child: Scaffold(
                backgroundColor: Colors.red[50],
                appBar: AppBar(
                  title: Text('HandUp'),
                  backgroundColor: Colors.red[200],
                  elevation: 0.0,
                  actions: <Widget>[
                    FlatButton.icon(
                      icon: Icon(Icons.person),
                      label: Text('Log Out'),
                      onPressed: () async {
                        await _auth.signOut();
                      },
                    )
                  ],
                ),
                body: PostList(switchPosting: switchPosting),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      posting = true;
                    });
                  },
                  child: Icon(Icons.add),
                  backgroundColor: Colors.blue,
                ),
              ),
            ),
          );
  }
}
