import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hrapps/approval/approval_insentif_agen.dart';
import 'package:hrapps/constanta.dart';
import 'package:toast/toast.dart';

// ignore: must_be_immutable
class ApprovalScreen extends StatefulWidget {
  @override
  _ApprovalScreen createState() => _ApprovalScreen();
}

class _ApprovalScreen extends State<ApprovalScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: Text('Approval',
              style: GoogleFonts.aBeeZee(
                  fontStyle: FontStyle.normal, color: Colors.white)),
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
                                      'assets/images/tick.svg',
                                      height: 50,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text('Insentif Agent',
                                        style: GoogleFonts.aBeeZee(
                                          fontStyle: FontStyle.normal,
                                          color: Colors.blueGrey,
                                          fontSize: 12,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      ApprovalInsentifAgenScreen()));
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
                                      'assets/images/tick1.svg',
                                      height: 50,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'Insentif Karyawan',
                                      style: GoogleFonts.aBeeZee(
                                        fontStyle: FontStyle.normal,
                                        color: Colors.blueGrey,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            onTap: () {
                              Toast.show(
                                "Coming Soon",
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

  formatRupiah(String a) {
    FlutterMoneyFormatter fmf = new FlutterMoneyFormatter(
        amount: double.parse(a),
        settings: MoneyFormatterSettings(
          symbol: 'IDR',
          thousandSeparator: '.',
          decimalSeparator: ',',
          symbolAndNumberSeparator: ' ',
          fractionDigits: 3,
        ));
    return 'IDR ' + fmf.output.withoutFractionDigits;
  }
}
