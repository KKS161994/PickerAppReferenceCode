import 'package:scoped_model/scoped_model.dart';

import 'EachTote.dart';

class EachOrder extends Model {
  int qty = 1;
  String status = "";
  String incrementId = "";
  List<EachTote> toteList = List();

  EachOrder({
    this.qty,
    this.status,
    this.incrementId,
    this.toteList,
  });

  String getToteString() {
    String toteString = "";
    toteList.forEach((eachTote) {
      if (toteString.isEmpty) {
        toteString = eachTote.assigned_tote_title == null
            ? ""
            : eachTote.assigned_tote_title;
      } else {
        toteString += ", ";
        toteString += eachTote.assigned_tote_title == null
            ? ""
            : eachTote.assigned_tote_title;
      }
    });
    return toteString;
  }
}
