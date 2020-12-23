import 'package:scoped_model/scoped_model.dart';

class EachLocation extends Model {
  String row = "";
  String rack = "";
  String shelf = "";
  String column = "";

  EachLocation({
    this.row,
    this.rack,
    this.shelf,
    this.column,
  });
}