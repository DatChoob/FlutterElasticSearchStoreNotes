class User {
  String id;
  List<String> emails;
  String name;
  String phoneNumber;
  String dateOfBirth;
  String address;
  List<Document> documents;
  User(
      {this.id,
      this.emails,
      this.name,
      this.phoneNumber,
      this.dateOfBirth,
      this.documents,
      this.address});

  String getName() => name;
}

class Document {
  String dataType;
  String title;
  dynamic data;
  Document({this.dataType, this.title, this.data});
}
