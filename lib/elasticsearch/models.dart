import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String userID;
  String email;
  String name;
  String phoneNumber;
  DateTime dateOfBirth;
  String address;
  List<Document> documents;
  String imageURL;
  User(
      {this.userID,
      this.email,
      this.name,
      this.phoneNumber,
      this.dateOfBirth,
      this.documents,
      this.address,
      this.imageURL});

  toFirebaseJson() {
    return {
      //'userID': userID,
      'name': name,
      'dateOfBirth': dateOfBirth,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
      'imageURL': imageURL
    };
  }

  static fromFirebase(Map<String, dynamic> data) {
    return User(
        userID: data['userID'],
        name: data['name'],
        dateOfBirth: (data['dateOfBirth'] as Timestamp)?.toDate(),
        email: data['email'],
        phoneNumber: data['phoneNumber'],
        address: data['address'],
        imageURL: data['imageURL']);
  }
}

class Document {
  num documentID;
  String dataType;
  String title;
  dynamic data;
  Document({this.documentID, this.dataType, this.title, this.data});
}
