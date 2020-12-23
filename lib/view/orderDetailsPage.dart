import 'dart:math';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:warehouse_management_system/helper/AppPathConstants.dart';
import 'package:warehouse_management_system/helper/AppSharedPref.dart';
import 'package:warehouse_management_system/helper/Dimens.dart';
import 'package:warehouse_management_system/helper/MobikulTheme.dart';
import 'package:warehouse_management_system/helper/StringConstants.dart';
import 'package:warehouse_management_system/helper/Utils.dart';
import 'package:warehouse_management_system/model/AddProductsToToteData.dart';
import 'package:warehouse_management_system/model/EachLocation.dart';
import 'package:warehouse_management_system/model/EachOrder.dart';
import 'package:warehouse_management_system/model/EachProduct.dart';
import 'package:warehouse_management_system/model/OrderDetailsModel.dart';

class OrderDetailsWidget extends StatefulWidget {
  EachOrder eachOrder = EachOrder();

  OrderDetailsWidget(this.eachOrder);

  @override
  OrderDetailsWidgetState createState() => OrderDetailsWidgetState();
}

class OrderDetailsWidgetState extends State<OrderDetailsWidget> {
  final OrderDetailsModel model = new OrderDetailsModel();
  bool helpShowed = true;


  @override
  void initState() {
    super.initState();
    model.listFor = "create";
    model.incrementId = widget.eachOrder.incrementId;
    model.getOrderDetailsData(context);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: model,
      child: ScopedModelDescendant<OrderDetailsModel>(
          builder: (context, child, model) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            title: Text(
              "#" + model.incrementId,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: MobikulTheme.actionBarItemColor),
            ),
          ),
          body: Stack(
            children: <Widget>[
              ListView.separated(
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  color: Colors.grey,
                ),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: model.productList.length,
                itemBuilder: (context, position) {
                  return _productListLayout(model.productList[position]);
                },
              ),
              model.toteList.isEmpty
                  ? Container(
                      color: Color(0xDDFFFFFF),
                    )
                  : Container(),
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
          bottomNavigationBar: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Card(
                margin: EdgeInsets.all(0),
                elevation: elevation,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                )),
                child: Container(
                  margin: EdgeInsets.all(spacing_normal),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SizedBox(
                        width: (MediaQuery.of(context).size.width) - 128,
                        child: model.toteList.isEmpty
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.inbox,
                                    color: MobikulTheme.textColorSecondary,
                                    size: 32,
                                  ),
                                  Text(add_tote_to_begin,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color:
                                              MobikulTheme.textColorSecondary,
                                          fontSize: text_size_medium)),
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.inbox,
                                        color: MobikulTheme.textColorSecondary,
                                        size: 32,
                                      ),
                                      Text(
                                          model.toteList.length.toString() +
                                              " " +
                                              tote,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: MobikulTheme
                                                  .textColorSecondary,
                                              fontSize: text_size_medium)),
                                    ],
                                  ),
                                  Text(model.getToteString(),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: MobikulTheme.textColorPrimary,
                                          fontSize: text_size_large))
                                ],
                              ),
                      ),
                      model.status == "initiated" || model.status == "started"
                          ? SizedBox(
                              width: 100,
                              height: 48,
                              child: RaisedButton.icon(
                                  color: MobikulTheme.accentColor,
                                  onPressed: () {
                                    scanData();
//                                    model.toteToken = "tote10";
//                                    model.addToteToModel(context);
                                  },
                                  icon: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                  label: Text(add,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: text_size_medium))),
                            )
                          : Container(),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      }),
    );
  }

  Widget _productLocationLayout(EachLocation eachLocation) {
    return Padding(
      child: Text(
          "$row ${eachLocation.row.toString()} - $column ${eachLocation.column.toString()} \n$rack ${eachLocation.rack.toString()} - $shelf ${eachLocation.shelf.toString()}",
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          style: TextStyle(
              fontSize: text_size_medium,
              color: MobikulTheme.textColorSecondary,
              fontWeight: FontWeight.bold)),
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
    );
  }

  Widget _productListLayout(EachProduct eachProduct) {
    return GestureDetector(
      child: Container(
        height: 140,
        color: MobikulTheme.backgroundColor,
        padding: EdgeInsets.fromLTRB(spacing_normal, 0.0, spacing_normal, 0.0),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 130,
              height: 130,
              child: CachedNetworkImage(
                fit: BoxFit.fill,
                imageUrl: eachProduct.thumbNail,
                placeholder: (context, url) =>
                    Image(image: AssetImage('assets/images/placeholder.png')),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(spacing_normal),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(eachProduct.name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: text_size_large,
                            color: MobikulTheme.textColorSecondary,
                            fontWeight: FontWeight.bold)),
                    Text(eachProduct.sku,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: text_size_medium,
                          color: MobikulTheme.textColorSecondary,
                        )),
                    Text("$quantity - ${eachProduct.qty.toString()}",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: text_size_medium,
                          color: MobikulTheme.textColorSecondary,
                        )),
                    eachProduct.location.length > 0
                        ? Text(
                            "$row ${eachProduct.location.first.row.toString()} - $column ${eachProduct.location.first.column.toString()} \n$rack ${eachProduct.location.first.rack.toString()} - $shelf ${eachProduct.location.first.shelf.toString()}",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                                fontSize: text_size_medium,
                                color: MobikulTheme.textColorPrimary,
                                fontWeight: FontWeight.bold))
                        : Container(),
                    eachProduct.location.length > 1
                        ? GestureDetector(
                            child: Text(
                              "$view ${eachProduct.location.length - 1} $more",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: text_size_small,
                                  color: MobikulTheme.textColorLink),
                            ),
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(other_locations),
                                      content: SizedBox(
                                        height: (eachProduct.location.length >
                                                    0 &&
                                                eachProduct.location.length < 4)
                                            ? double.parse(
                                                (eachProduct.location.length *
                                                        50)
                                                    .toString())
                                            : MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2,
                                        width:
                                            MediaQuery.of(context).size.width -
                                                10,
                                        child: ListView.separated(
                                          separatorBuilder: (context, index) =>
                                              Divider(
                                            height: 1,
                                            color: Colors.grey,
                                          ),
                                          scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                          itemCount:
                                              eachProduct.location.length,
                                          itemBuilder: (context, position) {
                                            return _productLocationLayout(
                                                eachProduct.location[position]);
                                          },
                                        ),
                                      ),
                                      actions: <Widget>[
                                        FlatButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Container(
                                              color: MobikulTheme.accentColor,
                                              child: Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    spacing_normal,
                                                    spacing_generic,
                                                    spacing_normal,
                                                    spacing_generic),
                                                child: Text(
                                                  ok,
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ))
                                      ],
                                    );
                                  });
                            },
                          )
                        : Container()
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        if (model.toteList.isNotEmpty &&
            (model.status == "initiated" || model.status == "started")) {
          AddProductToToteData addProductToToteData = AddProductToToteData();
          addProductToToteData.incrementId = model.incrementId;
          addProductToToteData.productList = model.productList;

          _startAddingProductsToTote(addProductToToteData);
        }
      },
    );
  }

  _startAddingProductsToTote(AddProductToToteData addProductToToteData) async {
    var results = await Navigator.of(context)
        .pushNamed(addProductToToteRoute, arguments: addProductToToteData);
    if (results != null && results == "completed") {
      Navigator.of(context).pop();
    }
  }

  _scanBarCode() async {
    var results = await Navigator.pushNamed(context, scanBarCodeRoute);
    if (results != null) {
      model.toteToken = results;
      model.addToteToModel(context);
    }
  }
  Future scanData() async {
    AppSharedPref.isHelpShowed().then((value) async {
      if (!value) {
        var results = await Navigator.pushNamed(context, scanBarCodeRoute);
        if(results=="scanData"){
          Future.delayed(Duration(milliseconds : 100), ()
          {
            scanData();
          });
        }
      } else{
        String qrResult;
        try {
           qrResult = await BarcodeScanner.scan();
//          debugPrint("_scanQR===>" + qrResult);

            if (qrResult!=null && qrResult.isNotEmpty) {
              model.toteToken = qrResult;
              model.addToteToModel(context);
            }

        } on PlatformException catch (ex) {
          if (ex.code == BarcodeScanner.CameraAccessDenied) {
              Utils.showToastNotification("Camera permission was denied");
          }
//          else {
//            Utils.showToastNotification("Unknown Error $ex");
//          }
        }
        catch (ex) {
//          ex.p
//          Utils.showToastNotification("Unknown Error $ex");
        }
      }
    });
  }

}
