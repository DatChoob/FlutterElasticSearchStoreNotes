import 'package:my_app/search/user_search_card.dart';

import '../elasticsearch/elasticsearchclient.dart';
import '../elasticsearch/models.dart';
import 'package:flutter/material.dart';

class SearchInformation extends StatefulWidget {
  @override
  _SearchInformationState createState() => _SearchInformationState();
}

class _SearchInformationState extends State<SearchInformation> {
  String _searchKeywords = "";

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Row(
        children: <Widget>[
          Flexible(
              child: TextFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.search),
              hintText: 'Search For Information',
              labelText: 'Search',
            ),
            onFieldSubmitted: (String value) {
              setState(() {
                _searchKeywords = value;
              });
            },
          ))
        ],
      ),
      Flexible(
          child: FutureBuilder(
              future: ElasticSearchClient().searchByKeywords(_searchKeywords),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data != null) {
                    return _createUserCards(snapshot.data);
                  } else {
                    return Container(child: Text("No Data Returned"));
                  }
                } else {
                  return CircularProgressIndicator();
                }
              }))
    ]);
  }

  Widget _createUserCards(snapshotData) {
    if (snapshotData.length == 0) {
      return Text("No Results Found");
    } else {
      List<Widget> widgets = [];
      for (User user in snapshotData) {
        widgets.add(UserSearchCard(user: user));
      }
      return ListView(children: widgets);
    }
  }
}
