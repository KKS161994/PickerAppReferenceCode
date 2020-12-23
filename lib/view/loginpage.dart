import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:warehouse_management_system/helper/AppPathConstants.dart';
import 'package:warehouse_management_system/helper/Dimens.dart';
import 'package:warehouse_management_system/helper/MobikulTheme.dart';
import 'package:warehouse_management_system/helper/StringConstants.dart';
import 'package:warehouse_management_system/model/LoginModel.dart';
import 'package:warehouse_management_system/network/Constant.dart';

class LoginPageWidget extends StatefulWidget {
  @override
  LoginPageWidgetState createState() => LoginPageWidgetState();
}

class LoginPageWidgetState extends State<LoginPageWidget> {
  final _loginFormKey = GlobalKey<FormState>();
  final LoginModel model = new LoginModel();
  bool showPassword = true;

  Future<bool> _onWillPop() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text(exit_warning),
        content: new Text(exit_warning_msg),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(),
            child: new Text(no),
          ),
          new FlatButton(
            onPressed: () => SystemChannels.platform
                .invokeMethod<void>('SystemNavigator.pop'),
            child: new Text(yes),
          ),
        ],
      ),
    ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Stack(
          children: <Widget>[
            MaterialApp(
                debugShowCheckedModeBanner: false,
                home: Scaffold(
                    backgroundColor: Color.fromRGBO(197, 247, 183, 1),
                    body:Container(
                        child:Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children:<Widget>[
                            Container(
                              //       margin: const EdgeInsets.only(
                              //     top:100
                              // ),
                                child:Center(
                                    child: Image(
                                      image: AssetImage('assets/images/header_image.png'),
                                    )
                                )
                            ),
                            Container(
                                margin: const EdgeInsets.only(
                                    left:15,
                                    right: 15
                                ),
                                child:Center(
                                    child: Image(
                                      image: AssetImage('assets/images/title_image.png'),
                                    )
                                )
                            ),
                          ],
                        )
                    )
                )
            ),
            AnimatedContainer(
              duration:Duration(
                  microseconds: 1000
              ),
              padding: EdgeInsets.all(20),
              transform: Matrix4.translationValues(0, 220, 1),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20)
                  )
              ),
              child: ScopedModel<LoginModel>(
                model: model,
                child: ScopedModelDescendant<LoginModel>(
                  builder: (context, child, model) {
                    return new Scaffold(
                      body: SingleChildScrollView(
                        reverse: true,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: bottom),
                          child: Stack(
                            children: <Widget>[
                              Form(
                                key: _loginFormKey,
                                child: Container(
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        loginPageTitle,
                                        style: TextStyle(
                                            fontSize: text_size_xlarge,
                                            fontWeight: FontWeight.bold,
                                            color: MobikulTheme.textColorPrimary),
                                      ),
                                      SizedBox(
                                        height: 35,
                                      ),
                                      TextFormField(
                                        initialValue: Constant.DEMO_USER,
                                        keyboardType: TextInputType.emailAddress,
                                        textInputAction: TextInputAction.next,
                                        decoration: InputDecoration(
                                          labelText: username,
                                          labelStyle: TextStyle(
                                            color: Color.fromRGBO(43, 179, 41, 1),
                                          ),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(width: 2),
                                              borderRadius:
                                              BorderRadius.all(Radius.circular(10))),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(width: 2),
                                              borderRadius:
                                              BorderRadius.all(Radius.circular(10))),
                                        ),
                                        validator: (value) {
                                          print(value == null);
                                          if (value.isEmpty) {
                                            return username_warning;
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          model.username = value.trim();
                                        },
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      TextFormField(
                                        initialValue: Constant.DEMO_PASSWORD,
                                        keyboardType: TextInputType.text,
                                        obscureText: showPassword,
                                        textInputAction: TextInputAction.next,
                                        decoration: InputDecoration(
                                          labelText: password,
                                          labelStyle: TextStyle(
                                            color: Color.fromRGBO(43, 179, 41, 1),
                                          ),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(width: 2),
                                              borderRadius:
                                              BorderRadius.all(Radius.circular(10))),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(width: 2),
                                              borderRadius:
                                              BorderRadius.all(Radius.circular(10))),
                                          suffixIcon: IconButton(
                                              color: Colors.grey,
                                              icon: showPassword
                                                  ? Icon(Icons.visibility_off)
                                                  : Icon(Icons.visibility),
                                              onPressed: () {
                                                setState(() {
                                                  showPassword = !showPassword;
                                                });
                                              }),
                                        ),
                                        validator: (value) {
                                          print(value == null);
                                          if (value.isEmpty) {
                                            return password_warning;
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          model.password = value.trim();
                                        },
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      SizedBox(
                                        width: double.infinity,
                                        height: button_height,
                                        child: RaisedButton(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20.0),
                                          ),
                                          textColor: Colors.white,
                                          color: Color.fromRGBO(43, 179, 41, 1),
                                          onPressed: () {
//Navigator.of(context).pushNamed(createRoute);
                                            if (_loginFormKey.currentState.validate()) {
                                              _loginFormKey.currentState.save();
                                              model.onClickLogin(context);
                                            }
                                          },
                                          child: Text(login_button),
                                        ),
                                      ),
                                    ],
                                  ),
                                  padding: EdgeInsets.all(20),
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: model.processing
                                    ? Container(
                                  child: CircularProgressIndicator(),
                                )
                                    : Container(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // child: Column(
              //   children: <Widget>[
              //     Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              //       children: <Widget>[
              //         Container(
              //
              //           margin: EdgeInsets.all(20),
              //           child:Text("LOGIN TO CONTINUE",
              //               style: TextStyle(
              //                   fontSize: 18,
              //                 decoration: TextDecoration.none,
              //                 fontWeight: FontWeight.bold,
              //                 color: Color.fromRGBO(51, 51, 51, 1)
              //               ))
              //         )
              //       ],
              //     ),
              //     Column(
              //       children: <Widget>[
              //         PrimaryButton()
              //       ],
              //     )
              //   ],
              // )
            )
          ],
        )
    );
  }
}
