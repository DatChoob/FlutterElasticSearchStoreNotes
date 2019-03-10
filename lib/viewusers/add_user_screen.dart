import 'dart:io';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../elasticsearch/models.dart';
import '../firebase/firebase_client.dart';

class AddUserContactInfoScreen extends StatefulWidget {
  final String mode;
  final User user;

  AddUserContactInfoScreen({Key key, this.mode, this.user}) : super(key: key);

  _AddUserContactInfoScreenState createState() =>
      _AddUserContactInfoScreenState();
}

class _AddUserContactInfoScreenState extends State<AddUserContactInfoScreen> {
  User user;

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      user = widget.user;
    } else {
      user = User();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.mode == "add" ? 'Add User' : "Edit User"),
        ),
        body: ListView(children: [CreateUser(user: user, mode: widget.mode)]));
  }
}

class CreateUser extends StatefulWidget {
  CreateUser({Key key, @required this.user, @required this.mode})
      : super(key: key);
  final User user;
  final String mode;

  @override
  _CreateUserState createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  final _formKey = GlobalKey<FormState>();
  File _image;

  getImage() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 400, maxWidth: 400);
    setState(() => _image = image);
  }

  ImageProvider _getCurrentImage() {
    const dogImageURL =
        "https://www.doginni.cz/front_path/images/dog_circle.png";
    return _image != null
        ? FileImage(_image)
        : widget.user.imageURL != null
            ? NetworkImage(widget.user.imageURL)
            : AssetImage('assets/dog.png');
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 20.0, bottom: 20),
              child: GestureDetector(
                onTap: getImage,
                child: Column(
                  children: <Widget>[
                    Container(
                        height: 300,
                        width: 300,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.fill, image: _getCurrentImage()))),
                    Container(
                        margin: const EdgeInsets.only(top: 20.0),
                        child: Text("Click To Select Image"))
                  ],
                ),
              ),
            ),
          ),
          TextFormField(
              initialValue: widget.user.name,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  icon: const Icon(Icons.person),
                  hintText: 'Enter the first and last name',
                  labelText: 'Name *'),
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
          DateTimePickerFormField(
            initialValue: widget.user.dateOfBirth,
            inputType: InputType.date,
            format: DateFormat('MM-dd-yyyy'),
            decoration: InputDecoration(
                icon: const Icon(Icons.calendar_today),
                hintText: 'Enter the date of birth',
                labelText: 'Dob'),
            onChanged: (dt) => setState(() => widget.user.dateOfBirth = dt),
          ),
          TextFormField(
            initialValue: widget.user.address,
            decoration: const InputDecoration(
              icon: const Icon(Icons.location_city),
              hintText: 'Where does this person live',
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

                      widget.mode == "add"
                          ? FirebaseClient.createUser(widget.user, _image)
                          : FirebaseClient.updateUser(widget.user, _image);
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
