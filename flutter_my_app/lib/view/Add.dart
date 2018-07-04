import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter_my_app/GoogleSignIn.dart';
import 'package:flutter_my_app/view/ItemList.dart';
import 'package:flutter_my_app/ItemSearchResult.dart';
import 'package:firebase_database/firebase_database.dart';

final reference = FirebaseDatabase.instance.reference().child('todo');

// アイテム追加画面
class AddView extends StatefulWidget {
  @override
  createState() => new AddViewState();
}

class AddViewState extends State<AddView> {
  List<ItemSearchResult> _itemSearchResult;

  final TextEditingController _textController = new TextEditingController();
  final TextEditingController _textController2 = new TextEditingController();
  final TextEditingController _textController3 = new TextEditingController();
  final TextEditingController _textController4 = new TextEditingController();
  final TextEditingController _textController5 = new TextEditingController();
  final TextEditingController _textController6 = new TextEditingController();
  final TextEditingController _textController7 = new TextEditingController();
  String gazou = null;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Add Buy List'),
        actions: <Widget>[
          // アイテム追加処理を行うボタンを配置
          new FlatButton(
            onPressed: _handlePushAdd,
            child: new Text('ADD', style: new TextStyle(fontSize: 32.0)),
            textColor: Colors.amber.shade900,
          ),
        ],
      ),
      body: new ListView(
        children: <Widget>[
          _buildTextComposer(),
        ],
      ),
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
                // 画像を取得できたら表示、できなかったらダミー画像を表示
                gazou != null ? new Image.network(gazou)
                    : new Image.asset('images/lake.jpg', width: 40.0, height: 40.0,),
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
                        new InputDecoration(hintText: 'Number',labelText: 'Number')
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
                        controller: _textController3,
                        onSubmitted: null,
                        decoration:
                        new InputDecoration(hintText: 'Hyouka',labelText: 'Hyouka')
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
                        controller: _textController4,
                        onSubmitted: null,
                        decoration:
                        new InputDecoration(hintText: 'PublishedDate',labelText: 'PublishedDate')
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
                        controller: _textController5,
                        onSubmitted: null,
                        decoration:
                        new InputDecoration(hintText: 'Memo',labelText: 'Memo')
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
                        controller: _textController6,
                        onSubmitted: null,
                        decoration:
                        new InputDecoration(hintText: 'Category',labelText: 'Category')
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
                        controller: _textController7,
                        onSubmitted: null,
                        decoration:
                        new InputDecoration(hintText: 'Group',labelText: 'Group')
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
    await fetchItemSearchResult(new http.Client()).then((result) {
      setState(() {
        _itemSearchResult = result;
      });
    });
//    final result = await Navigator.push(
//      context,
//      new MaterialPageRoute(builder: (context) => new SearchResultView(itemSearchResult2: _itemSearchResult2)),
//    );
//
//    setState(
//            () {
//          _textController.text = result[0] != null ? result[0] : 'No Picture';
//          _textController2.text = result[1] != null ? result[1] : '';
//          gazou = result[2] != null ? result[2] : null;
//        }
//    );
  }

  Future<Null> _handlePushAdd() async {
//    await testSignInWithGoogle();
    await ensureLoggedIn();
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

//class ItemSearchResult {
//  String title;
//  String thumbnailUrl;
//  String authors;
//  String publisher;
//  String publishedDate;
//  String number;
//
//  ItemSearchResult({this.title, this.thumbnailUrl, this.authors, this.publisher, this.publishedDate, this.number});
//
//  static fromJson(jsonV) {
//    final data = json.decode(jsonV);
//    List<Map<String, Object>> itemList = data['items'];
//
//
//    return itemList.map((item) {
//      final itemSearchResult = new ItemSearchResult();
//      Map<String, Object> volumeInfoMap = item['volumeInfo'];
//      Map<String, Object> urlMap = volumeInfoMap['imageLinks'];
//      Map<String, Object> seriesInfoMap = volumeInfoMap['seriesInfo'];
//      List<String> authorsList = seriesInfoMap != null ? seriesInfoMap['authors'] : null;
//
//      itemSearchResult.title = volumeInfoMap['title'];
////      itemSearchResult.authors = volumeInfoMap['authors'];
//      itemSearchResult.publisher = authorsList != null ? authorsList[0] : null;
//      itemSearchResult.publishedDate = volumeInfoMap['publishedDate'];
//      itemSearchResult.thumbnailUrl = urlMap != null ? urlMap['smallThumbnail'] : null;
//      itemSearchResult.number = seriesInfoMap != null ? seriesInfoMap['bookDisplayNumber'] : null;
//
//      return itemSearchResult;
//    }).toList();
//  }
//}
//
//Future<List<ItemSearchResult>> fetchItemSearchResult(http.Client client) async {
//  final response =
//  await client.get('https://www.googleapis.com/books/v1/volumes?q=one+piece');
//
//  return compute(parseItemSearchResult, response.body);
//}
//List<ItemSearchResult> parseItemSearchResult(String responseBody) {
//  return ItemSearchResult.fromJson(responseBody);
//}