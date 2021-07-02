import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hrapps/approval/detail_approval_insentif_agen_screen.dart';
import 'package:hrapps/constanta.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class ApprovalInsentifAgenScreen extends StatefulWidget {
  @override
  _ApprovalInsentifAgenScreen createState() => _ApprovalInsentifAgenScreen();
}

class _ApprovalInsentifAgenScreen extends State<ApprovalInsentifAgenScreen> {
  bool _isLoading = false;
  final String apiUrl =
      'https://www.nabasa.co.id/api_remon_v1/tes.php/getApprovalInsentifAgen';

  List<dynamic> _users = [];

  void fetchUsers() async {
    setState(() {
      _isLoading = true;
    });
    var result = await http.get(apiUrl);
    if (result.statusCode == 200) {
      setState(() {
        if (json.decode(result.body)['Daftar_ApprovalInsentifAgen'] == '') {
          _isLoading = false;
        } else {
          _users = json.decode(result.body)['Daftar_ApprovalInsentifAgen'];
          _isLoading = false;
        }
      });
    }
  }

  String _id(dynamic user) {
    return user['id'];
  }

  String _name(dynamic user) {
    return user['nama_debitur'];
  }

  String _nomorAplikasi(dynamic user) {
    return user['nomor_aplikasi'];
  }

  String _branch(dynamic user) {
    return user['branch'];
  }

  String _plafond(dynamic user) {
    return user['plafond'];
  }

  String _namaAgen(dynamic user) {
    return user['nama_agen'];
  }

  String _tanggalInput(dynamic user) {
    return user['tanggal_input'];
  }

  String _verifikasiAkuntan(dynamic user) {
    return user['verifikasi_akuntan'];
  }

  String _path1(dynamic user) {
    return user['path1'];
  }

  String _path2(dynamic user) {
    return user['path2'];
  }

  String _path3(dynamic user) {
    return user['path3'];
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
        title: new Text('Insentif Agent',
            style: GoogleFonts.aBeeZee(
                fontStyle: FontStyle.normal, color: Colors.white)),
        actions: [searchBar.getSearchAction(context)]);
  }

  void onSubmitted(String value) {
    if (!(value.isEmpty)) {
      List tempList = new List();
      for (int a = 0; a < _users.length; a++) {
        if (_users[a]['nama_agen']
            .toLowerCase()
            .contains(value.toLowerCase())) {
          tempList.add(_users[a]);
        }
      }
      _users = tempList;
    }
  }

  _ApprovalInsentifAgenScreen() {
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
          color: grey,
          child: _buildList(),
        ),
      ),
    );
  }

  Widget _buildList() {
    print(_isLoading);
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
                  onTap: () {
                    print(_id(_users[index]));
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DetailApprovalInsentifAgenScreen(
                          _id(_users[index]),
                          _name(_users[index]),
                          _nomorAplikasi(_users[index]),
                          _branch(_users[index]),
                          _plafond(_users[index]),
                          _namaAgen(_users[index]),
                          _tanggalInput(_users[index]),
                          _verifikasiAkuntan(_users[index]),
                          _path1(_users[index]),
                          _path2(_users[index]),
                          _path3(_users[index]),
                        ),
                      ),
                    );
                  },
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Text(_namaAgen(_users[index])),
                        subtitle: Text(
                          'Tanggal ' + _tanggalInput(_users[index]),
                          style: GoogleFonts.aBeeZee(
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                        trailing: Text(
                          formatRupiah(_plafond(_users[index])),
                          style: GoogleFonts.aBeeZee(
                            fontStyle: FontStyle.normal,
                          ),
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
