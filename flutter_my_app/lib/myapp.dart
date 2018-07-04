import 'package:flutter/material.dart';
import 'package:flutter_my_app/view/ItemList.dart';

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
