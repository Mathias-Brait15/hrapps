import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hrapps/constanta.dart';
import 'package:hrapps/sales/top_booking.dart';
import 'package:hrapps/sales/top_booking_branch.dart';
import 'package:hrapps/user/akn_marsit_screen.dart';
import 'package:hrapps/user/akn_nabasa_screen.dart';
import 'package:hrapps/user/nabasa_screen.dart';
import 'package:hrapps/user/sdm_screen.dart';

// ignore: must_be_immutable
class UserScreen extends StatefulWidget {
  @override
  _UserScreen createState() => _UserScreen();
}

class _UserScreen extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: Text(
            'Utility',
            style: GoogleFonts.aBeeZee(
                fontStyle: FontStyle.normal, color: Colors.white),
          ),
        ),
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
                        crossAxisCount: 3,
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
                                      'assets/images/user_account.svg',
                                      height: 50,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'SDM',
                                      style: GoogleFonts.aBeeZee(
                                        fontStyle: FontStyle.normal,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => SdmScreen()));
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
                                      'assets/images/user_account.svg',
                                      height: 50,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'NABASA',
                                      style: GoogleFonts.aBeeZee(
                                        fontStyle: FontStyle.normal,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => NabasaScreen()));
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
                                      'assets/images/user_account.svg',
                                      height: 50,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'AKN MARSIT',
                                      style: GoogleFonts.aBeeZee(
                                        fontStyle: FontStyle.normal,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => AknMarsitScreen()));
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
                                      'assets/images/user_account.svg',
                                      height: 50,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'AKN NABASA',
                                      style: GoogleFonts.aBeeZee(
                                        fontStyle: FontStyle.normal,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => AknNabasaScreen()));
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
