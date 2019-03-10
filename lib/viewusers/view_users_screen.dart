import 'package:flutter/material.dart';
import 'package:my_app/elasticsearch/models.dart';
import 'package:my_app/viewusers/add_user_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewUsersScreen extends StatefulWidget {
  @override
  _ViewUsersScreenState createState() => _ViewUsersScreenState();
}

class _ViewUsersScreenState extends State<ViewUsersScreen> {
  String _searchKeywords = "";
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Row(children: <Widget>[
        Flexible(
            child: TextFormField(
                decoration: InputDecoration(
                    icon: Icon(Icons.search),
                    hintText: 'Search For Information',
                    labelText: 'Search',
                    suffixIcon: IconButton(
                        onPressed: () async {
                          var saved = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    AddUserContactInfoScreen(),
                              ));
                        },
                        icon: Icon(Icons.add))),
                onFieldSubmitted: (String value) {
                  setState(() {
                    _searchKeywords = value;
                  });
                }))
      ]),
      Flexible(
          child: StreamBuilder(
        stream: Firestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: Text('No Data...'));
          } else {
            return GridView.count(
              primary: false,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(20.0),
              crossAxisSpacing: 10.0,
              crossAxisCount: 4,
              children: _usersToCards(snapshot.data),
            );
          }
        },
      ))
    ]);
  }

  List<Widget> _usersToCards(QuerySnapshot data) {
    return data.documents.map((documentSnapshot) {
      User user = User.fromFirebase(documentSnapshot.data);
      return UserCard(user);
    }).toList();
  }
}

class UserCard extends StatelessWidget {
  final User user;
  UserCard(this.user);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: _getImageOfUser(),
    );
  }

  Widget _getImageOfUser() {
    if (user.imageURL == null) {
      return Image.network(
        user.imageURL ??
            "https://www.doginni.cz/front_path/images/dog_circle.png",
        width: 100,
        height: 100,
      );
    } else
      return Center(
        child: Container(
          child: CircleAvatar(
            backgroundColor: Colors.red,
            radius: 60,
            child: Text(
              user.name[0].toUpperCase(),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w100,
                fontSize: 100,
              ),
            ),
          ),
        ),
      );
  }
}
