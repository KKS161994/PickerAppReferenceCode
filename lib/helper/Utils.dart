import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'MobikulTheme.dart';

class Utils {
  static generateMd5(String data) {
    var content = new Utf8Encoder().convert(data);
    var md5 = crypto.md5;
    var digest = md5.convert(content);
    return hex.encode(digest.bytes);
  }

  static generateSha256(String data) {
    List<int> bytes = Utf8Encoder().convert(data);
    return sha256.convert(bytes).toString();
  }

  static hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  static void showToastNotification(String msg) {
    if (msg.isNotEmpty) {
      Fluttertoast.showToast(
          msg: msg,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 4,
          backgroundColor: MobikulTheme.accentColor,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
