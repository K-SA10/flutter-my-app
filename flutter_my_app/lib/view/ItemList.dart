import 'package:flutter/material.dart';
import 'package:flutter_my_app/GoogleSignIn.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter_my_app/view/Add.dart';
import 'package:flutter_my_app/Item.dart';

final reference = FirebaseDatabase.instance.reference().child('todo');

// メイン画面
class ItemListView extends StatefulWidget {
  @override
  createState() => new ItemListViewState();
}

// Itemリストを表示する
class ItemListViewState extends State<ItemListView> {
  final List<Item> items = <Item>[];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Buy List Search'),
        actions: <Widget>[
          // ヘッダーにItem追加用のボタンを配置
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
//                title: new Text(googleSignIn.currentUser != null ? googleSignIn.currentUser.displayName : 'N/A'),
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

      body: new Center(
        child: new Column(
          children: <Widget>[
            // 最上段にItemリストの検索用テキストフィールドを配置
            new Container(
              child: new Row(
                children: <Widget>[
                  new IconButton(icon: new Icon(Icons.search), onPressed: null),
                  new Flexible(
                      child: new TextField(
                        controller: null,
                        onSubmitted: null,
                        decoration: new InputDecoration(labelText: 'label'),
                      )
                  ),
                  new IconButton(icon: new Icon(Icons.camera_alt), onPressed: null),
                ],
              ),
            ),
            // 残りのスペースでItemリスト表示部を作成
            new Flexible(
//              child: new Column(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  new Text(
//                    'body',
//                    style: Theme.of(context).textTheme.display1,
//                  ),
//                ],
//              ),
              child: new FirebaseAnimatedList(
                query: reference,
                sort: (a, b) => a.key.compareTo(b.key),
                padding: new EdgeInsets.all(8.0),
                itemBuilder: (_, DataSnapshot snapshot, Animation<double> animation, int index) {
                  return new ListTile(
                    title: new Container(
                      child: new Row(
                        children: <Widget>[
                          new Expanded(
                            child: new Image.network(snapshot.value['gazou'])
                          ),
                          new Expanded(
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Text(snapshot.value['title']),
//                                new Text(snapshot.value['number']),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {

                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _pushAddView(BuildContext context) async {
    try {
      final result = await Navigator.push(
        context,
        new MaterialPageRoute(builder: (context) => new AddView())
      );
      if (result != null) items.add(result);
    } catch (exception) {
      return null;
    }
  }
}