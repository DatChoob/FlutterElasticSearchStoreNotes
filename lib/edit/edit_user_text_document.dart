import 'package:flutter/material.dart';
import 'package:my_app/elasticsearch/elasticsearchclient.dart';
import 'package:my_app/elasticsearch/models.dart';

class EditUserTextDocumentScreen extends StatefulWidget {
  final User user;
  final Document document;

  EditUserTextDocumentScreen({this.user, this.document});

  @override
  _EditUserTextDocumentScreenState createState() =>
      _EditUserTextDocumentScreenState();
}

class _EditUserTextDocumentScreenState
    extends State<EditUserTextDocumentScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            tooltip: 'Save Document',
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                for (Document doc in widget.user.documents) {
                  if (doc.documentID == widget.document.documentID) {
                    doc.data = widget.document.data;
                    break;
                  }
                }
                Navigator.pop(context,
                    await ElasticSearchClient().updateUser(widget.user));
              }
            },
          )
        ], title: Text(widget.document.title)),
        body: EditUserTextDocument(
            user: widget.user, document: widget.document, formKey: _formKey));
  }
}

class EditUserTextDocument extends StatefulWidget {
  final User user;
  final Document document;
  final formKey;
  EditUserTextDocument({this.user, this.document, this.formKey});
  @override
  _EditUserTextDocumentState createState() => _EditUserTextDocumentState();
}

class _EditUserTextDocumentState extends State<EditUserTextDocument> {
  @override
  Widget build(BuildContext context) {
    return ListView(children: <Widget>[
      Form(
          key: widget.formKey,
          autovalidate: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  initialValue: widget.document.data,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                  },
                  onSaved: (value) => widget.document.data = value)
            ],
          ))
    ]);
  }
}
