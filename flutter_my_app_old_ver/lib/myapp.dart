import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

final googleSignIn = new GoogleSignIn();
final auth = FirebaseAuth.instance;
final reference = FirebaseDatabase.instance.reference().child('todo');

class Item {
  String title;
  String name;
//  int number;       // 巻数
  String number;       // 巻数
  String gazou;     // サムネイル画像URL
//  int hyouka;       // 自己評価
  String hyouka;       // 自己評価
  String category;  // マンガ、小説...etc
  String group;     // 本のシリーズ名等（ユーザ任意）
  String publishedDate;
  String isbn13;    // ISBNコード（バーコード）
  String memo;

  Item(this.title, this.name, this.number,
      this.gazou, this.hyouka, this.category,
      this.group, this.publishedDate, this.isbn13,
      this.memo);

}
class ItemSearchResult {
  final String title;
  final String thumbnailUrl;

  ItemSearchResult({this.title, this.thumbnailUrl});

  factory ItemSearchResult.fromJson(Map<String, dynamic> json) {
    return new ItemSearchResult(
      title: json['title'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
    );
  }
}

class ItemSearchResult2 {
  String title;
  String thumbnailUrl;
  String authors;
  String publisher;
  String publishedDate;
  String number;

  ItemSearchResult2({this.title, this.thumbnailUrl, this.authors, this.publisher, this.publishedDate, this.number});

  static fromJson(jsonV) {
    final data = json.decode(jsonV);
    List<Map<String, Object>> itemList = data['items'];


    return itemList.map((item) {
      final itemSearchResult = new ItemSearchResult2();
      Map<String, Object> volumeInfoMap = item['volumeInfo'];
      Map<String, Object> urlMap = volumeInfoMap['imageLinks'];
      Map<String, Object> seriesInfoMap = volumeInfoMap['seriesInfo'];
      List<String> authorsList = seriesInfoMap != null ? seriesInfoMap['authors'] : null;

      itemSearchResult.title = volumeInfoMap['title'];
//      itemSearchResult.authors = volumeInfoMap['authors'];
      itemSearchResult.publisher = authorsList != null ? authorsList[0] : null;
      itemSearchResult.publishedDate = volumeInfoMap['publishedDate'];
      itemSearchResult.thumbnailUrl = urlMap != null ? urlMap['smallThumbnail'] : null;
      itemSearchResult.number = seriesInfoMap != null ? seriesInfoMap['bookDisplayNumber'] : null;

      return itemSearchResult;
    }).toList();
  }
}

Future<List<ItemSearchResult2>> fetchItemSearchResult2(http.Client client) async {
  final response =
    await client.get('https://www.googleapis.com/books/v1/volumes?q=one+piece');

  return compute(parseItemSearchResult2, response.body);
}
List<ItemSearchResult2> parseItemSearchResult2(String responseBody) {
  return ItemSearchResult2.fromJson(responseBody);
}

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Startup Name Generator',
      home: new ItemListView(),
    );
  }
}

class AddView extends StatefulWidget {
  @override
  createState() => new AddViewState();
}
class AddViewState extends State<AddView> {
  List<ItemSearchResult2> _itemSearchResult2;

  final TextEditingController _textController = new TextEditingController();
  final TextEditingController _textController2 = new TextEditingController();

