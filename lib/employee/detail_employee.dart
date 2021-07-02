import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hrapps/constanta.dart';
import 'package:hrapps/provider/disbursment_provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class DetailEmployee extends StatefulWidget {
  String nik;
  String namaKaryawan;
  String email;
  String telepon;
  String tglAwalKontrak;
  String tglAkhirKontrak;
  String branch;
  String alamat;
  String kelurahan;
  String kecamatan;
  String kabupaten;
  String propinsi;
  String kodePos;
  String tglLahir;
  String tempatLahir;
  String jenisKelamin;
  String statusKaryawan;
  String divisiKaryawan;
  String jabatanKaryawan;
  String salesLeader;
  String jmlPencairan;
  String jmlInteraksi;
  String nikmarsit;
  String jenisData;
  String tarif;
  String pict;

  DetailEmployee(
    this.nik,
    this.namaKaryawan,
    this.email,
    this.telepon,
    this.tglAwalKontrak,
    this.tglAkhirKontrak,
    this.branch,
    this.alamat,
    this.kelurahan,
    this.kecamatan,
    this.kabupaten,
    this.propinsi,
    this.kodePos,
    this.tglLahir,
    this.tempatLahir,
    this.jenisKelamin,
    this.statusKaryawan,
    this.divisiKaryawan,
    this.jabatanKaryawan,
    this.salesLeader,
    this.jmlPencairan,
    this.jmlInteraksi,
    this.nikmarsit,
    this.jenisData,
    this.tarif,
    this.pict,
  );
  @override
  _DetailEmployee createState() => _DetailEmployee();
}

class _DetailEmployee extends State<DetailEmployee> {
  bool _isLoading = false;
  final String apiUrl =
      'https://www.nabasa.co.id/api_marsit_v1/index.php/getDisbursment';
  List<dynamic> _users = [];

  void fetchUsers() async {
    setState(() {
      _isLoading = true;
    });
    var result = await http.post(apiUrl, body: {'nik_sales': widget.nikmarsit});
    if (result.statusCode == 200) {
      setState(() {
        if (json.decode(result.body)['Daftar_Disbursment'] == '') {
          _isLoading = false;
        } else {
          _users = json.decode(result.body)['Daftar_Disbursment'];
          _isLoading = false;
        }
      });
    }
  }

  String _id(dynamic user) {
    return user['id'];
  }

  String _debitur(dynamic user) {
    return user['debitur'];
  }

  String _nomorAkad(dynamic user) {
    return user['nomor_akad'];
  }

  String _plafond(dynamic user) {
    return user['plafond'];
  }

  String _cabang(dynamic user) {
    return user['cabang'];
  }

  String _tanggalAkad(dynamic user) {
    return user['tanggal_akad'];
  }

  String _alamat(dynamic user) {
    return user['alamat'];
  }

  String _telepon(dynamic user) {
    return user['telepon'];
  }

  String _noJanji(dynamic user) {
    return user['no_janji'];
  }

  String _jenisPencairan(dynamic user) {
    return user['jenis_pencairan'];
  }

  String _jenisProduk(dynamic user) {
    return user['jenis_produk'];
  }

  String _infoSales(dynamic user) {
    return user['info_sales'];
  }

  String _foto1(dynamic user) {
    return user['foto1'];
  }

  String _foto2(dynamic user) {
    return user['foto2'];
  }

  String _foto3(dynamic user) {
    return user['foto3'];
  }

  String _tanggalPencairan(dynamic user) {
    return user['tgl_pencairan'];
  }

  String _jamPencairan(dynamic user) {
    return user['jam_pencairan'];
  }

  String _statusPencairan(dynamic user) {
    return user['status_pencairan'];
  }

  String _statusBayar(dynamic user) {
    return user['status_bayar'];
  }

  String _approvalSl(dynamic user) {
    return user['approval_sl'];
  }

  String _namaTl(dynamic user) {
    return user['nama_tl'];
  }

  String _jabatanTl(dynamic user) {
    return user['jabatan_tl'];
  }

  String _teleponTl(dynamic user) {
    return user['telepon_tl'];
  }

  String _namaSales(dynamic user) {
    return user['namasales'];
  }

  String _statusKredit(dynamic user) {
    return user['status_kredit'];
  }

