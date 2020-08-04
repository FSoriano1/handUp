import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:test1/models/post.dart';
import 'package:test1/models/user.dart';
import 'package:test1/services/database.dart';

DatabaseService ds = DatabaseService();

class PostTile extends StatefulWidget {
  final Post post;
  final Function switchPosting;
  final double lat;
  final double lng;
  final String uid;

  PostTile({this.switchPosting, this.post, this.lat, this.lng, this.uid});
  @override
  _PostTileState createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  String distance = '';
  Color clr = Colors.blue;
  @override
  Widget build(BuildContext context) {
    final names = Provider.of<List<User>>(context);
    final user = Provider.of<User>(context);
    String username = '';
    try {
      for (User name in names) {
        print(widget.post.uid + " " + name.uid);
        if (name.uid == widget.post.uid) {
          username = name.username;
        }
      }
    } catch (e) {
      print(e);
    }

    return Column(
      children: <Widget>[
        FutureBuilder<double>(
          future: Geolocator()
              .distanceBetween(widget.lat, widget.lng, 28.528575, -81.412365),
          builder: (context, AsyncSnapshot<double> snapshot) {
            if (snapshot.hasData) {
              print(widget.post.docId);
              print(widget.post.title);
              print(widget.lat);
              print(widget.lng);
              print(widget.post.address);
              print(widget.post.uid);

              //print(username);
              distance = ((snapshot.data / 160.9344).round() / 10).toString();
            }
            if (user.uid == widget.uid) {
              return Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Card(
                    margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          leading: CircleAvatar(
                              radius: 25.0,
                              backgroundColor: Colors.green[100],
                              child: Text(username ?? 'Loading...')),
                          title: Text(widget.post.title +
                              " - " +
                              distance +
                              " miles away"),
                          subtitle: Text(widget.post.description),
                        ),
                        Text(widget.post.address),
                        ButtonBar(
                          children: <Widget>[
                            FlatButton(
                              child: Text('Comments'),
                              onPressed: () async {},
                            ),
                            FlatButton(
                                child: Text('EDIT'),
                                onPressed: () {
                                  widget.switchPosting(widget.post.docId);
                                }),
                          ],
                        )
                      ],
                    )),
              );
            } else {
              return Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Card(
                    margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          leading: CircleAvatar(
                              radius: 25.0,
                              backgroundColor: Colors.grey[300],
                              child: Text(username ?? 'Loading...')),
                          title: Text(widget.post.title +
                              " - " +
                              distance +
                              " miles away"),
                          subtitle: Text(widget.post.description),
                        ),
                        ButtonBar(
                          children: <Widget>[
                            Text(widget.post.type == 1
                                ? 'Donation'
                                : widget.post.type == 2
                                    ? 'Job Offer'
                                    : widget.post.type == 3
                                        ? 'Living Quarters'
                                        : 'Miscellaneous'),
                            SizedBox(width: 45.0),
                            FlatButton(
                              child: Text('I\'M GOING!'),
                              color: clr,
                              onPressed: () {
                                setState(() {
                                  clr = Colors.grey;
                                });
                              },
                            ),
                            FlatButton(
                              child: Text('Comments'),
                              onPressed: () {},
                            ),
                          ],
                        )
                      ],
                    )),
              );
            }
          },
        ),
      ],
    );
  }
}