  String gazou = null;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Add Buy List'),
          actions: <Widget>[
            new FlatButton(
              child: new Text('ADD',style: new TextStyle(fontSize: 32.0)),
              textColor: Colors.amber.shade900,
              onPressed: _handlePushAdd,
            ),
          ],
        ),
        body:
            new ListView(
              children: <Widget>[
                _buildTextComposer(),
              ],
            )
    );
  }

  Widget _buildTextComposer() {
    return new Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: new Column(
        children: <Widget>[
          new Container(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Text('Picture'),
                gazou != null ?
                  new Image.network(gazou) :
                  new Image.asset(
                    'images/lake.jpg',
                    width: 40.0,
                    height: 40.0,
                  ),
              ],
            ),
          ),
          new Container(
            child: new Row(
              children: <Widget>[
                new Flexible(
                    child: new TextField(
                        style: new TextStyle(fontSize: 32.0, color: Colors.black),
                        controller: _textController,
                        onSubmitted: null,
                        decoration:
                        new InputDecoration(hintText: 'Item Name',labelText: 'Item Name')
                    )
                ),
                new IconButton(
                    icon: new Icon(Icons.search),
                    onPressed: () => _handleSubmitted('aaa'),
                ),
              ],
            ),
          ),
          new Container(
            child: new Row(
              children: <Widget>[
                new Flexible(
                    child: new TextField(
                        style: new TextStyle(fontSize: 32.0, color: Colors.black),
                        controller: _textController2,
                        onSubmitted: null,
                        decoration:
                        new InputDecoration(hintText: 'How many',labelText: 'How many1')
                    )
                ),
              ],
            ),
          ),
          new Container(
            child: new Row(
              children: <Widget>[
                new Flexible(
                    child: new TextField(
                        style: new TextStyle(fontSize: 32.0, color: Colors.black),
                        controller: _textController2,
                        onSubmitted: null,
                        decoration:
                        new InputDecoration(hintText: 'How many',labelText: 'How many2')
                    )
                ),
              ],
            ),
          ),
          new Container(
            child: new Row(
              children: <Widget>[
                new Flexible(
                    child: new TextField(
                        style: new TextStyle(fontSize: 32.0, color: Colors.black),
                        controller: _textController2,
                        onSubmitted: null,
                        decoration:
                        new InputDecoration(hintText: 'How many',labelText: 'How many3')
                    )
                ),
              ],
            ),
          ),
          new Container(
            child: new Row(
              children: <Widget>[
                new Flexible(
                    child: new TextField(
                        style: new TextStyle(fontSize: 32.0, color: Colors.black),
                        controller: _textController2,
                        onSubmitted: null,
                        decoration:
                        new InputDecoration(hintText: 'How many',labelText: 'How many4')
                    )
                ),
              ],
            ),
          ),
          new Container(
            child: new Row(
              children: <Widget>[
                new Flexible(
                    child: new TextField(
                        style: new TextStyle(fontSize: 32.0, color: Colors.black),
                        controller: _textController2,
                        onSubmitted: null,
                        decoration:
                        new InputDecoration(hintText: 'How many',labelText: 'How many5')
                    )
                ),
              ],
            ),
          ),
          new Container(
            child: new Row(
              children: <Widget>[
                new Flexible(
                    child: new TextField(
                        style: new TextStyle(fontSize: 32.0, color: Colors.black),
                        controller: _textController2,
                        onSubmitted: null,
                        decoration:
                        new InputDecoration(hintText: 'How many',labelText: 'How many6')
                    )
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleSubmitted(String text) async {
    await fetchItemSearchResult2(new http.Client()).then((result) {
      setState(() {
        _itemSearchResult2 = result;
      });
    });
    final result = await Navigator.push(
        context,
        new MaterialPageRoute(builder: (context) => new SearchResultView(itemSearchResult2: _itemSearchResult2)),
    );

    setState(
            () {
          _textController.text = result[0] != null ? result[0] : 'No Picture';
          _textController2.text = result[1] != null ? result[1] : '';
          gazou = result[2] != null ? result[2] : null;
        }
    );

  }

  Future<Null> _handlePushAdd() async {
    await _ensureLoggedIn();
    _pushAdd();
  }

  void _pushAdd() {
    Navigator.pop(context);
    reference.push().set({
      'title': _textController.text,
      'name': _textController.text,
      'number': "0",
      'gazou': gazou,
      'hyouka': "0",
      'category': null,
      'group': null,
      'publishedDate': '2018/4/20',
      'isbn13': '4987654321012',
      'memo':null,
    });
    _textController.clear();
  }
}

class ItemDetailView extends StatefulWidget {
  DataSnapshot item;
  ItemDetailView({Key key, @required this.item}) : super(key: key);

  @override
  createState() => new ItemDetailViewState(item: item);
}

class ItemDetailViewState extends State<ItemDetailView> {
//  Item item;
  DataSnapshot item;

  TextEditingController _textController;
  TextEditingController _textController2;
  TextEditingController _textController3;
  TextEditingController _textController4;
  TextEditingController _textController5;

  ItemDetailViewState({Key key, @required this.item});

  @override
  void initState() {
    super.initState();
    _textController = new TextEditingController(text: item.value['name']);
    _textController2 = new TextEditingController(text: item.value['number']);
    _textController3 = new TextEditingController(text: item.value['hyouka']);
    _textController4 = new TextEditingController(text: item.value['publishedDate']);
    _textController5 = new TextEditingController(text: item.value['memo']);

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Detail View ${item.value['item']}'),
        actions: <Widget>[
          new FlatButton(
            child: new Text('UPDATE', style: new TextStyle(fontSize: 32.0)),
            onPressed: () => _pushUpdate(item),
          ),
        ],
      ),
      body: content(),
    );
  }
  Widget content() {
    return new ListView(
      padding: new EdgeInsets.all(16.0),
      children: <Widget>[
        new Image.network(item.value['gazou']),
        new Container(
          child: new TextField(
              style: new TextStyle(fontSize: 32.0, color: Colors.black),
              controller: _textController,
              onSubmitted: _handleSubmitted,
              decoration:
              new InputDecoration(hintText: 'Item Name',labelText: 'Item Name')
          ),
        ),
        new TextField(
            style: new TextStyle(fontSize: 32.0, color: Colors.black),
            controller: _textController2,
            onSubmitted: _handleSubmitted,
            decoration:
            new InputDecoration(hintText: 'How many',labelText: 'How many')
        ),
        new TextField(
            style: new TextStyle(fontSize: 32.0, color: Colors.black),
            controller: _textController3,
            onSubmitted: _handleSubmitted,
            decoration:
            new InputDecoration(hintText: 'Star',labelText: 'Star')
        ),
        new TextField(
            style: new TextStyle(fontSize: 32.0, color: Colors.black),
            controller: _textController4,
            onSubmitted: _handleSubmitted,
            decoration:
            new InputDecoration(hintText: 'Published Date',labelText: 'Published Date')
        ),
        new TextField(
            style: new TextStyle(fontSize: 32.0, color: Colors.black),
            maxLines: 3,
            controller: _textController5,
            onSubmitted: _handleSubmitted,
            decoration:
            new InputDecoration(hintText: 'Memo',labelText: 'Memo')
        ),
      ],
    );
  }

  void _handleSubmitted(String text) {

  }

  void _pushUpdate(DataSnapshot item) {
    Navigator.pop(context);
    reference.child(item.key).set({
      "title": _textController.text,
      "name": _textController.text,
      "number": _textController2.text,
      "gazou": item.value['gazou'],
      "hyouka": _textController3.text,
      'category': item.value['category'],
      'group': item.value['group'],
      "publishedDate": _textController4.text,
      'isbn13': item.value['isbn13'],
      'memo': item.value['memo'],
    });
  }
}




Future<Null> _ensureLoggedIn() async {
  GoogleSignInAccount user = googleSignIn.currentUser;
  if (user == null)
    user = await googleSignIn.signInSilently();
  if (user == null) {
    await googleSignIn.signIn();
  }
  if (await auth.currentUser() == null) {
    GoogleSignInAuthentication credentials =
    await googleSignIn.currentUser.authentication;
    await auth.signInWithGoogle(
      idToken: credentials.idToken,
      accessToken: credentials.accessToken,
    );
  }
}




class ItemListView extends StatefulWidget {
  @override
  createState() => new ItemListViewState();
}

class ItemListViewState extends State<ItemListView> with TickerProviderStateMixin {
  final List<Item> items = <Item>[];
  List<ItemSearchResult> _itemSearchResult2;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _textController = new TextEditingController();

  AnimationController _controller;
  Animation<double> _drawerContentsOpacity;

  @override
  void initState() {
    super.initState();

    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _drawerContentsOpacity = new CurvedAnimation(
      parent: new ReverseAnimation(_controller),
      curve: Curves.fastOutSlowIn,
    );
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text('Buy List Search'),
        bottom: new PreferredSize(
            preferredSize: const Size.fromHeight(48.0),
            child: new Theme(
              data: Theme.of(context).copyWith(
                  accentColor: Colors.white,
                bottomAppBarColor: Colors.white
              ),
              child: new Container(
                child: new Row(
                  children: <Widget>[
                    new IconButton(icon: new Icon(Icons.search), onPressed: null),
                    new Flexible(
                        child: new TextField(
                          controller: _textController,
                          onSubmitted: null,
                          decoration: new InputDecoration(labelText: 'label')
                        )
                    ),
                    new IconButton(icon: new Icon(Icons.camera_alt), onPressed: null),
                  ],
                ),
              )
            )
        ),
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.add),
              onPressed: () {
                _pushAddView(context);
              }
          ),
        ],
      ),
      drawer: new Drawer(
        child: new ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            new Container(
              padding: const EdgeInsets.fromLTRB(0.0, 32.0, 16.0, 8.0),
              height: 80.0,
              child: new ListTile(
                leading: new CircleAvatar(
                    child: new Text('N'),
                    backgroundColor: Colors.grey,
                ),
                title: new Text(googleSignIn.currentUser != null ? googleSignIn.currentUser.displayName : 'N/A'),
              ),
              decoration: new BoxDecoration(
                color: Colors.black54,
              ),
            ),

            new ListTile(
              leading: new Icon(Icons.book),
              title: new Text('Book'),
            ),
            new ListTile(
              leading: new Icon(Icons.movie),
              title: new Text('Movie'),
            ),
            new Divider(
              color: Colors.black45,
              indent: 16.0,
            ),
            new ListTile(
              leading: new Icon(Icons.settings),
              title: new Text('Settings'),
            ),
            new Divider(
              color: Colors.black45,
              indent: 16.0,
            ),
            new ListTile(
              title: new Text('About us'),
            ),
            new ListTile(
            title: new Text('Privacy'),
            ),
          ],
        ),
      ),
      body: _list(),
    );
  }
  _pushAddView(BuildContext context) async {
    try {
      final result = await Navigator.push(
        context,
        new MaterialPageRoute(builder: (context) => new AddView()),
      );
      if (result != null) items.add(result);
    } catch (exception) {
      return null;
    }
  }

  Widget _list() {
    return new Column(
      children: <Widget>[
        new Flexible(
          child: new FirebaseAnimatedList(
            query: reference,
            sort: (a, b) => a.key.compareTo(b.key),
            padding: new EdgeInsets.all(8.0),
            itemBuilder: (_, DataSnapshot snapshot, Animation<double> animation) {
              return new ListTile(
                title: new Container(
                  child: new Row(
                    children: <Widget>[
                      new Expanded(
                        child: new Image.network(snapshot.value['gazou']),
                      ),
                      new Expanded(
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Text(snapshot.value['title']),
//                            new Text(snapshot.value['name']),
//                            new Text(snapshot.value['number']),
                          ],
                        ),
                      ),
                    ],
                  )
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(builder: (context) => new ItemDetailView(item: snapshot)),
                  );
                },
              );
            }
          )
        )
      ],
    );
  }

  Icon createNumberIcon(int number, int n) {
    return new Icon(
        number >= n ? Icons.star : Icons.star_border,
        color: number >= n ? Colors.black : Colors.black,
    );
  }
}

