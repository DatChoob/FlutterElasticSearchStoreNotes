import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_app/elasticsearch/elasticsearchclient.dart';
import 'package:my_app/elasticsearch/models.dart';

class EditUserContactInfoScreen extends StatelessWidget {
  final User user;
  EditUserContactInfoScreen({this.user});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit User'),
        ),
        body: new EditUserForm(user: user));
  }
}

class EditUserForm extends StatefulWidget {
  EditUserForm({
    @required this.user,
  });
  final User user;
  @override
  _EditUserFormState createState() => _EditUserFormState();
}

class _EditUserFormState extends State<EditUserForm> {
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
              initialValue: widget.user.name,
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
              initialValue: widget.user.email,
              decoration: const InputDecoration(
                icon: const Icon(Icons.email),
                hintText: 'Enter a email address',
                labelText: 'Email',
              ),
              keyboardType: TextInputType.emailAddress,
              onSaved: (val) => widget.user.email = val),
          TextFormField(
              initialValue: widget.user.phoneNumber,
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
            initialValue: widget.user.dateOfBirth,
            decoration: const InputDecoration(
              icon: const Icon(Icons.calendar_today),
              hintText: 'Enter your date of birth',
              labelText: 'Dob',
            ),
            keyboardType: TextInputType.datetime,
            onSaved: (val) => widget.user.dateOfBirth = val,
          ),
          TextFormField(
            initialValue: widget.user.address,
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
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      await ElasticSearchClient().updateUser(widget.user);
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
