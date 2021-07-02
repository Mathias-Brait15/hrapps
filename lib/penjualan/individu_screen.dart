import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

class IndividuScreen extends StatefulWidget {
  @override
  _IndividuScreen createState() => _IndividuScreen();
}

class _IndividuScreen extends State<IndividuScreen> {
  var selectedJenis;
  List<String> _jenisType = <String>[
    'DAFTAR PENCAPAIAN',
    'REKAP PENCAPAIAN',
    'RINCIAN PENCAPAIAN',
  ];

  var selectedNamaSales;

  String teleponMitra;
  final formKey = GlobalKey<FormState>();
  bool _loading = false;

  final String url =
      'https://www.nabasa.co.id/api_remon_v1/tes.php/getNamaSales';
  List data = List();

  Future<String> getNamaSales() async {
    // MEMINTA DATA KE SERVER DENGAN KETENTUAN YANG DI ACCEPT ADALAH JSON
    var res = await http
        .get(Uri.encodeFull(url), headers: {'accept': 'application/json'});
    var resBody = json.decode(res.body)['Data_Nama_Sales'];
    setState(() {
      data = resBody;
      print(data);
    });
  }

  final teleponMitraController = TextEditingController();

  Future saveDisbursment() async {
    setState(() {
      _loading = true;
    });
    //getting value from controller
    teleponMitra = teleponMitraController.text;

    //server save api
    var url = 'https://www.nabasa.co.id/api_marsit_v1/index.php/saveMitra';

    //starting web api call
    var response = await http.post(url, body: {
      "telepon": teleponMitra,
    });

    if (response.statusCode == 200) {
      var message = jsonDecode(response.body)['Save_Mitra'];
      if (message.toString() == 'Save Success') {
        setState(() {
          _loading = false;
          teleponMitraController.clear();
        });
        Toast.show(
          'Sukses mendaftar sebagai mitra, silahkan menunggu proses verifikasi dari kami...',
          context,
          duration: Toast.LENGTH_SHORT,
          gravity: Toast.BOTTOM,
          backgroundColor: Colors.red,
        );
      } else if (message.toString() == 'Mitra Ada') {
        setState(() {
          _loading = false;
        });
        Toast.show(
          'Nomor KTP ini sudah terdaftar sebagai mitra,mohon masukkan nomor KTP lain...',
          context,
          duration: Toast.LENGTH_SHORT,
          gravity: Toast.BOTTOM,
          backgroundColor: Colors.red,
        );
      } else {
        setState(() {
          _loading = false;
          teleponMitraController.clear();
        });
        Toast.show(
          'Gagal mendaftar sebagai mitra, silahkan mencoba kembali...',
          context,
          duration: Toast.LENGTH_SHORT,
          gravity: Toast.BOTTOM,
          backgroundColor: Colors.red,
        );
      }
    }
  }

  void initState() {
    super.initState();
    this.getNamaSales();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Sales',
            style: TextStyle(fontFamily: 'Montserrat Regular'),
          ),
        ),
        body: Container(
          padding:
              EdgeInsets.only(left: 16.0, right: 16.0, top: 0.0, bottom: 0.0),
          child: Form(
            key: formKey,
            child: ListView(
              physics: ClampingScrollPhysics(),
              children: <Widget>[
                fieldJenis(),
                fieldNamaSales(),
                fieldFilter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget fieldJenis() {
    return DropdownButtonFormField(
        items: _jenisType
            .map((value) => DropdownMenuItem(
                  child: Text(
                    value,
                    style: TextStyle(
                        fontFamily: 'Montserrat Regular', fontSize: 12),
                  ),
                  value: value,
                ))
            .toList(),
        onChanged: (selectedJenisType) {
          setState(() {
            selectedJenis = selectedJenisType;
          });
        },
        decoration: InputDecoration(
            labelText: 'Jenis',
            contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            labelStyle:
                TextStyle(fontFamily: 'Montserrat Regular', fontSize: 12)),
        value: selectedJenis,
        isExpanded: true);
  }

  Widget fieldNamaSales() {
    return DropdownButtonFormField(
        items: data
            .map((value) => DropdownMenuItem(
                  child: Text(
                    value['nama_karyawan'],
                    style: TextStyle(
                        fontFamily: 'Montserrat Regular', fontSize: 12),
                  ),
                  value: value['nik'].toString(),
                ))
            .toList(),
        onChanged: (selectedNamaSalesType) {
          setState(() {
            selectedNamaSales = selectedNamaSalesType;
          });
        },
        decoration: InputDecoration(
            labelText: 'Sales',
            contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            labelStyle:
                TextStyle(fontFamily: 'Montserrat Regular', fontSize: 12)),
        value: selectedNamaSales,
        isExpanded: true);
  }

  Widget fieldFilter() {
    return RaisedButton(
      color: Colors.teal,
      child: Text(
        'Cari',
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        print(1);
      },
    );
  }
}
