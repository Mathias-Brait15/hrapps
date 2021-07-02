import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hrapps/insentif_agent/tracking_voucher_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../constanta.dart';

// ignore: must_be_immutable
class InsentifAgentScreen extends StatefulWidget {
  @override
  _InsentifAgentScreen createState() => _InsentifAgentScreen();
}

class _InsentifAgentScreen extends State<InsentifAgentScreen> {
  bool _isLoading = false;
  final String apiUrl =
      'https://www.nabasa.co.id/api_remon_v1/tes.php/getInsentifAgent';

  List<dynamic> _users = [];

  void fetchUsers() async {
    setState(() {
      _isLoading = true;
    });
    var result = await http.get(apiUrl);
    if (result.statusCode == 200) {
      setState(() {
        _users = json.decode(result.body)['Daftar_Insentif'];
        _isLoading = false;
      });
    }
  }

  String _id(dynamic user) {
    return user['id'];
  }

  String _debiturCair(dynamic user) {
    return user['debitur_cair'];
  }

  String _jamPencairan(dynamic user) {
    return user['jam_pencairan'];
  }

  String _uname(dynamic user) {
    return user['uname'];
  }

  String _rekomSl(dynamic user) {
    return user['REKOM_SL'];
  }

  String _approvalSl(dynamic user) {
    return user['approval_sl'];
  }

  String _tglDaftarLap(dynamic user) {
    return user['tgl_daftarlap'];
  }

  String _namaPensiunan(dynamic user) {
    return user['namapensiunan'];
  }

  String _noAkad(dynamic user) {
    return user['no_akad'];
  }

  String _cabangAkad(dynamic user) {
    return user['cabang_akad'];
  }

  String _nomTb(dynamic user) {
    return user['nom_tb'];
  }

  String _info(dynamic user) {
    return user['info'];
  }

  String _namaSales(dynamic user) {
    return user['namasales'];
  }

  String _note(dynamic user) {
    return user['note'];
  }

  String _nikmarsit(dynamic user) {
    return user['nikmarsit'];
  }

  String _tarif(dynamic user) {
    return user['tarif'];
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
          'Insentif Agent',
          style: GoogleFonts.aBeeZee(
            fontStyle: FontStyle.normal,
            color: Colors.white,
          ),
        ),
        actions: [searchBar.getSearchAction(context)]);
  }

  void onSubmitted(String value) {
    if (!(value.isEmpty)) {
      List tempList = new List();
      for (int a = 0; a < _users.length; a++) {
        if (_users[a]['namapensiunan']
            .toLowerCase()
            .contains(value.toLowerCase())) {
          tempList.add(_users[a]);
        }
      }
      _users = tempList;
    }
  }

  _InsentifAgentScreen() {
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
      ),
    );
  }

  Widget _buildList() {
    if (_isLoading == true) {
      return Center(
          child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
      ));
    } else {
      if (_users.length > 0) {
        return RefreshIndicator(
          child: ListView.builder(
            padding: EdgeInsets.all(8),
            itemCount: _users.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  double nominal = double.parse(_nomTb(_users[index]));
                  double jumlah =
                      nominal * double.parse(_tarif(_users[index])) / 100;
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => TrackingVoucherScreen(
                          _namaSales(_users[index]),
                          _namaPensiunan(_users[index]),
                          _noAkad(_users[index]),
                          _id(_users[index]),
                          _nomTb(_users[index]),
                          jumlah.toString(),
                          _tarif(_users[index]))));
                },
                child: _buildCreditCard(
                    Color(0xFFD2386C),
                    formatRupiah(_nomTb(_users[index])),
                    _namaPensiunan(_users[index]),
                    _tglDaftarLap(_users[index]),
                    _approvalSl(_users[index]),
                    _noAkad(_users[index])),
              );
            },
          ),
          onRefresh: _getData,
        );
      } else {
        return Container(
          padding: EdgeInsets.all(8),
          child: Card(
            elevation: 2,
            child: ListTile(
              leading: SvgPicture.asset(
                'assets/images/box.svg',
                height: 50,
              ),
              title: Text(
                'DATA TIDAK DITEMUKAN',
                style: GoogleFonts.aBeeZee(
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
            ),
          ),
        );
      }
    }
  }

  Widget _buildCreditCard(Color color, String cardNumber, String cardHolder,
      String cardExpiration, String status, String noAkad) {
    return Card(
      elevation: 4.0,
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
      child: Container(
        height: 150,
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 22.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _buildLogosBlock(status, noAkad),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                '$cardNumber',
                style: GoogleFonts.aBeeZee(
                  fontStyle: FontStyle.normal,
                  color: Colors.white,
                  fontSize: 21,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _buildDetailsBlock('DEBITUR', cardHolder),
                _buildDetailsBlock('INPUT', cardExpiration),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsBlock(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '$label',
          style: GoogleFonts.aBeeZee(
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
            fontSize: 9,
          ),
        ),
        Text(
          '$value',
          style: GoogleFonts.aBeeZee(
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 15,
          ),
        )
      ],
    );
  }

  Widget _buildLogosBlock(status, noAkad) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Tooltip(
            message: noAkad,
            child: Icon(
              MdiIcons.bank,
              size: 20,
              color: Colors.white,
            ),
          ),
        ),
        iconStatus(status)
      ],
    );
  }

  iconStatus(String value) {
    if (value == '4') {
      value = 'SUDAH DI BAYARKAN';
      return Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Tooltip(
          message: setNull(value),
          child: Icon(
            Icons.check,
            size: 20,
            color: Colors.white,
          ),
        ),
      );
    } else {
      value = 'BELUM DI BAYARKAN';
      return Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Tooltip(
          message: setNull(value),
          child: Icon(
            MdiIcons.information,
            size: 20,
            color: Colors.white,
          ),
        ),
      );
    }
  }

  setNull(String data) {
    if (data == null || data == '') {
      return 'NULL';
    } else {
      return data;
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
