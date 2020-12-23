import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:warehouse_management_system/helper/AppPathConstants.dart';
import 'package:warehouse_management_system/helper/AppSharedPref.dart';
import 'package:warehouse_management_system/helper/StringConstants.dart';
import 'package:warehouse_management_system/helper/Utils.dart';
import 'package:warehouse_management_system/network/ApiCall.dart';
import 'package:warehouse_management_system/network/Constant.dart';
import 'package:warehouse_management_system/network/GetResponse.dart';

import 'EachOrder.dart';
import 'EachOrderStatus.dart';
import 'EachTote.dart';

class OrderListModel extends Model with GetResponse {
  BuildContext context;
  bool processing = false;
  bool lazyLoading = false;
  String listFor = "create";

  String status = "";
  int pageNumber = 1;

  int totalCount = 1;
  List<EachOrder> orderList = List();
  List<EachOrderStatus> orderStatus = List();

  getOrderListData(BuildContext context, String searchQuery) async {
    this.context = context;
    if(lazyLoading){
      processing = false;
    }else{
      processing = true;
    }
    notifyListeners();
    AppSharedPref.getStaffToken().then((value) {
      var body = {
        "staffToken": value,
        "status": status,
        "pageNumber": pageNumber++,
        "searchQuery": searchQuery,
        "limit": 20
      };
      ApiCall.makeCall(
          Constant.METHOD_GET, Constant.GET_ORDER_LIST, body, this);
    });
  }

  @override
  void getResponse(String response) {
    processing = false;
    lazyLoading=false;
    try {
      Map responseMap = json.decode(response);
      if (responseMap["success"]) {
        intiModelValues(responseMap);
      } else {
        Utils.showToastNotification(responseMap["message"]);
        try {
          if (responseMap["sessionLogout"]) {
            AppSharedPref.setLogin(false);
            AppSharedPref.setStaffName(null);
            AppSharedPref.setStaffEmail(null);
            AppSharedPref.setStaffToken(null);
            AppSharedPref.setStaffAvatar(null);
            Navigator.of(context).pushNamed(loginRoute);
          }
        } catch (e) {
          debugPrint(e);
        }
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  void intiModelValues(Map responseMap) {
    totalCount = responseMap["totalCount"];
    setOrderList(responseMap["orderList"]);
    if (orderStatus.isEmpty) setOrderStatusList(responseMap["orderStatus"]);
  }

  void setOrderList(List<dynamic> orderListMap) {
    if (pageNumber == 2) {
      orderList.clear();
    }

    if (orderListMap != null && orderListMap.length > 0) {
      orderListMap.forEach(
            (orderData) {
          if (listFor == "create") {
//            if (orderData["status"] == "initiated" ||
//                orderData["status"] == "started") {
            addDataToList(orderData);
//            }
          } else {
            if (orderData["status"] == "picked" ||
                orderData["status"] == "packed") {
              addDataToList(orderData);
            }
          }
        },
      );
    }
  }

  void addDataToList(dynamic orderData) {
    List<EachTote> toteList = List();
    if (orderData["toteList"] != null && orderData["toteList"].length > 0) {
      orderData["toteList"].forEach((eachTote) {
        toteList.add(EachTote(
          order_id: eachTote["order_id"],
          assigned_tote_title: eachTote["assigned_tote_title"],
        ));
      });
    }
    orderList.add(
      EachOrder(
        qty: orderData["qty"],
        status: orderData["status"],
        incrementId: orderData["incrementId"],
        toteList: toteList,
      ),
    );
  }

  void setOrderStatusList(List<dynamic> orderStatusMap) {
    orderStatus.add(
      EachOrderStatus(
        label: none,
        value: "",
      ),
    );
    if (orderStatusMap != null && orderStatusMap.length > 0) {
      orderStatusMap.forEach(
            (orderStatusData) {
          orderStatus.add(
            EachOrderStatus(
              label: orderStatusData["label"],
              value: orderStatusData["value"],
            ),
          );
        },
      );
    }
  }
}
