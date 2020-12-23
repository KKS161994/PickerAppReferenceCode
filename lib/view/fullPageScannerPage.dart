import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttie/fluttie.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:warehouse_management_system/helper/AppSharedPref.dart';
import 'package:warehouse_management_system/helper/Dimens.dart';
import 'package:warehouse_management_system/helper/MobikulTheme.dart';
import 'package:warehouse_management_system/helper/StringConstants.dart';

class FullPageScannerWidget extends StatefulWidget {
  @override
  FullPageScannerWidgetState createState() => FullPageScannerWidgetState();
}

class FullPageScannerWidgetState extends State<FullPageScannerWidget> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  var mBarCode = "";
  bool helpShowed = true;
  QRViewController _qrController;
  bool isAnimationReady = false;
  bool isVisible = true;

  FluttieAnimationController _barcodeSampleAnimationController;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      AppSharedPref.isHelpShowed().then((value) {
        if (!value) {
          setState(() {
            helpShowed = false;
          });
          AppSharedPref.setHelpShowed(true);
          if (Theme.of(context).platform == TargetPlatform.android) {
            prepareAnimation();
          }
        }
      });
    });
  }

  prepareAnimation() async {
    bool canBeUsed = await Fluttie.isAvailable();
    if (!canBeUsed) {
      print("Animations are not supported on this platform");
      return;
    }
    var instance = Fluttie();

    var barcodeComposition =
    await instance.loadAnimationFromAsset("assets/animations/barcode.json");

    _barcodeSampleAnimationController = await instance.prepareAnimation(
        barcodeComposition,
        duration: const Duration(seconds: 2),
        repeatCount: const RepeatCount.infinite(),
        repeatMode: RepeatMode.START_OVER);

    setState(() {
      isAnimationReady = true;
      _barcodeSampleAnimationController.start();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          scan_a_tote,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: MobikulTheme.actionBarItemColor),
        ),
      ),
      body: Stack(
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          helpShowed
              ? Container()
              : Center(
            child: Container(
              width: MediaQuery.of(context).size.width / 1.2,
              height: isAnimationReady
                  ? MediaQuery.of(context).size.width / 1.2 + 40
                  : MediaQuery.of(context).size.width / 2,
              padding: EdgeInsets.all(spacing_normal),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(how_it_works,
                      style: TextStyle(
                          fontSize: text_size_large,
                          fontWeight: FontWeight.bold)),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.6,
                    height: isAnimationReady
                        ? MediaQuery.of(context).size.width / 1.6
                        : (MediaQuery.of(context).size.width / 2) - 100,
                    child: isAnimationReady
                        ? FluttieAnimation(
                        _barcodeSampleAnimationController)
                        : Center(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 30,
                          ),
                          Text(how_it_works_point_one,
                              style: TextStyle(
                                fontSize: text_size_small,
                              )),
                          Text(how_it_works_point_two,
                              style: TextStyle(
                                fontSize: text_size_small,
                              )),
                        ],
                      ),
                    ),
                  ),
                  FlatButton(
                      onPressed: () {
                        setState(() {
                          AppSharedPref.setHelpShowed(true);
                        });

                        Navigator.pop(context, "scanData");
                      },
                      child: Text(
                        dismiss,
                        style: TextStyle(color: MobikulTheme.accentColor),
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this._qrController = controller;
    controller.scannedDataStream.listen((scanData) {
//      debugPrint("BarCode: " + scanData);
      if (mBarCode.isEmpty) {
        mBarCode = scanData;
        Navigator.pop(context, scanData);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    mBarCode = "";
    helpShowed = false;
    _qrController?.dispose();
    _barcodeSampleAnimationController?.dispose();
  }
}
