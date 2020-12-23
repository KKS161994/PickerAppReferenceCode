import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:warehouse_management_system/helper/AppPathConstants.dart';
import 'package:warehouse_management_system/helper/Dimens.dart';
import 'package:warehouse_management_system/helper/MobikulTheme.dart';
import 'package:warehouse_management_system/helper/StringConstants.dart';
import 'package:warehouse_management_system/helper/Utils.dart';
import 'package:warehouse_management_system/model/EachOrder.dart';
import 'package:warehouse_management_system/model/EachOrderStatus.dart';
import 'package:warehouse_management_system/model/OrderListModel.dart';
import 'package:warehouse_management_system/widget/AccountIconWidget.dart';

class CreateToteWidget extends StatefulWidget {
  @override
  CreateToteWidgetState createState() => CreateToteWidgetState();
}

class CreateToteWidgetState extends State<CreateToteWidget> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();

  TextEditingController _searchController = TextEditingController();
  final OrderListModel model = new OrderListModel();
  ScrollController controller;
  int itemCount = 0;
  int totalItem;

  @override
  void initState() {
    itemCount = model.orderList.length;
    totalItem = model.totalCount;
    controller = new ScrollController()..addListener(_scrollListener);
    super.initState();
    model.listFor = "create";
    model.getOrderListData(context, _searchController.text);
  }

  void _scrollListener() {
    if (controller.position.extentAfter == 0 && itemCount <= totalItem - 1) {
      if (!model.lazyLoading) {
        model.lazyLoading = true;
        model.getOrderListData(context, _searchController.text);
      }
    }
  }

  Future<dynamic> _refresh() {
    model.pageNumber = 1;
    return model.getOrderListData(context, _searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: model,
      child: ScopedModelDescendant<OrderListModel>(
          builder: (context, child, model) {
            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: true,
                title: Text(
                  order_list,
                  style: TextStyle(
                      color: MobikulTheme.actionBarItemColor,
                      fontWeight: FontWeight.bold),
                ),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.search,
                      color: MobikulTheme.actionBarItemColor,
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(search),
                              content: TextFormField(
                                controller: _searchController,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  labelText: order_id,
                                  labelStyle: TextStyle(
                                    color: MobikulTheme.accentColor,
                                  ),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(width: 2),
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(0))),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 2),
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(0))),
                                ),
                                validator: (value) {
                                  print(value == null);
                                  if (value.isEmpty) {
                                    return order_id_warning;
                                  }
                                  return null;
                                },
                                onSaved: (value) {},
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
                                          cancel,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    )),
                                FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      this.model.pageNumber = 1;
                                      model.getOrderListData(
                                          context, _searchController.text);
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
                                          search,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ))
                              ],
                            );
                          });
                    },
                  ),
                  Builder(
                    builder: (BuildContext context) {
                      return IconButton(
                        icon: Icon(
                          Icons.filter_list,
                          color: MobikulTheme.actionBarItemColor,
                        ),
                        onPressed: () {
                          if (model.orderStatus.length < 2) {
                            Utils.showToastNotification(filters_not_available);
                          } else {
                            _showFilterBottomSheet(context);
                          }
                        },
                      );
                    },
                  ),
                  AccountIconWidget(),
                ],
              ),
              body: RefreshIndicator(
                key: _refreshIndicatorKey,
                onRefresh: _refresh,
                child: Stack(
                  children: <Widget>[
                    model.processing
                        ? Container()
                        : model.orderList.isEmpty
                        ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            height: MediaQuery.of(context).size.width / 2,
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/ic_empty_order.png'))),
                          ),
                          SizedBox(
                            height: spacing_normal,
                          ),
                          Text(no_pickup_order,
                              style: TextStyle(
                                fontSize: text_size_xlarge,
                                color: MobikulTheme.textColorPrimary,
                              )),
                          SizedBox(
                            height: spacing_generic,
                          ),
                          Text(relax_you_have_no_orders_yet,
                              style: TextStyle(
                                fontSize: text_size_medium,
                                color: MobikulTheme.textColorSecondary,
                              )),
                        ],
                      ),
                    )
                        : ConstrainedBox(
                      constraints: new BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height,
                      ),
                      child: ListView.separated(
                        separatorBuilder: (context, index) => Divider(
                          height: 1,
                          color: Colors.grey,
                        ),
                        scrollDirection: Axis.vertical,
                        physics: const AlwaysScrollableScrollPhysics(),
                        shrinkWrap: true,
                        controller: controller,
                        itemCount: model.orderList.length,
                        itemBuilder: (context, position) {
                          itemCount = model.orderList.length;
                          totalItem = model.totalCount;
//                                if ((position == model.orderList.length-1) && model.totalCount > model.orderList.length) {
//                                    if (!model.processing) {
//                                      model.getOrderListData(context, _searchController.text);
//                                    }
//                                  return Container();
//                                } else {
                          return _orderListLayout(
                              model.orderList[position]);
//                                }
                        },
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
                    model.lazyLoading
                        ? Padding(
                      padding: EdgeInsets.all(spacing_normal),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    )
                        : Container()
                  ],
                ),
              ),
            );
          }),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showBottomSheet(
        context: context,
        elevation: elevation,
        builder: (BuildContext context) => Container(
          child: ListView.separated(
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: Colors.grey,
            ),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: model.orderStatus.length,
            itemBuilder: (context, position) {
              return _orderStatusListLayout(model.orderStatus[position]);
            },
          ),
        ));
  }

  Widget _orderStatusListLayout(EachOrderStatus eachOrderStatus) {
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.all(spacing_normal),
        child: Text(eachOrderStatus.label,
            style: TextStyle(
              fontSize: text_size_small,
              color: MobikulTheme.textColorSecondary,
            )),
      ),
      onTap: () {
        if (model.status != eachOrderStatus.value) {
          model.status = eachOrderStatus.value;
          model.pageNumber = 1;
          model.getOrderListData(context, _searchController.text);
        }
        Navigator.of(context).pop();
      },
    );
  }

  Widget _orderListLayout(EachOrder eachOrder) {
    return GestureDetector(
      child: Container(
        color: MobikulTheme.backgroundColor,
        padding: EdgeInsets.all(spacing_normal),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(order_id_x + eachOrder.incrementId,
                    style: TextStyle(
                        fontSize: text_size_medium,
                        color: MobikulTheme.textColorPrimary,
                        fontWeight: FontWeight.bold)),
                Text(qty + eachOrder.qty.toString(),
                    style: TextStyle(
                      fontSize: text_size_small,
                      color: MobikulTheme.textColorSecondary,
                    )),
              ],
            ),
            SizedBox(
              height: spacing_tiny,
            ),
            Row(
              children: <Widget>[
                Container(
                  width: 8.0,
                  height: 8.0,
                  decoration: BoxDecoration(
                    color: eachOrder.status == "initiated"
                        ? Colors.red
                        : eachOrder.status == "started"
                        ? Colors.orange
                        : eachOrder.status == "picked"
                        ? Colors.blue
                        : Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(
                  width: spacing_tiny,
                ),
                Text(
                    eachOrder.toteList.isEmpty
                        ? assign_tote
                        : tote_x + eachOrder.getToteString(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: text_size_small,
                      color: MobikulTheme.textColorSecondary,
                    )),
              ],
            ),
          ],
        ),
      ),
      onTap: () {
        _openOrderDetails(eachOrder);
      },
    );
  }

  _openOrderDetails(EachOrder eachOrder) async {
    await Navigator.of(context)
        .pushNamed(orderDetailsRoute, arguments: eachOrder);
    model.pageNumber = 1;
    model.getOrderListData(context, _searchController.text);
  }

  @override
  void dispose() {
    itemCount = 0;
    _searchController?.dispose();
    controller.removeListener(_scrollListener);
    super.dispose();
  }
}
