import 'package:flutter/material.dart';
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
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      ListTile(
        //TODO: Fill this in with image of user
        leading: Icon(Icons.album),
        title: Text(widget.user.name),
        trailing: FlatButton(
          child: Icon(Icons.edit),
          onPressed: () {
            /* Route user to new page to edit their personal info */
          },
        ),
      ),
      ExpansionPanelList(
        children: [
          ExpansionPanel(
              body: _buildExpansionPanel(widget.user),
              headerBuilder: (context, isExpanded) {
                return Center(child: Text("See Documents"));
              },
              isExpanded: _expansionPanelOpened)
        ],
        expansionCallback: (index, isOpened) =>
            setState(() => _expansionPanelOpened = !_expansionPanelOpened),
      )
    ]));
  }

  _buildExpansionPanel(User user) {
    return Text("dasdas");
  }
}
