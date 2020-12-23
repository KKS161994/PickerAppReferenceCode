import 'package:scoped_model/scoped_model.dart';

import 'EachLocation.dart';

class EachProduct extends Model {
  int qty = 1;
  String sku = "";
  String name = "";
  String thumbNail = "";
  List<EachLocation> location = List();

  bool isProductScanned = false;
  int selectedQty = 0;
  String formattedQty = "";

  EachProduct({
    this.qty,
    this.sku,
    this.name,
    this.thumbNail,
    this.location,
  });

  String setFormattedQty() {
    formattedQty = selectedQty.toString() + "/" + qty.toString();
    notifyListeners();
  }
}
