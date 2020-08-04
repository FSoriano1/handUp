import 'package:geolocator/geolocator.dart';

class Post {
  final String docId;
  final String uid;
  final String address;
  final double lat;
  final double lng;
  //final double time;
  final String description;
  final String title;
  final int type;

  Post(
      {this.docId,
      this.uid,
      this.title,
      this.description,
      this.type,
      this.address,
      this.lat,
      this.lng});
}

class PostData {
  final String docId;
  final String uid;
  final String address;
  final double lat;
  final double lng;
  //final double time;
  final String description;
  final String title;
  final int type;

  PostData(
      {this.docId,
      this.uid,
      this.title,
      this.description,
      this.type,
      this.address,
      this.lat,
      this.lng});
}