class SearchResultView extends StatefulWidget {
  SearchResultView({Key key, @required this.itemSearchResult2}) : super(key: key);

  final List<ItemSearchResult2> itemSearchResult2;

  @override
  createState() => new SearchResultViewState(itemSearchResult2: itemSearchResult2);
}

class SearchResultViewState extends State<SearchResultView> {
  SearchResultViewState({Key key, @required this.itemSearchResult2});

  List<ItemSearchResult2> itemSearchResult2;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('SearchResultViewState'),
      ),
      body: _searchResultSection(itemSearchResult2),
    );
  }

  Widget _searchResultSection(List<ItemSearchResult2> itemSearchResult2List) {
    if (itemSearchResult2List == null) return null;

    return new GridView.builder(
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2
      ),
      itemCount: itemSearchResult2List.length,
      itemBuilder: (context, index) {

        return new ListTile(
          title: itemSearchResult2List[index].thumbnailUrl != null ?
                    new Image.network(itemSearchResult2List[index].thumbnailUrl) :
                    new Text('No Picture'),
          onTap: () {

            List<String> result = <String>[
              itemSearchResult2List[index].title != null ? itemSearchResult2List[index].title : 'No Picture',
              itemSearchResult2List[index].number != null ? itemSearchResult2List[index].number : '',
              itemSearchResult2List[index].thumbnailUrl != null ? itemSearchResult2List[index].thumbnailUrl : '',
            ];

            Navigator.pop(context, result);

          },
        );
      },
    );
  }
}
