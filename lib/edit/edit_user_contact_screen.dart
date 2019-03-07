import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_app/elasticsearch/elasticsearchclient.dart';
import 'package:my_app/elasticsearch/models.dart';

class EditUserContactInfoScreen extends StatefulWidget {
  final User user;
  EditUserContactInfoScreen({this.user});

  @override
  _EditUserContactInfoScreenState createState() =>
      _EditUserContactInfoScreenState();
}

class _EditUserContactInfoScreenState extends State<EditUserContactInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit User'),
        ),
        body: new EditUserForm(user: widget.user));
  }
}

class EditUserForm extends StatelessWidget {
  EditUserForm({
    @required this.user,
  });

  final User user;
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
              enabled: true,
              initialValue: user.name,
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
              onSaved: (val) => user.name = val),
          TextFormField(
              initialValue: user.email,
              decoration: const InputDecoration(
                icon: const Icon(Icons.email),
                hintText: 'Enter a email address',
                labelText: 'Email',
              ),
              keyboardType: TextInputType.emailAddress,
              onSaved: (val) => user.email = val),
          TextFormField(
              initialValue: user.phoneNumber,
              decoration: const InputDecoration(
                icon: const Icon(Icons.phone),
                hintText: 'Enter a phone number',
                labelText: 'Phone',
              ),
              keyboardType: TextInputType.phone,
              inputFormatters: [
                WhitelistingTextInputFormatter.digitsOnly,
              ],
              onSaved: (val) => user.phoneNumber = val),
          TextFormField(
            initialValue: user.dateOfBirth,
            decoration: const InputDecoration(
              icon: const Icon(Icons.calendar_today),
              hintText: 'Enter your date of birth',
              labelText: 'Dob',
            ),
            keyboardType: TextInputType.datetime,
            onSaved: (val) => user.dateOfBirth = val,
          ),
          TextFormField(
            initialValue: user.address,
            decoration: const InputDecoration(
              icon: const Icon(Icons.location_city),
              hintText: 'Where Do you live',
              labelText: 'Address',
            ),
            keyboardType: TextInputType.text,
            onSaved: (val) => user.address = val,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: SizedBox(
                width: double.infinity,
                child: RaisedButton(
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      await ElasticSearchClient().updateUser(user);
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
