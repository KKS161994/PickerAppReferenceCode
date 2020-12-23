import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:warehouse_management_system/helper/AppPathConstants.dart';
import 'package:warehouse_management_system/helper/AppSharedPref.dart';
import 'package:warehouse_management_system/helper/Dimens.dart';
import 'package:warehouse_management_system/helper/MobikulTheme.dart';
import 'package:warehouse_management_system/helper/StringConstants.dart';

class AccountIconWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.account_circle,
        color: MobikulTheme.actionBarItemColor,
      ),
      onPressed: () {
        AppSharedPref.getStaffName().then((name) {
          AppSharedPref.getStaffEmail().then((email) {
            AppSharedPref.getStaffAvatar().then((avatar) {
              showBottomSheet(
                  context: context,
                  elevation: elevation,
                  builder: (context) => Container(
                        height: 60,
                        padding: EdgeInsets.all(spacing_small),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                CachedNetworkImage(
                                  fit: BoxFit.fill,
                                  imageUrl: avatar,
                                  placeholder: (context, url) => Image(
                                      image: AssetImage(
                                          'assets/images/placeholder.png')),
                                ),
                                SizedBox(
                                  width: spacing_generic,
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      name,
                                      style:
                                          TextStyle(fontSize: text_size_medium),
                                    ),
                                    Text(
                                      email,
                                      style:
                                          TextStyle(fontSize: text_size_medium),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.power_settings_new,
                              ),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(logout),
                                        content: Text(logout_msg),
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
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              )),
                                          FlatButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                AppSharedPref.setLogin(false);
                                                AppSharedPref.setStaffName(
                                                    null);
                                                AppSharedPref.setStaffEmail(
                                                    null);
                                                AppSharedPref.setStaffToken(
                                                    null);
                                                AppSharedPref.setStaffAvatar(
                                                    null);
                                                Navigator.of(context)
                                                    .pushNamedAndRemoveUntil(
                                                        loginRoute,
                                                        (Route<dynamic>
                                                                route) =>
                                                            false);
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
                                                    logout,
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
                          ],
                        ),
                      ));
            });
          });
        });
      },
    );
  }
}
