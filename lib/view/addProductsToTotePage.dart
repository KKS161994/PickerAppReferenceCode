import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:warehouse_management_system/helper/Dimens.dart';
import 'package:warehouse_management_system/helper/MobikulTheme.dart';
import 'package:warehouse_management_system/helper/StringConstants.dart';
import 'package:warehouse_management_system/helper/Utils.dart';
import 'package:warehouse_management_system/model/AddProductsToToteData.dart';
import 'package:warehouse_management_system/model/AddProductsToToteModel.dart';
import 'package:warehouse_management_system/model/EachLocation.dart';
import 'package:flutter/services.dart';
import 'package:barcode_scan/barcode_scan.dart';

class AddProductsToToteWidget extends StatefulWidget {
  AddProductToToteData addProductToToteData = AddProductToToteData();

  AddProductsToToteWidget(this.addProductToToteData);

  @override
  AddProductsToToteWidgetState createState() => AddProductsToToteWidgetState();
}

class AddProductsToToteWidgetState extends State<AddProductsToToteWidget> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController controller;
  String result = "Hey there !";
  var lastScanTime = 0;

  final AddProductToToteModel model = new AddProductToToteModel();

  @override
  void initState() {
    super.initState();
    model.productList = widget.addProductToToteData.productList;
    model.setNextProduct();
    model.selectedProduct.setFormattedQty();
//    model.setProductScanned();
  }

  Widget _productLocationLayout(EachLocation eachLocation) {
    return Padding(
      child: Text(
          "$row ${eachLocation.row.toString()} - $column ${eachLocation.column
              .toString()} \n$rack ${eachLocation.rack
              .toString()} - $shelf ${eachLocation.shelf.toString()}",
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          style: TextStyle(
              fontSize: text_size_medium,
              color: MobikulTheme.textColorSecondary,
              fontWeight: FontWeight.bold)),
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: model,
      child: ScopedModelDescendant<AddProductToToteModel>(
          builder: (context, child, model) {
            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: true,
                title: Text(
                  "#" + widget.addProductToToteData.incrementId,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: MobikulTheme.actionBarItemColor),
                ),
              ),
              body: Stack(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 200),
                    child: SizedBox.expand(
                      child: RaisedButton(
                        child: Container(
                          child: new Text (
                              scan_product_barcode,
                              style: new TextStyle(
                                  color: Colors.white,
                                 fontSize: text_size_medium
                              )
                          ),
                          decoration: new BoxDecoration (
                              borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
                              color: MobikulTheme.accentColor
                          ),
                          padding: new EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                        ),
                        onPressed: _scanQR,
                      )
//                      child: QRView(
//                        key: qrKey,
//                        onQRViewCreated: _onQRViewCreated,
//                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      height: 262,
                      child: Card(
                        margin: EdgeInsets.all(0),
                        elevation: elevation,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            )),
                        child: Container(
                          margin: EdgeInsets.all(spacing_normal),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Stack(
                                    children: <Widget>[
                                      CachedNetworkImage(
                                        width: 120,
                                        height: 120,
                                        fit: BoxFit.fill,
                                        imageUrl: model.selectedProduct
                                            .thumbNail,
                                        placeholder: (context, url) =>
                                            Image(
                                                width: 120,
                                                height: 120,
                                                image: AssetImage(
                                                    'assets/images/placeholder.png')),
                                      ),
                                      model.selectedProduct.isProductScanned
                                          ? Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                      )
                                          : Container()
                                    ],
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.all(spacing_normal),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(model.selectedProduct.name,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(
                                                  fontSize: text_size_large,
                                                  color: MobikulTheme
                                                      .textColorSecondary,
                                                  fontWeight: FontWeight.bold)),
                                          SizedBox(
                                            width: spacing_small,
                                          ),
                                          Text(model.selectedProduct.sku,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontSize: text_size_medium,
                                                color:
                                                MobikulTheme.textColorSecondary,
                                              )),
                                          SizedBox(
                                            width: spacing_small,
                                          ),
                                          Text(
                                              "$quantity - ${model
                                                  .selectedProduct.qty
                                                  .toString()}",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontSize: text_size_medium,
                                                color:
                                                MobikulTheme.textColorSecondary,
                                              )),
                                          model.selectedProduct.location
                                              .length > 0
                                              ? Text(
                                              "$row ${model.selectedProduct
                                                  .location.first.row
                                                  .toString()} - $column ${model
                                                  .selectedProduct.location
                                                  .first.column
                                                  .toString()} \n$rack ${model
                                                  .selectedProduct.location
                                                  .first.rack
                                                  .toString()} - $shelf ${model
                                                  .selectedProduct.location
                                                  .first.shelf.toString()}",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: TextStyle(
                                                  fontSize: text_size_medium,
                                                  color: MobikulTheme
                                                      .textColorPrimary,
                                                  fontWeight: FontWeight.bold))
                                              : Container(),
                                          model.selectedProduct.location
                                              .length > 1
                                              ? GestureDetector(
                                            child: Text(
                                              "$view ${model.selectedProduct
                                                  .location.length - 1} $more",
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontSize: text_size_small,
                                                  color: MobikulTheme
                                                      .textColorLink),
                                            ),
                                            onTap: () {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text(
                                                          other_locations),
                                                      content: SizedBox(
                                                        height: (model
                                                            .selectedProduct
                                                            .location
                                                            .length >
                                                            0 &&
                                                            model
                                                                .selectedProduct
                                                                .location
                                                                .length <
                                                                4)
                                                            ? double.parse(
                                                            (model
                                                                .selectedProduct
                                                                .location
                                                                .length *
                                                                50)
                                                                .toString())
                                                            : MediaQuery
                                                            .of(
                                                            context)
                                                            .size
                                                            .width /
                                                            2,
                                                        width: MediaQuery
                                                            .of(
                                                            context)
                                                            .size
                                                            .width -
                                                            10,
                                                        child: ListView
                                                            .separated(
                                                          separatorBuilder:
                                                              (context,
                                                              index) =>
                                                              Divider(
                                                                height: 1,
                                                                color:
                                                                Colors.grey,
                                                              ),
                                                          scrollDirection:
                                                          Axis.vertical,
                                                          shrinkWrap: true,
                                                          itemCount: model
                                                              .selectedProduct
                                                              .location
                                                              .length,
                                                          itemBuilder:
                                                              (context,
                                                              position) {
                                                            return _productLocationLayout(
                                                                model
                                                                    .selectedProduct
                                                                    .location[
                                                                position]);
                                                          },
                                                        ),
                                                      ),
                                                      actions: <Widget>[
                                                        FlatButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                  context)
                                                                  .pop();
                                                            },
                                                            child: Container(
                                                              color: MobikulTheme
                                                                  .accentColor,
                                                              child: Padding(
                                                                padding: EdgeInsets
                                                                    .fromLTRB(
                                                                    spacing_normal,
                                                                    spacing_generic,
                                                                    spacing_normal,
                                                                    spacing_generic),
                                                                child: Text(
                                                                  ok,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
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
                              SizedBox(
                                height: spacing_large,
                              ),
                              Text(quantity,
                                  style: TextStyle(
                                    fontSize: text_size_small,
                                    color: MobikulTheme.textColorSecondary,
                                  )),
                              Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      GestureDetector(
                                        child: Container(
                                          width: 48,
                                          height: 48,
                                          decoration: BoxDecoration(
                                              color:
                                              MobikulTheme.buttonBackgroundGrey,
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(24),
                                                  bottomLeft: Radius.circular(
                                                      24))),
                                          child: Center(
                                            child: Text("—",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: text_size_xlarge,
                                                  color: MobikulTheme
                                                      .textColorSecondary,
                                                )),
                                          ),
                                        ),
                                        onTap: () {
                                          if (model.selectedProduct
                                              .selectedQty !=
                                              0) {
                                            model.setSelectedQty(--model
                                                .selectedProduct.selectedQty);
                                          }
                                        },
                                      ),
                                      Container(
                                        width: 76,
                                        height: 48,
                                        child: Center(
                                          child: Text(
                                              model.selectedProduct
                                                  .formattedQty,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: text_size_xlarge,
                                                color: MobikulTheme.accentColor,
                                              )),
                                        ),
                                      ),
                                      GestureDetector(
                                        child: Container(
                                          width: 48,
                                          height: 48,
                                          decoration: BoxDecoration(
                                              color:
                                              MobikulTheme.buttonBackgroundGrey,
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(24),
                                                  bottomRight:
                                                  Radius.circular(24))),
                                          child: Center(
                                            child: Text("+",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: text_size_xlarge,
                                                  color: MobikulTheme
                                                      .textColorSecondary,
                                                )),
                                          ),
                                        ),
                                        onTap: () {
                                          if (model
                                              .selectedProduct
                                              .isProductScanned) {
                                            if (model.selectedProduct
                                                .selectedQty !=
                                                model.selectedProduct.qty) {
                                              model.setSelectedQty(++model
                                                  .selectedProduct.selectedQty);
                                            }
                                          } else {
                                            Utils.showToastNotification(
                                                kindly_scan_the_product_first);
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 60,
                                    height: 60,
                                    child: RaisedButton(
                                      shape: new RoundedRectangleBorder(
                                          borderRadius:
                                          new BorderRadius.circular(30),
                                          side: BorderSide(
                                              color: MobikulTheme.accentColor)),
                                      elevation: button_elevation,
                                      color: MobikulTheme.accentColor,
                                      child: Icon(
                                        Icons.arrow_forward,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        if (model.selectedProduct.qty ==
                                            model.selectedProduct.selectedQty) {
                                          if (model.productList.length ==
                                              model.selectedProductPosition +
                                                  1) {
                                            showDialog(
                                                context: context,
                                                builder: (
                                                    BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text(item_collected),
                                                    content: Text(
                                                        submit_warning),
                                                    actions: <Widget>[
                                                      FlatButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                context)
                                                                .pop();
                                                            this.model
                                                                .changeOrderStatus(
                                                                this.context,
                                                                widget
                                                                    .addProductToToteData
                                                                    .incrementId);
                                                          },
                                                          child: Container(
                                                            color: MobikulTheme
                                                                .accentColor,
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .fromLTRB(
                                                                  spacing_normal,
                                                                  spacing_generic,
                                                                  spacing_normal,
                                                                  spacing_generic),
                                                              child: Text(
                                                                submit,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                          )),
                                                    ],
                                                  );
                                                });
                                          } else {
                                            this.model.setNextProduct();
                                          }
                                        } else {
                                          Utils.showToastNotification(
                                              kindly_pick_all_product_quantity);
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
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
                  ),
                ],
              ),
            );
          }),
    );
  }

  Future _scanQR() async {
    try {
      String qrResult = await BarcodeScanner.scan();
      setState(() {
        result = qrResult;
        if (!model.selectedProduct.isProductScanned) {
//          debugPrint("BarCode: " + result);
          if (model.selectedProduct.sku == result) {
            Utils.showToastNotification(model.selectedProduct.name);
            model.setProductScanned();
          } else {
            if (lastScanTime == 0 ||
                lastScanTime < DateTime.now().millisecondsSinceEpoch - 3000) {
              lastScanTime = DateTime.now().millisecondsSinceEpoch;
              Utils.showToastNotification(invalide_code);
            }
          }
        }
        debugPrint(result);
//        Navigator.pop(context,result);
      });
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          result = "Camera permission was denied";
        });
      } else {
        setState(() {
          result = "Unknown Error $ex";
        });
      }
    } on FormatException {
      setState(() {
        result = "You pressed the back button before scanning anything";
      });
    } catch (ex) {
      setState(() {
        result = "Unknown Error $ex";
      });
    }
  }

//  void _onQRViewCreated(QRViewController controller) {
//    this.controller = controller;
//    controller.scannedDataStream.listen((scanData) {
//      if (!model.selectedProduct.isProductScanned) {
//        debugPrint("BarCode: " + scanData);
//        if (model.selectedProduct.sku == scanData) {
//          Utils.showToastNotification(model.selectedProduct.name);
//          model.setProductScanned();
//        } else {
//          if (lastScanTime == 0 ||
//              lastScanTime < DateTime.now().millisecondsSinceEpoch - 3000) {
//            lastScanTime = DateTime.now().millisecondsSinceEpoch;
//            Utils.showToastNotification(invalide_code);
//          }
//        }
//      }
//    });
//  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
