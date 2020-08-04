import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:test1/models/post.dart';
import 'package:test1/models/user.dart';
import 'package:test1/services/auth.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});
  //collection reference
  final CollectionReference postCollection =
      Firestore.instance.collection('posts');

  final CollectionReference nameCollection =
      Firestore.instance.collection('names');

  Future addUsername(String name, String uid2) async {
    return await nameCollection
        .document(uid2)
        .setData({'username': name, 'uid': uid});
  }

  Future updateUserData(String sugars, String name, int strength) async {
    return await postCollection.document(uid).setData({
      //description, title, type, location, comments, DateTime
      'sugars': sugars,
      'name': name,
      'strength': strength,
    });
  }

  //post list from snapshot
  List<Post> _postListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Post(
          docId: doc.documentID,
          uid: doc.data['uid'] ?? '',
          title: doc.data['title'] ?? '',
          description: doc.data['description'] ?? '0',
          type: doc.data['type'] ?? 0,
          address: doc.data['address'] ?? '0',
          lat: doc.data['lat'] ?? 0,
          lng: doc.data['lng'] ?? 0);
    }).toList();
  }

  List<User> _nameListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return User(uid: doc.documentID, username: doc.data['username']);
    }).toList();
  }

  //userdata from snapshot

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      username: snapshot.data['name'],
      posts: null,
    );
  }

  String _nameFromSnapshot(DocumentSnapshot snapshot) {
    return snapshot.data['username'];
  }

  //get posts stream
  Stream<List<Post>> get posts {
    return postCollection.snapshots().map(_postListFromSnapshot);
  }

  //get posts stream
  Stream<List<User>> get names {
    return nameCollection.snapshots().map(_nameListFromSnapshot);
  }

  Stream<String> getUsername(String uid2) {
    return nameCollection.document(uid2).snapshots().map(_nameFromSnapshot);
  }

  //get user data
  Stream<UserData> get userData {
    return postCollection.document(uid).snapshots().map(_userDataFromSnapshot);
  }
}

class PostService {
  final String uid;
  final String postId;
  PostService({this.uid, this.postId});
  //collection reference
  final CollectionReference postCollection =
      Firestore.instance.collection('posts');

  Future createPostData(String title, String description, int type,
      String address, double lat, double lng) async {
    return await postCollection.add({
      'uid': uid,
      'title': title,
      'description': description,
      'type': type,
      'address': address,
      'lat': lat,
      'lng': lng
    });
  }

  Future updatePostData(String postId, String title, String description,
      int type, String address, double lat, double lng) async {
    return await postCollection.document(postId).setData({
      //description, title, type, location, comments, DateTime
      'uid': uid,
      'title': title,
      'description': description,
      'type': type,
      'address': address,
      'lat': lat,
      'lng': lng
    });
  }

  //post list from snapshot
  List<Post> _postListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Post(
          title: doc.data['title'] ?? '',
          type: doc.data['type'] ?? 0,
          description: doc.data['description'] ?? '0');
    }).toList();
  }

  //userdata from snapshot

  PostData _postDataFromSnapshot(DocumentSnapshot snapshot) {
    return PostData(
      docId: snapshot.documentID,
      uid: snapshot.data['uid'],
      title: snapshot.data['title'],
      address: snapshot.data['address'],
      description: snapshot.data['description'],
      type: snapshot.data['type'],
    );
  }

  //get posts stream
  Stream<PostData> postFromId(String postId) {
    return postCollection
        .document(postId)
        .snapshots()
        .map(_postDataFromSnapshot);
  }
}
