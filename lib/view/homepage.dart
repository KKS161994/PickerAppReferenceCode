import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:warehouse_management_system/helper/AppPathConstants.dart';
import 'package:warehouse_management_system/helper/Dimens.dart';
import 'package:warehouse_management_system/helper/MobikulTheme.dart';
import 'package:warehouse_management_system/helper/StringConstants.dart';
import 'package:warehouse_management_system/model/OrderDetailsModel.dart';

class HomepageWidget extends StatefulWidget {
  @override
  HomepageWidgetState createState() => HomepageWidgetState();
}

class HomepageWidgetState extends State<HomepageWidget> {
  final OrderDetailsModel model = new OrderDetailsModel();

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
  void initState() {
    super.initState();
    model.listFor = "verify";
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: ScopedModel(
        model: model,
        child: ScopedModelDescendant<OrderDetailsModel>(
            builder: (context, child, model) {
          return Stack(
            children: <Widget>[
              Container(
                color: MobikulTheme.backgroundColor,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 3,
                        height: MediaQuery.of(context).size.width / 3,
                        child: RaisedButton(
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(
                                  MediaQuery.of(context).size.width / 6),
                              side:
                                  BorderSide(color: MobikulTheme.accentColor)),
                          elevation: button_elevation,
                          color: MobikulTheme.accentColor,
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Icon(
                                Icons.list,
                                color: Colors.white,
                                size: MediaQuery.of(context).size.width / 8,
                              ),
                              SizedBox(
                                height: spacing_generic,
                              ),
                              Text(order_list,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: text_size_medium)),
                            ],
                          ),
                          onPressed: () {
                            Navigator.of(context).pushNamed(createRoute);
                          },
                        ),
                      ),
                      SizedBox(
                        height: spacing_infinity,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 3,
                        height: MediaQuery.of(context).size.width / 3,
                        child: RaisedButton(
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(
                                  MediaQuery.of(context).size.width / 6),
                              side:
                                  BorderSide(color: MobikulTheme.accentColor)),
                          elevation: button_elevation,
                          color: MobikulTheme.accentColor,
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Icon(
                                Icons.check_circle,
                                color: Colors.white,
                                size: MediaQuery.of(context).size.width / 8,
                              ),
                              SizedBox(
                                height: spacing_generic,
                              ),
                              Text(verify,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: text_size_medium)),
                            ],
                          ),
                          onPressed: () {
                            _scanBarCode();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: model.processing
                    ? Container(
                        child: CircularProgressIndicator(),
                      )
                    : Container(),
              )
            ],
          );
        }),
      ),
    );
  }

  _scanBarCode() async {
    var results = await Navigator.pushNamed(context, scanBarCodeRoute);
    if (results != null) {
      model.toteToken = results;
      model.getOrderDetailsData(context);
    }
  }
}
