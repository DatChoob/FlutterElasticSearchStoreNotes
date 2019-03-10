import 'package:flutter/material.dart';
import 'package:my_app/elasticsearch/models.dart';
import 'package:my_app/viewusers/add_user_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:transparent_image/transparent_image.dart';

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
                                    AddUserContactInfoScreen(mode: 'add'),
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
              scrollDirection: Axis.horizontal,
              crossAxisCount: 3,
              childAspectRatio: 1.0,
              padding: const EdgeInsets.all(4.0),
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
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
      child: GridTile(
          footer: GridTileBar(
            subtitle: Center(child: Text(user.name)),
          ),
          child: _getImageOfUser()),
    );
  }

  Widget _getImageOfUser() {
    if (user.imageURL != null) {
      return Container(
          child: Stack(
        children: <Widget>[
          Center(child: CircularProgressIndicator()),
          Center(
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: user.imageURL,
            ),
          ),
        ],
      ));
    } else
      return Center(
        child: Container(
          width: 190.0,
          height: 190.0,
          child: CircleAvatar(
            backgroundColor: Colors.red,
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
