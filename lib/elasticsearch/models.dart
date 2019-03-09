class User {
  String id;
  String email;
  String name;
  String phoneNumber;
  String dateOfBirth;
  String address;
  List<Document> documents;
  User(
      {this.id,
      this.email,
      this.name,
      this.phoneNumber,
      this.dateOfBirth,
      this.documents,
      this.address});

  toFirebaseJson() {
    return {
      'name': name,
      'date_of_birth': dateOfBirth,
      'email': email,
      'phone_number': phoneNumber,
      'address': address
    };
  }
}

class Document {
  num uid;
  String dataType;
  String title;
  dynamic data;
  Document({this.uid, this.dataType, this.title, this.data});
}
