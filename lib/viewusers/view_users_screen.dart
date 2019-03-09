import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_app/elasticsearch/models.dart';
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
      Row(
        children: <Widget>[
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
                            builder: (context) => AddUserContactInfoScreen(),
                          ));
                    },
                    icon: Icon(Icons.add))),
            onFieldSubmitted: (String value) {
              setState(() {
                _searchKeywords = value;
              });
            },
          ))
        ],
      )
    ]);
  }
}

class AddUserContactInfoScreen extends StatefulWidget {
  AddUserContactInfoScreen({Key key}) : super(key: key);

  _AddUserContactInfoScreenState createState() =>
      _AddUserContactInfoScreenState();
}

class _AddUserContactInfoScreenState extends State<AddUserContactInfoScreen> {
  final User user = User();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit User'),
        ),
        body: CreateUser(user: user));
  }
}

class CreateUser extends StatefulWidget {
  CreateUser({
    Key key,
    @required this.user,
  }) : super(key: key);
  final User user;

  @override
  _CreateUserState createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidate: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
              keyboardType: TextInputType.text,
              decoration: new InputDecoration(
                  icon: const Icon(Icons.person),
                  hintText: 'Enter your first and last name',
                  labelText: 'Name'),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
              },
              onSaved: (val) => widget.user.name = val),
          TextFormField(
              decoration: const InputDecoration(
                icon: const Icon(Icons.email),
                hintText: 'Enter a email address',
                labelText: 'Email',
              ),
              keyboardType: TextInputType.emailAddress,
              onSaved: (val) => widget.user.email = val),
          TextFormField(
              decoration: const InputDecoration(
                icon: const Icon(Icons.phone),
                hintText: 'Enter a phone number',
                labelText: 'Phone',
              ),
              keyboardType: TextInputType.phone,
              inputFormatters: [
                WhitelistingTextInputFormatter.digitsOnly,
              ],
              onSaved: (val) => widget.user.phoneNumber = val),
          TextFormField(
            decoration: const InputDecoration(
              icon: const Icon(Icons.calendar_today),
              hintText: 'Enter your date of birth',
              labelText: 'Dob',
            ),
            keyboardType: TextInputType.datetime,
            onSaved: (val) => widget.user.dateOfBirth = val,
          ),
          TextFormField(
            decoration: const InputDecoration(
              icon: const Icon(Icons.location_city),
              hintText: 'Where Do you live',
              labelText: 'Address',
            ),
            keyboardType: TextInputType.text,
            onSaved: (val) => widget.user.address = val,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: SizedBox(
                width: double.infinity,
                child: RaisedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      FirebaseClient().createUser(widget.user);
                      Navigator.pop(context, true);
                    }
                  },
                  child: Text('Submit'),
                )),
          ),
        ],
      ),
    );
  }
}

class FirebaseClient {
  void createUser(User user) {
    Firestore.instance
        .collection('users')
        .document()
        .setData(user.toFirebaseJson());
  }
}
