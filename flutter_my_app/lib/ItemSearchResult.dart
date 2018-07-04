import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class ItemSearchResult {
  String title;
  String thumbnailUrl;
  String authors;
  String publisher;
  String publishedDate;
  String number;

  ItemSearchResult({this.title, this.thumbnailUrl, this.authors, this.publisher, this.publishedDate, this.number});

  static fromJson(jsonV) {
    final data = json.decode(jsonV);
    List<Map<String, Object>> itemList = data['items'];


    return itemList.map((item) {
      final itemSearchResult = new ItemSearchResult();
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

Future<List<ItemSearchResult>> fetchItemSearchResult(http.Client client) async {
  final response =
  await client.get('https://www.googleapis.com/books/v1/volumes?q=one+piece');

  return compute(parseItemSearchResult, response.body);
}
List<ItemSearchResult> parseItemSearchResult(String responseBody) {
  return ItemSearchResult.fromJson(responseBody);
}