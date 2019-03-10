class User {
  String id;
  String email;
  String name;
  String phoneNumber;
  DateTime dateOfBirth;
  String address;
  List<Document> documents;
  String imageURL;
  User(
      {this.id,
      this.email,
      this.name,
      this.phoneNumber,
      this.dateOfBirth,
      this.documents,
      this.address,
      this.imageURL});

  toFirebaseJson() {
    return {
      'name': name,
      'dateOfBirth': dateOfBirth,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address
    };
  }

  static fromFirebase(Map<String, dynamic> data) {
    return User(
        name: data['name'],
        dateOfBirth: data['dateOfBirth'],
        email: data['email'],
        phoneNumber: data['phoneNumber'],
        address: data['address'],
        imageURL: data['imageURL']);
  }
}

class Document {
  num uid;
  String dataType;
  String title;
  dynamic data;
  Document({this.uid, this.dataType, this.title, this.data});
}
