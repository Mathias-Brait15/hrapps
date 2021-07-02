import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hrapps/constanta.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_search_bar/flutter_search_bar.dart';

// ignore: must_be_immutable
class TopBookingBranchScreen extends StatefulWidget {
  @override
  _TopBookingBranchScreen createState() => _TopBookingBranchScreen();
}

class _TopBookingBranchScreen extends State<TopBookingBranchScreen> {
  int _jumRek = 0;
  int _jumPla = 0;
  int setLoad = 0;
  bool _isLoading = false;
  final String apiUrl =
      'https://www.nabasa.co.id/api_remon_v1/tes.php/getBranch';

  List<dynamic> _users = [];

  void fetchUsers() async {
    setState(() {
      _isLoading = true;
    });
    var result = await http.get(apiUrl);
    if (result.statusCode == 200) {
      setState(() {
        _users = json.decode(result.body)['Daftar_Branch'];
        _isLoading = false;
        setLoad += 1;
        if (setLoad <= 1) {
          for (int i = 0; i < _users.length; i++) {
            _jumRek += int.parse(_users[i]['jum_rek']);
            _jumPla += int.parse(_users[i]['jum_plafond']);
          }
        } else {
          _jumRek = 0;
          _jumPla = 0;
          for (int i = 0; i < _users.length; i++) {
            _jumRek += int.parse(_users[i]['jum_rek']);
            _jumPla += int.parse(_users[i]['jum_plafond']);
          }
        }
      });
    }
  }

  String _note(dynamic user) {
    return user['note'];
  }

  String _branch(dynamic user) {
    return user['branch'];
  }

  String _namaSales(dynamic user) {
    return user['namasales'];
  }

  String _cabangAkad(dynamic user) {
    return user['cabang_akad'];
  }

  String _jumlahRekening(dynamic user) {
    return user['jum_rek'];
  }

  String _jumlahPlafond(dynamic user) {
    return user['jum_plafond'];
  }

  Future<void> _getData() async {
    setState(() {
      fetchUsers();
    });
  }

  SearchBar searchBar;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
        backgroundColor: kPrimaryColor,
        title: new Text(
          'Peringkat Branch',
          style: GoogleFonts.aBeeZee(
              fontStyle: FontStyle.normal, color: Colors.white),
        ),
        actions: [searchBar.getSearchAction(context)]);
  }

  void onSubmitted(String value) {
    if (!(value.isEmpty)) {
      List tempList = new List();
      for (int a = 0; a < _users.length; a++) {
        if (_users[a]['branch'].toLowerCase().contains(value.toLowerCase())) {
          tempList.add(_users[a]);
        }
      }
      _users = tempList;
    }
  }

  _TopBookingBranchScreen() {
    searchBar = new SearchBar(
        inBar: false,
        setState: setState,
        onSubmitted: onSubmitted,
        onCleared: () {
          print("cleared");
        },
        onClosed: () {
          print("closed");
        },
        buildDefaultAppBar: buildAppBar);
  }

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: searchBar.build(context),
        key: _scaffoldKey,
        body: Container(
          child: _buildList(),
        ),
        bottomSheet: Container(
          color: kPrimaryColor,
          padding: EdgeInsets.all(16),
          height: 50,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.30,
                    child: Text(
                      'Rekening : ' + _jumRek.toString(),
                      style: GoogleFonts.aBeeZee(
                          fontStyle: FontStyle.normal,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.50,
                    child: Text(
                      formatRupiah(_jumPla.toString()),
                      textAlign: TextAlign.right,
                      style: GoogleFonts.aBeeZee(
                          fontStyle: FontStyle.normal,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildList() {
    if (_isLoading == true) {
      return Center(child: CircularProgressIndicator());
    } else {
      if (_users.length > 0) {
        return RefreshIndicator(
          child: ListView.builder(
            padding: EdgeInsets.all(8),
            itemCount: _users.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: GestureDetector(
                  onTap: () {},
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Text(
                          _branch(_users[index]),
                        ),
                        subtitle: Text(
                          'Rekening : ' + _jumlahRekening(_users[index]),
                          style: GoogleFonts.aBeeZee(
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                        trailing: Text(
                          formatRupiah(_jumlahPlafond(_users[index])),
                          style:
                              GoogleFonts.aBeeZee(fontStyle: FontStyle.normal),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          onRefresh: _getData,
        );
      } else {
        return Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                color: Colors.white,
              ),
              child: SvgPicture.asset(
                'assets/images/box.svg',
                height: 50,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text('DATA TIDAK DITEMUKAN',
                style: GoogleFonts.aBeeZee(
                    fontStyle: FontStyle.normal, color: Colors.blueGrey)),
          ]),
        );
      }
    }
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
