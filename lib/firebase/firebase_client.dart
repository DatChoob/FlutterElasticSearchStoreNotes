import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_app/elasticsearch/models.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class FirebaseClient {
  static void createUser(User user, File userImage) async {
    FirebaseStorage _storage = FirebaseStorage.instance;
    if (userImage != null) {
      String filetype = userImage.path.split("/").last.split('.').last;
      //Create a reference to the location you want to upload to in firebase
      StorageReference reference =
          _storage.ref().child('images').child("${Uuid().v1()}.$filetype");

      //Upload the file to firebase
      StorageUploadTask uploadTask = reference.putFile(userImage);

      // Waits till the file is uploaded then stores the download url
      String location =
          await (await uploadTask.onComplete).ref.getDownloadURL();
      user.imageURL = location;
    }
    Firestore.instance
        .collection('users')
        .document()
        .setData(user.toFirebaseJson());
  }

  static updateUser(User user, File userImage) async {
    FirebaseStorage _storage = FirebaseStorage.instance;
    if (userImage != null) {
      String filetype = userImage.path.split("/").last.split('.').last;
      //Create a reference to the location you want to upload to in firebase
      StorageReference reference =
          _storage.ref().child('images').child("${Uuid().v1()}.$filetype");

      //Upload the file to firebase
      StorageUploadTask uploadTask = reference.putFile(userImage);

      // Waits till the file is uploaded then stores the download url
      String location =
          await (await uploadTask.onComplete).ref.getDownloadURL();
      user.imageURL = location;
    }
    Firestore.instance
        .document('users/${user.userID}')
        .updateData(user.toFirebaseJson());
  }

  static getUser(String userID) {
    return Firestore.instance
        .document('users/$userID')
        .get()
        .then((snapshot) => User.fromFirebase(snapshot.data));
  }
}