  Future<void> _getData() async {
    setState(() {
      fetchUsers();
    });
  }

  Future<void> _launched;
  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  String interaksi;
  String pencairan;

  void setJenisData() {
    if (widget.jenisData == 'all') {
      interaksi = 'total interaksi selama bergabung';
      pencairan = 'total pencairan selama bergabung';
    } else {
      interaksi = 'total interaksi bulan ini';
      pencairan = 'total pencairan bulan ini';
    }
  }

  void initState() {
    super.initState();
    setJenisData();
    fetchUsers();
  }

  void launchWhatsApp({
    @required String phone,
    @required String message,
  }) async {
    String url() {
      return "whatsapp://send?phone=$phone&text=${Uri.parse(message)}";
    }

    if (await canLaunch(url())) {
      await launch(url());
    } else {
      throw 'Could not launch ${url()}';
    }
  }

  void _createEmail({@required String email}) async {
    String emailaddress() {
      return 'mailto:$email?subject=Sample Subject&body=This is a Sample email';
    }

    if (await canLaunch(emailaddress())) {
      await launch(emailaddress());
    } else {
      throw 'Could not Email';
    }
  }

  @override
  Widget build(BuildContext context) {
    String foto =
        'https://www.nabasa.co.id/marsit/' + widget.pict.replaceAll('\\', '/');
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: Text(
            'Detail Karyawan',
            style: GoogleFonts.aBeeZee(
                fontStyle: FontStyle.normal, color: Colors.white),
          ),
          actions: [
            IconButton(
              onPressed: () {
                _createEmail(email: widget.email);
              },
              icon: Icon(MdiIcons.email),
              iconSize: 20,
            ),
            IconButton(
              onPressed: () {
                String teleponFix = '+62' + widget.telepon.substring(1);
                launchWhatsApp(phone: teleponFix, message: 'Hallo,');
              },
              icon: Icon(MdiIcons.whatsapp),
              iconSize: 20,
            ),
            IconButton(
              onPressed: () {
                _makePhoneCall('tel:${widget.telepon}');
              },
              icon: Icon(Icons.call),
              iconSize: 20,
            )
          ],
        ),
        body: Container(
          child: ListView(
            children: [
              Column(
                children: [
                  Stack(
                    overflow: Overflow.visible,
                    alignment: Alignment.center,
                    children: <Widget>[
                      Image(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height / 3,
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          'https://images.unsplash.com/photo-1470104240373-bc1812eddc9f?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1000&q=80',
                        ),
                      ),
                      Positioned(
                        bottom: -60.0,
                        child: CircleAvatar(
                          radius: 80,
                          backgroundColor: Colors.white,
                          backgroundImage: NetworkImage(
                            foto,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 60),
                  ListTile(
                    title: Center(
                        child: Text(
                      widget.namaKaryawan,
                      style: GoogleFonts.aBeeZee(
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                    subtitle: Center(
                      child: Text(
                        setJabatan(
                          widget.jabatanKaryawan,
                          widget.statusKaryawan,
                        ),
                        style: GoogleFonts.aBeeZee(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.05,
                    child: Card(
                      elevation: 2,
                      child: ListTile(
                        title: Text(
                          'Interaksi',
                          style: GoogleFonts.aBeeZee(
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          interaksi,
                          style: GoogleFonts.aBeeZee(
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: Text(
                          widget.jmlInteraksi + ' Orang',
                          style: GoogleFonts.aBeeZee(
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.05,
                    child: Card(
                      elevation: 2,
                      child: ListTile(
                        title: Text(
                          'Pencairan',
                          style: GoogleFonts.aBeeZee(
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          pencairan,
                          style: GoogleFonts.aBeeZee(
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: Text(
                          formatRupiah(widget.jmlPencairan),
                          style: GoogleFonts.aBeeZee(
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Pencairan bulan ini',
                              style: GoogleFonts.aBeeZee(
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  sliderPencairanCurrent(),
                  Container(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Informasi Pribadi',
                              style: GoogleFonts.aBeeZee(
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(16.0),
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'NIK',
                              style: GoogleFonts.aBeeZee(
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                            Text(
                              setNull(widget.nik),
                              style: GoogleFonts.aBeeZee(
                                fontStyle: FontStyle.normal,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.all(16.0),
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Branch',
                              style: GoogleFonts.aBeeZee(
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                            Text(
                              setNull(widget.branch),
                              style: GoogleFonts.aBeeZee(
                                fontStyle: FontStyle.normal,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.all(16.0),
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Tempat,Tgl Lahir',
                              style: GoogleFonts.aBeeZee(
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                            Text(
                              setNull(
                                widget.tempatLahir + ',' + widget.tglLahir,
                              ),
                              style: GoogleFonts.aBeeZee(
                                fontStyle: FontStyle.normal,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.all(16.0),
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Join Date',
                              style: GoogleFonts.aBeeZee(
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                            Text(
                              setNull(widget.tglAwalKontrak),
                              style: GoogleFonts.aBeeZee(
                                fontStyle: FontStyle.normal,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.all(16.0),
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Expired',
                              style: GoogleFonts.aBeeZee(
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                            Text(
                              setNull(widget.tglAkhirKontrak),
                              style: GoogleFonts.aBeeZee(
                                fontStyle: FontStyle.normal,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.all(16.0),
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Tarif',
                              style: GoogleFonts.aBeeZee(
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                            Text(
                              setNull(widget.tarif) + ' %',
                              style: GoogleFonts.aBeeZee(
                                fontStyle: FontStyle.normal,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.all(16.0),
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Sales Leader',
                              style: GoogleFonts.aBeeZee(
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                            Text(
                              setNull(widget.salesLeader),
                              style: GoogleFonts.aBeeZee(
                                fontStyle: FontStyle.normal,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget sliderPencairanCurrent() {
    print(_users.length);
    if (_isLoading == true) {
      return Center(child: CircularProgressIndicator());
    } else {
      if (_users.length > 0) {
        return SizedBox(
          height: 200,
          child: ListView.builder(
            itemCount: _users.length,
            physics: ClampingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return InkWell(
                onLongPress: () {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        color: Colors.white,
                        child: Column(
                          children: <Widget>[
                            namaField(
                                'SALES', setNull(_namaSales(_users[index]))),
                            namaField(
                                'BRANCH', setNull(_cabang(_users[index]))),
                            namaField(
                                'DEBITUR', setNull(_debitur(_users[index]))),
                            namaField('PLAFOND',
                                setNull(formatRupiah(_plafond(_users[index])))),
                            namaField('JENIS KREDIT',
                                setNull(_statusKredit(_users[index]))),
                            namaField(
                                'NO AKAD', setNull(_nomorAkad(_users[index]))),
                            namaField(
                                'AKAD', setNull(_tanggalAkad(_users[index]))),
                            namaField(
                                'PENCAIRAN',
                                setNull(_tanggalPencairan(_users[index]) +
                                    ' ' +
                                    _jamPencairan(_users[index]))),
                          ],
                        ),
                      );
                    },
                  );
                },
                onTap: () {},
                child: Card(
                  elevation: 2,
                  margin: EdgeInsets.all(8),
                  child: Container(
                    width: 150,
                    child: Column(
                      children: <Widget>[
                        Image(
                          width: double.infinity,
                          height: 150,
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            'https://nabasa.co.id/marsit/' +
                                _foto2(_users[index]),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 8.0),
                        ),
                        Text(
                          formatRupiah(_plafond(_users[index])),
                          style: GoogleFonts.aBeeZee(
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
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

  Widget namaField(title, nama) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(12),
      child: Stack(
        children: <Widget>[
          Align(
              alignment: Alignment.centerLeft,
              child: Container(
                child: Text(
                  title,
                  style: GoogleFonts.aBeeZee(
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              )),
          Align(
              alignment: Alignment.centerRight,
              child: Container(
                  width: MediaQuery.of(context).size.width * 0.80,
                  child: Text(
                    nama,
                    textAlign: TextAlign.right,
                    style: GoogleFonts.aBeeZee(
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ))),
        ],
      ),
    );
  }

  setJabatan(String jabatan, String statusKaryawan) {
    if (jabatan == '88' || jabatan == '83') {
      return 'Sales Leader';
    } else if (jabatan == '81' && statusKaryawan != '5') {
      return 'Marketing Representative';
    } else if (statusKaryawan == '5') {
      return 'Marketing Agent';
    } else {
      return 'Staff Office';
    }
  }

  setNull(String data) {
    if (data != null) {
      return data;
    } else {
      return 'Null';
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
