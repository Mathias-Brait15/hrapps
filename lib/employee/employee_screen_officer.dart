import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hrapps/constanta.dart';
import 'package:hrapps/employee/detail_employee.dart';
import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';

// ignore: must_be_immutable
class EmployeeOfficerScreen extends StatefulWidget {
  @override
  _EmployeeOfficerScreen createState() => _EmployeeOfficerScreen();
}

class _EmployeeOfficerScreen extends State<EmployeeOfficerScreen> {
  bool _isLoading = false;
  final String apiUrl =
      'https://www.nabasa.co.id/api_remon_v1/tes.php/getEmployeeOfficer';

  List<dynamic> _users = [];

  void fetchUsers() async {
    setState(() {
      _isLoading = true;
    });
    var result = await http.get(apiUrl);
    if (result.statusCode == 200) {
      setState(() {
        _users = json.decode(result.body)['Daftar_Employee_Officer'];
        _isLoading = false;
      });
    }
  }

  String _id(dynamic user) {
    return user['id'];
  }

  String _branch(dynamic user) {
    return user['branch'];
  }

  String _nik(dynamic user) {
    return user['nik'];
  }

  String _namaKaryawan(dynamic user) {
    return user['nama_karyawan'];
  }

  String _alamat(dynamic user) {
    return user['alamat'];
  }

  String _kelurahan(dynamic user) {
    return user['kelurahan'];
  }

  String _kecamatan(dynamic user) {
    return user['kecamatan'];
  }

  String _kabupaten(dynamic user) {
    return user['kabupaten'];
  }

  String _propinsi(dynamic user) {
    return user['propinsi'];
  }

  String _kodePos(dynamic user) {
    return user['kode_pos'];
  }

  String _tglLahir(dynamic user) {
    return user['tgl_lahir'];
  }

  String _tempatLahir(dynamic user) {
    return user['tempat_lahir'];
  }

  String _jenisKelamin(dynamic user) {
    return user['jenis_kelamin'];
  }

  String _noTelepon(dynamic user) {
    return user['no_telepon_2'];
  }

  String _alamatEmail(dynamic user) {
    return user['alamat_email'];
  }

  String _tglAwalKontrak(dynamic user) {
    return user['tgl_skep'];
  }

  String _tglAkhirKontrak(dynamic user) {
    return user['tgl_akhir_kontrak'];
  }

  String _statusKaryawan(dynamic user) {
    return user['status_karyawan'];
  }

  String _divisiKaryawan(dynamic user) {
    return user['divisi_karyawan'];
  }

  String _jabatanKaryawan(dynamic user) {
    return user['jabatan_karyawan'];
  }

  String _salesLeader(dynamic user) {
    return user['sales_leader'];
  }

  String _jmlPencairan(dynamic user) {
    return user['jml_pencairan'];
  }

  String _jmlInteraksi(dynamic user) {
    return user['jml_interaksi'];
  }

  String _nikmarsit(dynamic user) {
    return user['nikmarsit'];
  }

  String _tarif(dynamic user) {
    return user['tarif'];
  }

  String _pict(dynamic user) {
    return user['pict'];
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
          'Officer',
          style: GoogleFonts.aBeeZee(
              fontStyle: FontStyle.normal, color: Colors.white),
        ),
        actions: [searchBar.getSearchAction(context)]);
  }

  void onSubmitted(String value) {
    if (!(value.isEmpty)) {
      List tempList = new List();
      for (int a = 0; a < _users.length; a++) {
        if (_users[a]['nama_karyawan']
            .toLowerCase()
            .contains(value.toLowerCase())) {
          tempList.add(_users[a]);
        }
      }
      _users = tempList;
    }
  }

  _EmployeeOfficerScreen() {
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
        backgroundColor: grey,
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
                        builder: (context) => DetailEmployee(
                          _nik(_users[index]),
                          _namaKaryawan(_users[index]),
                          _alamatEmail(_users[index]),
                          _noTelepon(_users[index]),
                          _tglAwalKontrak(_users[index]),
                          _tglAkhirKontrak(_users[index]),
                          _branch(_users[index]),
                          _alamat(_users[index]),
                          _kelurahan(_users[index]),
                          _kecamatan(_users[index]),
                          _kabupaten(_users[index]),
                          _propinsi(_users[index]),
                          _kodePos(_users[index]),
                          _tglLahir(_users[index]),
                          _tempatLahir(_users[index]),
                          _jenisKelamin(_users[index]),
                          _statusKaryawan(_users[index]),
                          _divisiKaryawan(_users[index]),
                          _jabatanKaryawan(_users[index]),
                          _salesLeader(_users[index]),
                          _jmlPencairan(_users[index]),
                          _jmlInteraksi(_users[index]),
                          _nikmarsit(_users[index]),
                          'all',
                          _tarif(_users[index]),
                          _pict(_users[index]),
                        ),
                      ),
                    );
                  },
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Text(
                          _namaKaryawan(_users[index]),
                          style: GoogleFonts.aBeeZee(
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                        trailing: gender(_jenisKelamin(_users[index])),
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

  gender(String a) {
    if (a == '0') {
      return new Icon(
        MdiIcons.humanMale,
        color: Colors.lightBlue,
        size: 30.0,
      );
    } else {
      return new Icon(
        MdiIcons.humanFemale,
        color: Colors.redAccent,
        size: 30.0,
      );
    }
  }
}
