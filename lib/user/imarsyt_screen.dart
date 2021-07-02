import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hrapps/constanta.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class ImarsytScreen extends StatefulWidget {
  @override
  _ImarsytScreen createState() => _ImarsytScreen();
}

class _ImarsytScreen extends State<ImarsytScreen> {
  bool _loading = false;
  bool _isLoading = false;
  List<bool> inputs = new List<bool>();
  final String apiUrl =
      'https://www.nabasa.co.id/api_remon_v1/tes.php/getUserImarsyt';

  List<dynamic> _users = [];

  bool setBool(String statusUser) {
    if (statusUser == 'true') {
      return true;
    } else {
      return false;
    }
  }

  void fetchUsers() async {
    setState(() {
      _isLoading = true;
    });
    var result = await http.get(apiUrl);
    if (result.statusCode == 200) {
      setState(() {
        _users = json.decode(result.body)['Daftar_User'];
        _isLoading = false;
        print(_users[3]['status_user']);
        for (int i = 0; i < _users.length; i++) {
          inputs.add(setBool(_users[i]['status_user']));
        }
      });
    }
  }

  void ItemChange(bool val, int index, String userid) {
    setState(() {
      inputs[index] = val;
      print(userid);
      submitAkses(userid, inputs[index].toString());
      print(_loading);
    });
  }

  Future submitAkses(String userid, String val) async {
    setState(() {
      _loading = true;
    });
    //server login api
    var url =
        'https://www.nabasa.co.id/api_remon_v1/tes.php/submitAksesImarsyt';
    //starting web api call
    var response = await http.post(url, body: {'userid': userid, 'akses': val});
    if (response.statusCode == 200) {
      var message = jsonDecode(response.body)['Response_Submit'];
      print(message);
      if (message == 'Save Success') {
        setState(() {
          _loading = false;
        });
      } else {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  String _id(dynamic user) {
    return user['id'];
  }

  String _userid(dynamic user) {
    return user['userid'];
  }

  String _nama(dynamic user) {
    return user['nama'];
  }

  String _namaKaryawan(dynamic user) {
    return user['nama_karyawan'];
  }

  bool _statusUser(dynamic user) {
    if (user['status_user'] == 'true') {
      return true;
    } else {
      return false;
    }
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
          'Account iMarsyt',
          style: GoogleFonts.aBeeZee(
            fontStyle: FontStyle.normal,
          ),
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

  _ImarsytScreen() {
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
                  },
                  child: Column(
                    children: <Widget>[
                      SwitchListTile(
                        title: Text(
                          _namaKaryawan(_users[index]),
                          style: GoogleFonts.aBeeZee(
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                        subtitle: Text(
                          _userid(_users[index]),
                          style: GoogleFonts.aBeeZee(
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                        value: inputs[index],
                        onChanged: (bool value) {
                          ItemChange(value, index, _userid(_users[index]));
                        },
                        secondary: Icon(
                          Icons.person,
                          size: 40,
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
}
