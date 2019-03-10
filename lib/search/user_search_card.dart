import 'package:flutter/material.dart';
import 'package:my_app/edit/edit_user_text_document.dart';
import 'package:my_app/viewusers/add_user_screen.dart';
import '../elasticsearch/models.dart';

class UserSearchCard extends StatefulWidget {
  UserSearchCard({
    Key key,
    @required this.user,
  }) : super(key: key);
  final User user;

  @override
  _UserSearchCardState createState() => _UserSearchCardState();
}

class _UserSearchCardState extends State<UserSearchCard> {
  bool _expansionPanelOpened = false;

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 3.0,
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          ListTile(
            //TODO: Fill this in with image of user
            leading: Icon(Icons.album),
            title: Text(widget.user.name),
            trailing: FlatButton(
              child: Icon(Icons.edit),
              onPressed: () async {
                var saved = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddUserContactInfoScreen(
                          user: widget.user, mode: 'edit'),
                    ));
                if (saved == true) {
                  Scaffold.of(context).showSnackBar(SnackBar(
                      content: Row(children: [
                    Text('User Data Saved! Please Refresh.'),
                  ])));
                }
              },
            ),
          ),
          _getExpansionPanelList()
        ]));
  }

  _getExpansionPanelList() {
    if (widget.user.documents.length > 0) {
      return ExpansionPanelList(
        children: [
          ExpansionPanel(
              body: _buildExpansionPanel(widget.user),
              headerBuilder: (context, isExpanded) {
                return Center(
                    child:
                        Text("See ${widget.user.documents.length} Documents "));
              },
              isExpanded: _expansionPanelOpened)
        ],
        expansionCallback: (index, isOpened) =>
            setState(() => _expansionPanelOpened = !_expansionPanelOpened),
      );
    } else {
      return ListTile(
          leading: Icon(Icons.block), title: Text("No Matching documents"));
    }
  }

  _buildExpansionPanel(User user) {
    return Column(
        children: user.documents.map((document) {
      if (document.dataType == "text") {
        return ListTile(
            leading: Icon(Icons.note),
            title: Text(document.title),
            onTap: () async {
              print(user.userID);
              print(document.documentID);
              var saved = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditUserTextDocumentScreen(
                        user: widget.user, document: document),
                  ));
              if (saved == true) {
                Scaffold.of(context).showSnackBar(SnackBar(
                    content: Row(children: [
                  Text('Document Saved!'),
                ])));
              }
            });
      }
    }).toList());
  }
}
