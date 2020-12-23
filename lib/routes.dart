import 'package:flutter/material.dart';
import 'package:warehouse_management_system/view/addProductsToTotePage.dart';
import 'package:warehouse_management_system/view/createTotePage.dart';
import 'package:warehouse_management_system/view/fullPageScannerPage.dart';
import 'package:warehouse_management_system/view/homepage.dart';
import 'package:warehouse_management_system/view/loginpage.dart';
import 'package:warehouse_management_system/view/orderDetailsPage.dart';
import 'package:warehouse_management_system/view/verifyTotePage.dart';

import 'helper/AppPathConstants.dart';
import 'helper/AppSharedPref.dart';
import 'helper/MobikulTheme.dart';
import 'helper/StringConstants.dart';
import 'helper/firebase_notification_handler.dart';

class Routes extends StatefulWidget {
  @override
  RouteState createState() => RouteState();
}

class RouteState extends State<Routes> {
  bool _isLoaded = false;
  bool _isLoggedIn = false;

  final RouteFactory transitionRoutes = (RouteSettings settings) {
    switch (settings.name) {
      case loginRoute:
        return MaterialPageRoute(
            builder: (BuildContext context) => LoginPageWidget());
        break;
      case homeRoute:
        return MaterialPageRoute(
            builder: (BuildContext context) => HomepageWidget());
        break;
      case createRoute:
        return MaterialPageRoute(
            builder: (BuildContext context) => CreateToteWidget());
        break;
      case scanBarCodeRoute:
        return MaterialPageRoute(
            builder: (BuildContext context) => FullPageScannerWidget());
        break;
      case verifyRoute:
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                VerifyToteWidget(settings.arguments));
        break;
      case orderDetailsRoute:
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                OrderDetailsWidget(settings.arguments));
        break;
      case addProductToToteRoute:
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                AddProductsToToteWidget(settings.arguments));
        break;
    }
  };

  @override
  void initState() {
    super.initState();
    FirebaseNotifications().setUpFirebase(context);
    AppSharedPref.isLoggedIn().then((value) {
      Future.delayed(const Duration(milliseconds: 2000), () {
        setState(() {
          _isLoggedIn = value;
          _isLoaded = true;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: appName,
      initialRoute: '/',
      onGenerateRoute: transitionRoutes,
      debugShowCheckedModeBanner: false,
      theme: MobikulTheme.mobikulTheme,
      home: _isLoaded
          ? _isLoggedIn ? HomepageWidget() : LoginPageWidget()
          : splashScreen(),
    );
  }

  Widget splashScreen() {
    return Image(
      fit: BoxFit.cover,
      image: AssetImage('assets/images/splash_screen.png'),
    );
  }
}
