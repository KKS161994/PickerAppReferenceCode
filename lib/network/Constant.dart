class Constant {
 /*-------------- Servers --------------*/

//Magento 2 demo server
 static const String BASE_URL = "http://preprod-foodhall.storese.in/";                                          //  Magento 2   //  Magento 2
 static const String API_KEY = "foodhall";
 static const String API_PASSWORD = "foodhall#123";

 static const String DEMO_USER = "";
 static const String DEMO_PASSWORD = "";

 // FCM Topic
 static const String FCM_TOPIC = "wms_magento";

 // API Methods
 static const String METHOD_GET = "GET";
 static const String METHOD_POST = "POST";

 // APIs
 static const String USER_LOGIN = "wms/api/login";
 static const String GET_ORDER_LIST = "wms/api/getorderlist";
 static const String GET_ORDER_DETAILS = "wms/api/getorderdetails";
 static const String ADD_TOTE_TO_ORDER = "wms/api/addtote";
 static const String CHANGE_ORDER_STATUS = "wms/api/changestatus";
}

/*
*
* Command to set flutter path
*
* export PATH=`pwd`/flutter/bin:$PATH
*
* */
