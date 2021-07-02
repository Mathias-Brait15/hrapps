import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hrapps/penjualan/individu_screen.dart';
import 'package:hrapps/penjualan/sales_screen.dart';
import 'package:toast/toast.dart';

// ignore: must_be_immutable
class SalesScreen extends StatefulWidget {
  @override
  _SalesScreen createState() => _SalesScreen();
}

class _SalesScreen extends State<SalesScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Sales',
          ),
        ),
        //ADAPUN UNTUK LOOPING DATA PEGAWAI, KITA GUNAKAN LISTVIEW BUILDER
        //KARENA WIDGET INI SUDAH DILENGKAPI DENGAN FITUR SCROLLING
        body: Stack(
          children: <Widget>[
            SafeArea(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Expanded(
                          child: GridView.count(
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        primary: false,
                        crossAxisCount: 2,
                        children: <Widget>[
                          GestureDetector(
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    SvgPicture.asset(
                                      'assets/images/standing-up-man.svg',
                                      height: 50,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'Individu',
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            onTap: () {
                              Toast.show(
                                'Coming Soon',
                                context,
                                duration: Toast.LENGTH_SHORT,
                                gravity: Toast.BOTTOM,
                                backgroundColor: Colors.red,
                              );
                            },
                          ),
                          GestureDetector(
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    SvgPicture.asset(
                                      'assets/images/users-group.svg',
                                      height: 50,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'All',
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            onTap: () {
                              Toast.show(
                                'Coming Soon',
                                context,
                                duration: Toast.LENGTH_SHORT,
                                gravity: Toast.BOTTOM,
                                backgroundColor: Colors.red,
                              );
                            },
                          ),
                          GestureDetector(
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    SvgPicture.asset(
                                      'assets/images/teamwork1.svg',
                                      height: 50,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'Group',
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            onTap: () {
                              Toast.show(
                                'Coming Soon',
                                context,
                                duration: Toast.LENGTH_SHORT,
                                gravity: Toast.BOTTOM,
                                backgroundColor: Colors.red,
                              );
                            },
                          ),
                        ],
                      )),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
