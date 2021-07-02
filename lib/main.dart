import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hrapps/approval/approval_insentif_agen.dart';
import 'package:hrapps/approval/approval_screen.dart';
import 'package:hrapps/constanta.dart';
import 'package:hrapps/employee/employee_screen.dart';
import 'package:hrapps/menu/sidebar.dart';
import 'package:hrapps/provider/disbursment_hari_ini_provider.dart';
import 'package:hrapps/provider/disbursment_provider.dart';
import 'package:hrapps/provider/interaction_hari_ini_provider.dart';
import 'package:hrapps/sales/sales_screen.dart';
import 'package:hrapps/user/user_screen.dart';
import 'package:hrapps/user/utility_screen.dart';
import 'package:hrapps/wheel/wheel_screen.dart';
import 'package:provider/provider.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: kPrimaryColor, // status bar color
    statusBarBrightness: Brightness.light, //status bar brigtness
    statusBarIconBrightness: Brightness.light, //status barIcon Brightness
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => DisbursmentProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => DisbursmentHariIniProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => InteractionHariIniProvider(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Remon',
          initialRoute: '/',
          routes: {
            // When navigating to the "/" route, build the FirstScreen widget.
            '/': (context) => SideBar(),
            // When navigating to the "/second" route, build the SecondScreen widget.
            '/peringkat': (context) => SalesScreen(),
            '/karyawan': (context) => EmployeeScreen(),
            '/approval': (context) => ApprovalScreen(),
            '/approval_insentif_agen': (context) =>
                ApprovalInsentifAgenScreen(),
            '/user': (context) => UserScreen(),
            '/wheel': (context) => WheelScreen(),
            '/utility': (context) => UtilityScreen(),
          },
        ));
  }
}
