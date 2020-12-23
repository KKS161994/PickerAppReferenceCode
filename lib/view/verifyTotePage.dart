import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:warehouse_management_system/helper/Dimens.dart';
import 'package:warehouse_management_system/helper/MobikulTheme.dart';
import 'package:warehouse_management_system/helper/StringConstants.dart';
import 'package:warehouse_management_system/model/EachProduct.dart';
import 'package:warehouse_management_system/model/OrderDetailsModel.dart';

class VerifyToteWidget extends StatefulWidget {
  OrderDetailsModel model = new OrderDetailsModel();

  VerifyToteWidget(this.model);

  @override
  VerifyToteWidgetState createState() => VerifyToteWidgetState();
}

class VerifyToteWidgetState extends State<VerifyToteWidget> {
  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: widget.model,
      child: ScopedModelDescendant<OrderDetailsModel>(
          builder: (context, child, model) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            title: Text(
              "#" + widget.model.incrementId,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: MobikulTheme.actionBarItemColor),
            ),
            actions: <Widget>[
              model.status == "packed"
                  ? Container()
                  : IconButton(
                      icon: Icon(
                        Icons.check,
                        color: MobikulTheme.actionBarItemColor,
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(item_verified),
                                content: Text(verify_warning),
                                actions: <Widget>[
                                  FlatButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        model.changeOrderStatus(
                                            context, widget.model.incrementId);
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
                                            submit,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      )),
                                ],
                              );
                            });
                      },
                    )
            ],
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
          bottomNavigationBar: SizedBox(
            height: 92,
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    model.toteList.isEmpty
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
                                      color: MobikulTheme.textColorSecondary,
                                      fontSize: text_size_medium)),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                          color:
                                              MobikulTheme.textColorSecondary,
                                          fontSize: text_size_medium)),
                                ],
                              ),
                              Text(model.getToteString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: MobikulTheme.textColorPrimary,
                                      fontSize: text_size_large))
                            ],
                          ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _productListLayout(EachProduct eachProduct) {
    return Container(
      height: 140,
      color: MobikulTheme.backgroundColor,
      padding: EdgeInsets.fromLTRB(spacing_normal, 0.0, spacing_normal, 0.0),
      child: Row(
        children: <Widget>[
          CachedNetworkImage(
            width: 130,
            height: 130,
            fit: BoxFit.fill,
            imageUrl: eachProduct.thumbNail,
            placeholder: (context, url) => Image(
                width: 130,
                height: 130,
                image: AssetImage('assets/images/placeholder.png')),
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    widget.model.productList = List();
    widget.model.toteList = List();
    super.dispose();
  }
}
