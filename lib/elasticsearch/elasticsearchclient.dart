import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models.dart';

class ElasticSearchClient {
  searchByKeywords(keywords) {
    return http.post("http://localhost:9200/users/user/_search",
        body: jsonEncode(_getRequestPayload(keywords)),
        headers: {"Content-Type": "application/json"}).then((response) {
      // print("Response status: ${response.statusCode}");
      // print("Response body: ${response.body}");
      return _mapSearchKeywordResponse(response.body);
    });
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
          id: esUser['_id'],
          name: esUserSource["name"],
          address: esUserSource["address"],
          phoneNumber: esUserSource["phone_number"],
          documents: getDocumentsFromInnerHits(
            esUser["inner_hits"]["documents"]["hits"]["hits"],
          ),
          dateOfBirth: esUserSource["date_of_birth"],
          emails: esUserSource["emails"]?.split(","));
      users.add(user);
    }
    return users;
  }

  List<Document> getDocumentsFromInnerHits(documents) {
    List<Document> userDocuments = [];
    for (var document in documents) {
      var documentInformation = document['_source'];
      userDocuments.add(Document(
          data: documentInformation['data'],
          dataType: documentInformation['data_type'],
          title: documentInformation['title']));
    }
    return userDocuments;
  }
}
