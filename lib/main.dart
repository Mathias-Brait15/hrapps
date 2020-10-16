import 'package:flutter/material.dart';
import 'package:hrapps/disbursment_screen.dart';
import 'package:hrapps/provider/disbursment_provider.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => DisbursmentProvider(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Disbursment Notification',
          theme: ThemeData(
            primaryColor: Colors.amberAccent,
            scaffoldBackgroundColor: Colors.white,
          ),
          home: DisbursmentScreen(),
        ));
  }
}
