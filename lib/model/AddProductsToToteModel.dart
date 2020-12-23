import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:warehouse_management_system/helper/AppSharedPref.dart';
import 'package:warehouse_management_system/helper/Utils.dart';
import 'package:warehouse_management_system/network/ApiCall.dart';
import 'package:warehouse_management_system/network/Constant.dart';
import 'package:warehouse_management_system/network/GetResponse.dart';

import 'EachProduct.dart';

class AddProductToToteModel extends Model with GetResponse {
  BuildContext context;
  bool processing = false;

  int selectedProductPosition = -1;
  EachProduct selectedProduct = EachProduct();

  List<EachProduct> productList = List();

  void setNextProduct() {
    selectedProduct = productList[++selectedProductPosition];
    selectedProduct.setFormattedQty();
    notifyListeners();
  }

  void setProductScanned() {
    selectedProduct.isProductScanned = true;
    notifyListeners();
  }

  void setSelectedQty(int qty) {
    selectedProduct.selectedQty = qty;
    selectedProduct.formattedQty = selectedProduct.selectedQty.toString() +
        "/" +
        selectedProduct.qty.toString();
    notifyListeners();
  }

  changeOrderStatus(BuildContext context, String incrementId) async {
    this.context = context;
    processing = true;
    notifyListeners();
    AppSharedPref.getStaffToken().then((value) {
      var body = {
        "staffToken": value,
        "incrementId": incrementId,
        "status": "picked"
      };
      ApiCall.makeCall(
          Constant.METHOD_POST, Constant.CHANGE_ORDER_STATUS, body, this);
    });
  }

  @override
  void getResponse(String response) {
    processing = false;
    notifyListeners();
    try {
      Map responseMap = json.decode(response);
      if (responseMap["success"]) {
        Navigator.pop(context, "completed");
      } else {
        Utils.showToastNotification(responseMap["message"]);
      }
    } catch (e) {
      print(e);
    }
  }
}
