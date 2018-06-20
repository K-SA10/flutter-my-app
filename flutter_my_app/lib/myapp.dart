import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      home: new ItemListView(),
    );
  }
}

class ItemListView extends StatefulWidget {
  @override
  createState() => new ItemListViewState();
}

class ItemListViewState extends State<ItemListView> {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Buy List Search'),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.add),
            onPressed: null
          ),
        ],
      ),
      body: new Center(
        child: new Column(
          children: <Widget>[
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

            new Flexible(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Text(
                    'body',
                    style: Theme.of(context).textTheme.display1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}