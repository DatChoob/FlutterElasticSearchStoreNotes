import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_app/firebase/firebase_client.dart';
import 'models.dart';

class ElasticSearchClient {
  updateUser(User user) async {
    return http.post(
        "http://elastic:Mu2PMMwT@35.193.11.79:8080/users/user/${user.userID}/_update",
        body: jsonEncode({'doc': _getUpdateUserPayload(user)}),
        headers: {"Content-Type": "application/json"}).then((response) {
      print("Response status: ${response.statusCode}");
      // print("Response body: ${response.body}");
      return response.statusCode == 200;
    });
  }

  _getUpdateUserPayload(User user) {
    return {
      'name': user.name,
      'email': user.email,
      'phone_number': user.phoneNumber,
      'date_of_birth': user.dateOfBirth?.toString(),
      'documents': _getDocumentPayload(user.documents)
    };
  }

  searchByKeywords(keywords) async {
    List<User> esUsers = await http.post(
        "http://elastic:Mu2PMMwT@35.193.11.79:8080/users/user/_search",
        body: jsonEncode(_getRequestPayload(keywords)),
        headers: {
          "Content-Type": "application/json"
        }).then((response) => _mapSearchKeywordResponse(response.body));
    var firebaseUsers = [];

    for (User esUser in esUsers) {
      firebaseUsers
          .add(await FirebaseClient.getUser(esUser.userID).then((userData) {
        userData.documents = esUser.documents;
        return userData;
      }));
    }
    return firebaseUsers;
  }

  Map _getRequestPayload(searchKeywords) {
    return {
      "_source": {
        "includes": ["*"],
        "excludes": ["documents"]
      },
      "query": {
        "bool": {
          "should": [
            {
              "nested": {
                "path": "documents",
                "query": {
                  "bool": {
                    "should": [
                      {
                        "match": {"documents.title": searchKeywords}
                      },
                      {
                        "match": {"documents.data": searchKeywords}
                      }
                    ]
                  }
                },
                "inner_hits": {}
              }
            },
            {
              "multi_match": {
                "query": searchKeywords,
                "fields": ["name"],
                "fuzziness": "AUTO"
              }
            }
          ]
        }
      }
    };
  }

  List<User> _mapSearchKeywordResponse(responseBody) {
    var responseJson = jsonDecode(responseBody);
    List<User> users = [];
    for (var esUser in responseJson['hits']["hits"]) {
      var esUserSource = esUser["_source"];
      User user = User(
        userID: esUser['_id'],
        name: esUserSource["name"],
        // address: esUserSource["address"],
        // phoneNumber: esUserSource["phone_number"],
        documents: getDocumentsFromInnerHits(
          esUser["inner_hits"]["documents"]["hits"]["hits"],
        ),
        // dateOfBirth: esUserSource["date_of_birth"],
        // email: esUserSource["email"]
      );
      users.add(user);
    }
    return users;
  }

  List<Document> getDocumentsFromInnerHits(documents) {
    List<Document> userDocuments = [];
    for (var document in documents) {
      var documentInformation = document['_source'];
      userDocuments.add(Document(
          documentID: documentInformation['documentID'],
          data: documentInformation['data'],
          dataType: documentInformation['dataType'],
          title: documentInformation['title']));
    }
    return userDocuments;
  }

  _getDocumentPayload(List<Document> documents) {
    var docArray = [];
    for (Document doc in documents) {
      docArray.add({
        'documentID': doc.documentID,
        'dataType': doc.dataType,
        'data': doc.data,
        'title': doc.title
      });
    }
    return docArray;
  }
}
