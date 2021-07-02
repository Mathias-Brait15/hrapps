import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hrapps/constanta.dart';
import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:photo_view/photo_view.dart';
import 'package:toast/toast.dart';

class DetailApprovalInsentifAgenScreen extends StatefulWidget {
  String id;
  String namaDebitur;
  String nomorAplikasi;
  String branch;
  String plafond;
  String namaAgen;
  String tanggalInput;
  String verifikasiAkuntan;
  String path1;
  String path2;
  String path3;

  DetailApprovalInsentifAgenScreen(
    this.id,
    this.namaDebitur,
    this.nomorAplikasi,
    this.branch,
    this.plafond,
    this.namaAgen,
    this.tanggalInput,
    this.verifikasiAkuntan,
    this.path1,
    this.path2,
    this.path3,
  );
  @override
  _DetailApprovalInsentifAgenScreenState createState() =>
      _DetailApprovalInsentifAgenScreenState();
}

class _DetailApprovalInsentifAgenScreenState
    extends State<DetailApprovalInsentifAgenScreen> {
  List imgList;
  List imgText;
  bool _loadingA = false;
  bool _loadingR = false;

  Future dialogLoading(bool _loadingA, String _text) async {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        Future.delayed(
          Duration(seconds: 3),
          () {
            if (_loadingA == false) {
              Navigator.of(context).pop();
              Toast.show(
                _text,
                context,
                duration: Toast.LENGTH_SHORT,
                gravity: Toast.BOTTOM,
                backgroundColor: Colors.red,
              );
            }
          },
        );

        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                  height: 20,
                  width: 20,
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future approvalInteraksi() async {
    //showing CircularProgressIndicator
    setState(() {
      _loadingA = true;
    });
    var url =
        'https://www.nabasa.co.id/api_remon_v1/tes.php/ApprovalDisbursmentBisnis';

    //starting web api call
    var response = await http.post(url, body: {
      'id_pencairan': widget.id.toString(),
    });

    if (response.statusCode == 200) {
      var message =
          jsonDecode(response.body)['Update_Approval_Disbursment_Agen'];
      print(message);
      if (message == 'Save Success') {
        setState(() {
          _loadingA = false;
        });
      } else {
        setState(() {
          _loadingA = false;
        });
      }
    }
  }

  Future rejectInteraksi() async {
    //showing CircularProgressIndicator
    setState(() {
      _loadingR = true;
    });
    var url =
        'https://www.nabasa.co.id/api_remon_v1/tes.php/RejectDisbursmentBisnis';

    //starting web api call
    var response = await http.post(url, body: {
      'id_pencairan': widget.id.toString(),
    });

    if (response.statusCode == 200) {
      var message = jsonDecode(response.body)['Update_Reject_Disbursment_Agen'];
      if (message.toString() == 'Save Success') {
        setState(() {
          _loadingR = false;
        });
      } else {
        setState(() {
          _loadingR = false;
        });
        Toast.show(
          'Pencairan gagal ditolak...',
          context,
          duration: Toast.LENGTH_SHORT,
          gravity: Toast.BOTTOM,
          backgroundColor: Colors.red,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String foto1 = 'https://www.nabasa.co.id/marsit/' + widget.path1;
    String foto2 = 'https://www.nabasa.co.id/marsit/' + widget.path2;
    String foto3 = 'https://www.nabasa.co.id/marsit/' + widget.path3;
    imgList = [foto1, foto2, foto3];
    imgText = ['Foto Akad', 'Foto Tanda Tangan Akad', 'Foto Bukti Dana Cair'];
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: Text(
            '${widget.namaAgen}',
            style: GoogleFonts.aBeeZee(
              fontStyle: FontStyle.normal,
              color: Colors.white,
            ),
          ),
        ),
        body: Container(
          padding:
              EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 16.0),
          child: ListView(
            physics: ClampingScrollPhysics(),
            children: <Widget>[
              Card(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  //color: Colors.white,
                  padding: EdgeInsets.only(
                      left: 16.0, top: 16.0, right: 16.0, bottom: 16.0),
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        _buildBannerMenu(),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: <Widget>[
                            Tooltip(
                              message: 'Nama Debitur',
                              child: Icon(
                                Icons.person,
                                color: Colors.black54,
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Expanded(
                              child: Text(
                                '${setNull(widget.namaDebitur)}',
                                style: GoogleFonts.aBeeZee(
                                    fontStyle: FontStyle.normal,
                                    color: Colors.black54,
                                    fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: <Widget>[
                            Tooltip(
                              message: 'Nomor Aplikasi',
                              child: Icon(
                                MdiIcons.application,
                                color: Colors.black54,
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Expanded(
                              child: Text(
                                '${setNull(widget.nomorAplikasi)}',
                                style: GoogleFonts.aBeeZee(
                                    fontStyle: FontStyle.normal,
                                    color: Colors.black54,
                                    fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: <Widget>[
                            Tooltip(
                              message: 'Branch',
                              child: Icon(
                                MdiIcons.office,
                                color: Colors.black54,
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Expanded(
                              child: Text(
                                '${setNull(widget.branch)}',
                                style: GoogleFonts.aBeeZee(
                                    fontStyle: FontStyle.normal,
                                    color: Colors.black54,
                                    fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: <Widget>[
                            Tooltip(
                              message: 'Plafond',
                              child: Icon(
                                Icons.attach_money,
                                color: Colors.black54,
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Expanded(
                              child: Text(
                                '${setNull(formatRupiah(widget.plafond))}',
                                style: GoogleFonts.aBeeZee(
                                    fontStyle: FontStyle.normal,
                                    color: Colors.black54,
                                    fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: <Widget>[
                            Tooltip(
                              message: 'Tanggal Input',
                              child: Icon(
                                Icons.date_range,
                                color: Colors.black54,
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Expanded(
                              child: Text(
                                '${setNull(widget.tanggalInput)}',
                                style: GoogleFonts.aBeeZee(
                                    fontStyle: FontStyle.normal,
                                    color: Colors.black54,
                                    fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: <Widget>[
                            Tooltip(
                              message: 'Verifikasi Akuntan',
                              child: Icon(
                                Icons.approval,
                                color: Colors.black54,
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Expanded(
                              child: Text(
                                '${setVerifikasiAkuntan(setNull(widget.verifikasiAkuntan))}',
                                style: GoogleFonts.aBeeZee(
                                    fontStyle: FontStyle.normal,
                                    color: Colors.black54,
                                    fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                  margin: EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.40,
                        child: FlatButton(
                          color: Colors.blue,
                          onPressed: () {
                            dialogLoading(_loadingA, "Approval success");
                            approvalInteraksi();
                          },
                          child: Text(
                            'Setuju',
                            style: GoogleFonts.aBeeZee(
                              fontStyle: FontStyle.normal,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.40,
                        child: FlatButton(
                          color: Colors.redAccent,
                          onPressed: () {
                            dialogLoading(_loadingR, "Reject success");
                            rejectInteraksi();
                          },
                          child: Text(
                            'Tolak',
                            style: GoogleFonts.aBeeZee(
                              fontStyle: FontStyle.normal,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBannerMenu() {
    final List<Widget> imageSliders = imgList
        .map((item) => Container(
              child: Container(
                margin: EdgeInsets.all(5.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    child: Stack(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () async {
                            await showDialog(
                              context: context,
                              builder: (_) => Dialog(
                                child: PhotoView(
                                  imageProvider: NetworkImage(item),
                                  backgroundDecoration:
                                      BoxDecoration(color: Colors.transparent),
                                ),
                              ),
                            );
                          },
                          child: Image.network(item, fit: BoxFit.fill),
                        ),
                        Positioned(
                          bottom: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
                            decoration: BoxDecoration(),
                            padding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            child: Text(
                              '',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            ))
        .toList();
    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: true,
        aspectRatio: 2.0,
        enlargeCenterPage: true,
      ),
      items: imageSliders,
    );
  }

  setNull(String data) {
    if (data == null || data == '') {
      return 'NULL';
    } else {
      return data;
    }
  }

  setVerifikasiAkuntan(String data) {
    if (data == '1') {
      return 'Sudah Verifikasi Akuntan';
    } else {
      return 'Belum Verifikasi Akuntan';
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
