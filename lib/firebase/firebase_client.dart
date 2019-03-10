import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_app/elasticsearch/models.dart';

class FirebaseClient {
  static void createUser(User user) {
    Firestore.instance
        .collection('users')
        .document()
        .setData(user.toFirebaseJson());
  }

  static updateUser(User user) async {
    Firestore.instance
        .collection('users/${user.userID}')
        .document()
        .updateData(user.toFirebaseJson());
  }
}
