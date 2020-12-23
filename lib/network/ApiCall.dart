import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:warehouse_management_system/helper/AppSharedPref.dart';
import 'package:warehouse_management_system/helper/Utils.dart';

import 'ApiClient.dart';
import 'Constant.dart';
import 'GetResponse.dart';

class ApiCall {
  static void makeCall(String method, String apiName, Map<String, Object> body,
      GetResponse responseCallback,
      [bool isRetry = false]) {
    AppSharedPref.getAuthKey().then((value) {
      debugPrint("ApiUrl:------------>" + Constant.BASE_URL + apiName);
      debugPrint("ApiAuthKey:-------->" + value);
      debugPrint("ApiBodyData:------->" + body.toString());
      var dio = ApiClient.getInstance();
      dio.interceptors
          .add(InterceptorsWrapper(onRequest: (RequestOptions options) {
        options.headers['authKey'] = value;
        print(value);
        return options; //continue
      }));
      switch (method) {
        case Constant.METHOD_GET:
          {
            dio.get(apiName, queryParameters: body).then((response) {
              printResponse(response);
              responseCallback.getResponse(json.encode(response.data));
            }).catchError((err) {
              if (!isRetry &&
                  err is DioError &&
                  err.response != null &&
                  err.response.statusCode == 401) {
                updateAuthKey(err.response.headers.value("token"));
                makeCall(method, apiName, body, responseCallback, true);
              } else {
//                if (err is DioError)
//                  debugPrint("ApiStatusCode:----->" +
//                      err.response.statusCode.toString());
                debugPrint("ApiError:---------->" + err.toString());
                responseCallback.getResponse(
                    "{\"success\":false,\"message\":\"Something went wrong\"}");
              }
            });
          }
          break;

        case Constant.METHOD_POST:
          {
            dio.post(apiName, data: FormData.fromMap(body)).then((response) {
              printResponse(response);
              responseCallback.getResponse(json.encode(response.data));
            }).catchError((err) {
              if (!isRetry &&
                  err is DioError &&
                  err.response != null &&
                  err.response.statusCode == 401) {
                updateAuthKey(err.response.headers.value("token"));
                makeCall(method, apiName, body, responseCallback, true);
              } else {
//                if (err is DioError)
//                  debugPrint("ApiStatusCode:----->" +
//                      err.response.statusCode.toString());
                debugPrint("ApiError:---------->" + err.toString());
                responseCallback.getResponse(
                    "{\"success\":false,\"message\":\"Something went wrong\"}");
              }
            });
          }
          break;
      }
    });
  }

  static String printResponse(Response response) {
    debugPrint("ApiMethod:--------->" + response.request.method);
    debugPrint("ApiStatusCode:----->" + response.statusCode.toString());
    debugPrint("ApiResponse:------->" + json.encode(response.data));
  }

  static String updateAuthKey(String token) {
    if (token != null) {
      debugPrint("ApiToken:---------->" + token);

      //sha256 // Magento
   String userPassSHA256 =
       Utils.generateSha256(Constant.API_KEY + ":" + Constant.API_PASSWORD);
   AppSharedPref.setAuthKey(
       Utils.generateSha256(userPassSHA256 + ":" + token));
   AppSharedPref.getAuthKey().then((value){
     print("Value"+value);
   });

      // String userPassMD5 =
      //     Utils.generateMd5("mobikul" + ":" + "mobikul123");
      // AppSharedPref.setAuthKey(Utils.generateMd5(userPassMD5 + ":" + token));
    } else {
      debugPrint("ApiToken:---------->Not Available =${token}");
    }
  }
}
