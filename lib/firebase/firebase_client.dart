import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_app/elasticsearch/models.dart';

class FirebaseClient {
  void createUser(User user) {
    Firestore.instance
        .collection('users')
        .document()
        .setData(user.toFirebaseJson());
  }
}
