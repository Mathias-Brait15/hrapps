import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hrapps/constanta.dart';
import 'package:hrapps/sales/top_booking.dart';
import 'package:hrapps/sales/top_booking_branch.dart';

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
          backgroundColor: kPrimaryColor,
          title: Text(
            'Peringkat',
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
                                      'assets/images/agent.svg',
                                      height: 50,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'Sales',
                                      style: GoogleFonts.aBeeZee(
                                          fontStyle: FontStyle.normal,
                                          fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => TopBookingScreen()));
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
                                      'assets/images/office.svg',
                                      height: 50,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'Branch',
                                      style: GoogleFonts.aBeeZee(
                                          fontStyle: FontStyle.normal,
                                          fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      TopBookingBranchScreen()));
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
