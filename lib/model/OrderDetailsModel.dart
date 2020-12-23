import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:warehouse_management_system/helper/AppPathConstants.dart';
import 'package:warehouse_management_system/helper/AppSharedPref.dart';
import 'package:warehouse_management_system/helper/Utils.dart';
import 'package:warehouse_management_system/network/ApiCall.dart';
import 'package:warehouse_management_system/network/Constant.dart';
import 'package:warehouse_management_system/network/GetResponse.dart';

import 'EachLocation.dart';
import 'EachProduct.dart';
import 'EachTote.dart';

class OrderDetailsModel extends Model with GetResponse {
  BuildContext context;
  bool processing = false;
  String api = "";

  String listFor = "create";
  String toteToken = "";
  String incrementId = "";

  String status = "";
  List<EachProduct> productList = List();
  List<EachTote> toteList = List();

  getOrderDetailsData(BuildContext context) async {
    this.context = context;
    processing = true;
    notifyListeners();
    api = Constant.GET_ORDER_DETAILS;
    AppSharedPref.getStaffToken().then((value) {
      var body = {
        "staffToken": value,
        if (listFor == "create")
          "incrementId": incrementId
        else
          "toteToken": toteToken,
        "width": MediaQuery.of(context).size.width
      };
      ApiCall.makeCall(Constant.METHOD_GET, api, body, this);
    });
  }

  addToteToModel(BuildContext context) async {
    this.context = context;
    processing = true;
    notifyListeners();
    api = Constant.ADD_TOTE_TO_ORDER;
    AppSharedPref.getStaffToken().then((value) {
      var body = {
        "staffToken": value,
        "incrementId": incrementId,
        "toteToken": toteToken
      };
      print("======>");
      ApiCall.makeCall(Constant.METHOD_POST, api, body, this);

    });
  }

  changeOrderStatus(BuildContext context, String incrementId) async {
    this.context = context;
    processing = true;
    notifyListeners();
    api = Constant.CHANGE_ORDER_STATUS;
    AppSharedPref.getStaffToken().then((value) {
      var body = {
        "staffToken": value,
        "incrementId": incrementId,
        "status": "packed"
      };
      ApiCall.makeCall(Constant.METHOD_POST, api, body, this);
    });
  }

  @override
  void getResponse(String response) {
    processing = false;
    notifyListeners();
    try {
      Map responseMap = json.decode(response);
      if (responseMap["success"]) {
        switch (api) {
          case Constant.GET_ORDER_DETAILS:
            {
              incrementId = responseMap["incrementId"].toString();
              status = responseMap["status"];
              intiModelValues(responseMap);
              if (listFor == "verify") {
                Navigator.of(context).pushNamed(verifyRoute, arguments: this);
              }
            }
            break;
          case Constant.ADD_TOTE_TO_ORDER:
            {
              Utils.showToastNotification(responseMap["message"]);
              EachTote toteData = new EachTote(
                order_id: "",
                assigned_tote_title: responseMap["toteName"],
              );
              addToteToList(toteData);
            }
            break;
          case Constant.CHANGE_ORDER_STATUS:
            {
              Utils.showToastNotification(responseMap["message"]);
              setStatus("packed");
            }
            break;
        }
      } else {
        Utils.showToastNotification(responseMap["message"]);
      }
    } catch (e) {
      print(e);
    }
  }

  void intiModelValues(Map responseMap) {
    setProductList(responseMap["productList"]);
    setToteList(responseMap["toteList"]);
  }

  void setProductList(List<dynamic> productListMap) {
    if (productListMap != null && productListMap.length > 0) {
      productListMap.forEach(
        (productData) {
          addDataToList(productData);
        },
      );
    }
  }

  void addDataToList(dynamic productData) {
    List<EachLocation> locationList = List();
    if (productData["location"] != null && productData["location"].length > 0) {
      productData["location"].forEach((eachLocation) {
        locationList.add(EachLocation(
          row: eachLocation["row"].toString(),
          rack: eachLocation["rack"].toString(),
          shelf: eachLocation["shelf"].toString(),
          column: eachLocation["column"].toString(),
        ));
      });
    }
    productList.add(
      EachProduct(
        qty: productData["qty"],
        sku: productData["sku"].toString(),
        name: productData["name"].toString(),
        thumbNail: productData["thumbNail"].toString(),
        location: locationList,
      ),
    );
  }

  void setToteList(List<dynamic> toteListMap) {
    if (toteListMap != null && toteListMap.length > 0) {
      toteListMap.forEach(
        (toteData) {
          toteList.add(EachTote(
            order_id: toteData["order_id"].toString(),
            assigned_tote_title: toteData["assigned_tote_title"].toString(),
          ));
        },
      );
    }
  }

  void addToteToList(EachTote toteData) {
    toteList.add(toteData);
    notifyListeners();
  }

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

  void setStatus(String status) {
    this.status = status;
    notifyListeners();
  }
}
