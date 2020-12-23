import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
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

class LoginModel extends Model with GetResponse {
  BuildContext context;
  bool processing = false;
  String username;
  String password;

  bool isLoginInProcess() => this.processing;

  onClickLogin(BuildContext context) async {
    this.context = context;
    processing = true;
    notifyListeners();
    Utils.hideKeyboard(context);
    String fcmToken = "";
    try {
      fcmToken = await FirebaseMessaging().getToken();
    } catch (e) {
      debugPrint(e.toString());
    }
    var body = {
      "username": username,
      "password": password,
      "mFactor": MediaQuery.of(context).devicePixelRatio,
      "deviceToken": fcmToken,
      "os": Theme.of(context).platform.toString()
    };

    ApiCall.makeCall(Constant.METHOD_POST, Constant.USER_LOGIN, body, this);
  }

  @override
  void getResponse(String response) {
    processing = false;
    notifyListeners();
    try {
      Map responseMap = json.decode(response);
      if (responseMap["success"]) {
        Utils.showToastNotification(login_success);
        AppSharedPref.setLogin(true);
        AppSharedPref.setStaffName(responseMap["staffName"]);
        AppSharedPref.setStaffEmail(username);
        AppSharedPref.setStaffToken(responseMap["staffToken"].toString());
        AppSharedPref.setStaffAvatar(responseMap["avatar"]);
        Navigator.of(context).pushReplacementNamed(homeRoute);
      } else {
        Utils.showToastNotification(responseMap["message"]);
      }
    } catch (e) {
      print(e);
    }
  }
}
