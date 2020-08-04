import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:test1/models/post.dart';
import 'package:test1/models/user.dart';
import 'package:test1/services/database.dart';
import 'package:test1/shared/constants.dart';
import 'package:test1/shared/loading.dart';
import 'package:google_maps_webservice/places.dart';

const kGoogleApiKey = 'AIzaSyBzLclE52lU2gOqxgPjRHd1ASuBZ0qdwDM';

class Posting extends StatefulWidget {
  final Function switchPosting;
  final String postId;
  Posting({this.switchPosting, this.postId});
  @override
  _PostingState createState() => _PostingState();
}

class _PostingState extends State<Posting> {
  //final DatabaseService _databaseService = DatabaseService();
  final _formKey = GlobalKey<FormState>();
  final List<int> types = [1, 2, 3, 4];

  bool loading = false;
  String _title;
  String address;
  String description;
  int _currentType = 1;
  Position position;
  double lat;
  double lng;
  String error = '';
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if (widget.postId != '') {
      return StreamBuilder<PostData>(
          stream: PostService(uid: user.uid, postId: widget.postId)
              .postFromId(widget.postId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              PostData postData = snapshot.data;
              if (_title == null) {
                _title = postData.title;
              }
              if (description == null) {
                description = postData.description;
              }
              if (_currentType == 1) {
                _currentType = postData.type;
              }
              if (address == null) {
                address = postData.address;
              }
              return Scaffold(
                  backgroundColor: Colors.green[100],
                  appBar: AppBar(
                    backgroundColor: Colors.green[400],
                    elevation: 0.0,
                    title: Text('Edit Post'),
                  ),
                  body: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 50.0),
                      child: SingleChildScrollView(
                        child: Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                SizedBox(height: 20.0),
                                TextFormField(
                                    initialValue: postData.title,
                                    decoration: textInputDecoration.copyWith(
                                        hintText: 'title'),
                                    validator: (val) =>
                                        val.isEmpty ? 'Enter an email' : null,
                                    onChanged: (val) {
                                      setState(() => _title = val);
                                    }),
                                SizedBox(height: 10.0),
                                DropdownButtonFormField(
                                    decoration: textInputDecoration,
                                    value: postData.type,
                                    items: types.map((type) {
                                      return DropdownMenuItem(
                                        value: type,
                                        child: Text(type == 1
                                            ? 'Donation'
                                            : type == 2
                                                ? 'Job Offer'
                                                : type == 3
                                                    ? 'Living Quarters'
                                                    : 'Miscellaneous'),
                                      );
                                    }).toList(),
                                    onChanged: (val) =>
                                        setState(() => _currentType = val)),
                                SizedBox(height: 20.0),
                                TextFormField(
                                    initialValue: postData.address,
                                    decoration: textInputDecoration.copyWith(
                                        hintText: 'Location (Address)'),
                                    validator: (val) => val.isEmpty
                                        ? 'You must enter a valid address!'
                                        : null,
                                    onChanged: (val) {
                                      setState(() => address = val);
                                      print("kachiga " + address);
                                    }),
                                SizedBox(height: 20.0),
                                TextFormField(
                                    initialValue: postData.description,
                                    decoration: textInputDecoration.copyWith(
                                        hintText: 'description'),
                                    validator: (val) => val.isEmpty
                                        ? 'You must enter a description'
                                        : null,
                                    onChanged: (val) {
                                      setState(() => description = val);
                                    }),
                                SizedBox(height: 20.0),
                                Row(
                                  children: <Widget>[
                                    RaisedButton(
                                        color: Colors.grey[400],
                                        child: Text(
                                          'Cancel',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        onPressed: () async {
                                          widget.switchPosting(widget.postId);
                                        }),
                                    SizedBox(width: 30.0),
                                    RaisedButton(
                                        color: Colors.blue[300],
                                        child: Text(
                                          'Submit',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        onPressed: () async {
                                          if (_formKey.currentState
                                              .validate()) {
                                            print(user.uid);
                                            print(widget.postId);
                                            print(_title);
                                            print(description);
                                            print(_currentType);
                                            print(address);

                                            try {
                                              List<Placemark> placemark =
                                                  await Geolocator()
                                                      .placemarkFromAddress(
                                                          address);
                                              Placemark place = placemark[0];
                                              position = place.position;
                                              lat = place.position.latitude;
                                              lng = place.position.longitude;
                                              await PostService(
                                                      uid: user.uid,
                                                      postId: widget.postId)
                                                  .updatePostData(
                                                      widget.postId,
                                                      _title,
                                                      description,
                                                      _currentType,
                                                      address,
                                                      lat,
                                                      lng);
                                              widget
                                                  .switchPosting(widget.postId);
                                            } catch (e) {
                                              print(e);
                                              setState(() {
                                                error = 'Invalid Address!';
                                              });
                                            }
                                          }
                                        }),
                                  ],
                                ),
                                SizedBox(height: 12.0),
                                Text(
                                  error,
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 14.0),
                                )
                              ],
                            )),
                      )));
            } else {
              return Loading();
            }
          });
    } else {
      return Scaffold(
          backgroundColor: Colors.green[100],
          appBar: AppBar(
            backgroundColor: Colors.green[400],
            elevation: 0.0,
            title: Text('Edit Post'),
          ),
          body: Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: SingleChildScrollView(
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 20.0),
                        TextFormField(
                            decoration:
                                textInputDecoration.copyWith(hintText: 'title'),
                            validator: (val) =>
                                val.isEmpty ? 'Enter an email' : null,
                            onChanged: (val) {
                              setState(() => _title = val);
                            }),
                        SizedBox(height: 10.0),
                        DropdownButtonFormField(
                            decoration: textInputDecoration,
                            value: _currentType ?? 1,
                            items: types.map((type) {
                              return DropdownMenuItem(
                                value: type,
                                child: Text(type == 1
                                    ? 'Donation'
                                    : type == 2
                                        ? 'Job Offer'
                                        : type == 3
                                            ? 'Living Quarters'
                                            : 'Miscellaneous'),
                              );
                            }).toList(),
                            onChanged: (val) =>
                                setState(() => _currentType = val)),
                        SizedBox(height: 20.0),
                        TextFormField(
                            decoration: textInputDecoration.copyWith(
                                hintText: 'Location (Address)'),
                            validator: (val) => val.isEmpty
                                ? 'You must enter a valid address!'
                                : null,
                            onChanged: (val) {
                              setState(() => address = val);
                            }),
                        SizedBox(height: 20.0),
                        TextFormField(
                            decoration: textInputDecoration.copyWith(
                                hintText: 'description'),
                            validator: (val) => val.isEmpty
                                ? 'You must enter a description'
                                : null,
                            onChanged: (val) {
                              setState(() => description = val);
                            }),
                        SizedBox(height: 20.0),
                        Row(
                          children: <Widget>[
                            RaisedButton(
                                color: Colors.grey[400],
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () async {
                                  widget.switchPosting(widget.postId);
                                }),
                            SizedBox(width: 30.0),
                            RaisedButton(
                                color: Colors.blue[300],
                                child: Text(
                                  'Submit',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState.validate()) {
                                    print(user.uid);
                                    print(widget.postId);
                                    print(_title);
                                    print(description);
                                    print(_currentType);
                                    print(address);
                                    try {
                                      List<Placemark> placemark =
                                          await Geolocator()
                                              .placemarkFromAddress(address);
                                      Placemark place = placemark[0];
                                      position = place.position;
                                      lat = place.position.latitude;
                                      lng = place.position.longitude;
                                      await PostService(
                                              uid: user.uid,
                                              postId: widget.postId)
                                          .createPostData(_title, description,
                                              _currentType, address, lat, lng);
                                      widget.switchPosting(widget.postId);
                                    } catch (e) {
                                      print(e);
                                      setState(() {
                                        error = 'Invalid Address!';
                                      });
                                    }
                                  }
                                }),
                          ],
                        ),
                        SizedBox(height: 12.0),
                        Text(
                          error,
                          style: TextStyle(color: Colors.red, fontSize: 14.0),
                        )
                      ],
                    )),
              )));
    }
  }
}
