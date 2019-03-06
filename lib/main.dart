import 'package:flutter/material.dart';
import 'elasticsearch/elasticsearchclient.dart';
import 'elasticsearch/models.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  final _widgetOptions = [
    Text('Index 0: Home'),
    SearchInformation(),
    Text('Index 2: School'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Home')),
          BottomNavigationBarItem(
              icon: Icon(Icons.search), title: Text('Search')),
          BottomNavigationBarItem(
              icon: Icon(Icons.school), title: Text('School')),
        ],
        currentIndex: _selectedIndex,
        fixedColor: Colors.deepPurple,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

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
                    return _getData(snapshot.data);
                  } else {
                    return new CircularProgressIndicator();
                  }
                }
              }))
    ]);
  }

  Widget _getData(snapshotData) {
    print(snapshotData);
    if (snapshotData.length == 0) {
      return Text("No Results Found");
    } else {
      List<Widget> widgets = [];
      for (User user in snapshotData) {
        print(user.name);
        widgets.add(UserSearchCard(user: user));
      }
      return ListView(
          // shrinkWrap: true,
          // padding: const EdgeInsets.all(20.0),
          children: widgets);
    }
  }
}

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
