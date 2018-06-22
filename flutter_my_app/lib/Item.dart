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