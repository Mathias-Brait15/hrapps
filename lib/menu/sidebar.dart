import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hrapps/Employee/employee_screen.dart';
import 'package:hrapps/approval/approval_screen.dart';
import 'package:hrapps/constanta.dart';
import 'package:hrapps/insentif_agent/insentif_agent_screen.dart';
import 'package:hrapps/penjualan/penjualan_screen.dart';
import 'package:hrapps/provider/disbursment_hari_ini_provider.dart';
import 'package:hrapps/provider/interaction_hari_ini_provider.dart';
import 'package:hrapps/sales/sales_screen.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'dart:convert';

import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class SideBar extends StatefulWidget {
  @override
  SideBar() : super();
  final String title = "Charts Demo";
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  String token;
  String tokenU;

  final tokenController = TextEditingController();
  final tokenUController = TextEditingController();
  bool sidebarOpen = false;

  double yOffset = 0;

  double xOffset = 60;

  void setSidebarState() {
    setState(() {
      xOffset = sidebarOpen ? 265 : 60;
    });
  }

  List<charts.Series> seriesList;
  final String url =
      'https://www.nabasa.co.id/api_remon_v1/tes.php/getSalesChart';
  List data = List();
  var bulan = new List(6);
  var month = new List(6);
  bool visible = false;

  Future<String> getSalesChart() async {
    setState(() {
      visible = true;
    });
    var res = await http
        .get(Uri.encodeFull(url), headers: {'accept': 'application/json'});
    if (res.statusCode == 200) {
      var resBody = json.decode(res.body)['Daftar_Sales'];
      setState(() {
        data = resBody;
        month[0] = data[0]['month1'];
        month[1] = data[0]['month2'];
        month[2] = data[0]['month3'];
        month[3] = data[0]['month4'];
        month[4] = data[0]['month5'];
        month[5] = data[0]['month6'];
        bulan[0] = int.parse(data[0]['bulan1']);
        bulan[1] = int.parse(data[0]['bulan2']);
        bulan[2] = int.parse(data[0]['bulan3']);
        bulan[3] = int.parse(data[0]['bulan4']);
        bulan[4] = int.parse(data[0]['bulan5']);
        bulan[5] = int.parse(data[0]['bulan0']);
        visible = false;
        List<charts.Series<Sales, String>> _createRandomData() {
          final desktopSalesData = [
            new Sales(setBulan(month[5].toString()), bulan[5]),
            new Sales(setBulan(month[4].toString()), bulan[0]),
            new Sales(setBulan(month[3].toString()), bulan[1]),
            new Sales(setBulan(month[2].toString()), bulan[2]),
            new Sales(setBulan(month[1].toString()), bulan[3]),
            new Sales(setBulan(month[0].toString()), bulan[4]),
          ];
          return [
            new charts.Series<Sales, String>(
                id: 'Sales',
                colorFn: (_, __) =>
                    charts.MaterialPalette.blue.shadeDefault.darker,
                domainFn: (Sales sales, _) => sales.year,
                measureFn: (Sales sales, _) => sales.sales,
                data: desktopSalesData,
                labelAccessorFn: (Sales sales, _) =>
                    '${formatRupiah(sales.sales.toString())}')
          ];
        }

        seriesList = _createRandomData();
      });
    }
  }

  barChart() {
    return charts.BarChart(
      seriesList,
      animate: true,
      vertical: false,
      barRendererDecorator: new charts.BarLabelDecorator<String>(),
      // Hide domain axis.
    );
  }

  final String urlx =
      'https://www.nabasa.co.id/api_remon_v1/tes.php/getVersion';
  String versionId;
  String versionIdApp = '1.0.2';

  Future<String> getAppVersion() async {
    // MEMINTA DATA KE SERVER DENGAN KETENTUAN YANG DI ACCEPT ADALAH JSON
    var res = await http
        .get(Uri.encodeFull(urlx), headers: {'accept': 'application/json'});
    if (res.statusCode == 200) {
      var resBody = json.decode(res.body)['Daftar_Version'];
      setState(() {
        versionId = resBody[0]['version_id'];
        print(versionId);
      });
    }
  }

  String title = "title";
  String content = "content";

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    OneSignal.shared
        .init("b7387dcc-9cf2-4bab-8c1a-bae7aa375639", iOSSettings: null);
    OneSignal.shared
        .setInFocusDisplayType(OSNotificationDisplayType.notification);
    OneSignal.shared
        .setNotificationReceivedHandler((OSNotification notification) {
      setState(() {
        title = notification.payload.title;
        title = notification.payload.body;
      });
    });
    OneSignal.shared.setNotificationOpenedHandler(
        (OSNotificationOpenedResult notification) {
      print("notifikasi di tap");
    });
    getSalesChart();
    getAppVersion();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Color(0xFF19194d),
        title: Text(
          'Dashboard',
          style: GoogleFonts.aBeeZee(fontStyle: FontStyle.normal),
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 93.0,
              child: DrawerHeader(
                child: Text(
                  'Remon',
                  style: GoogleFonts.aBeeZee(
                      fontStyle: FontStyle.normal, color: Colors.white),
                ),
                decoration: BoxDecoration(color: Color(0xFF19194d)),
              ),
            ),
            ListTile(
              leading: Icon(
                MdiIcons.verified,
                color: Colors.blueGrey,
                size: 35,
              ),
              title: Text(
                'Approval',
                style: GoogleFonts.aBeeZee(
                    fontStyle: FontStyle.normal, color: Colors.blueGrey),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => new AlertDialog(
                    title: new Text("KODE AKSES",
                        style: GoogleFonts.aBeeZee(
                          fontStyle: FontStyle.normal,
                        )),
                    content: fieldToken(),
                    actions: <Widget>[
                      FlatButton(
                        color: Colors.purple,
                        child: Text('Masuk',
                            style: GoogleFonts.aBeeZee(
                                fontStyle: FontStyle.normal,
                                color: Colors.white)),
                        onPressed: () {
                          token = tokenController.text;
                          print(token);
                          if (token == '777333') {
                            Navigator.of(context).pop();
                            tokenController.clear();
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ApprovalScreen()));
                          } else {
                            Toast.show(
                              'KODE AKSES SALAH',
                              context,
                              duration: Toast.LENGTH_SHORT,
                              gravity: Toast.BOTTOM,
                              backgroundColor: Colors.red,
                            );
                          }
                        },
                      )
                    ],
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.people_outline,
                color: Colors.blueGrey,
                size: 35,
              ),
              title: Text(
                'Karyawan',
                style: GoogleFonts.aBeeZee(
                    fontStyle: FontStyle.normal, color: Colors.blueGrey),
              ),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => EmployeeScreen()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.bar_chart,
                color: Colors.blueGrey,
                size: 35,
              ),
              title: Text(
                'Peringkat',
                style: GoogleFonts.aBeeZee(
                    fontStyle: FontStyle.normal, color: Colors.blueGrey),
              ),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SalesScreen()));
              },
            ),
            ListTile(
              leading: Icon(
                MdiIcons.bank,
                color: Colors.blueGrey,
                size: 35,
              ),
              title: Text(
                'Pencairan',
                style: GoogleFonts.aBeeZee(
                    fontStyle: FontStyle.normal, color: Colors.blueGrey),
              ),
              onTap: () {
                Toast.show(
                  'Coming Soon',
                  context,
                  duration: Toast.LENGTH_SHORT,
                  gravity: Toast.BOTTOM,
                  backgroundColor: Colors.red,
                );
              },
            ),
            ListTile(
              leading: Icon(
                MdiIcons.monitor,
                color: Colors.blueGrey,
                size: 35,
              ),
              title: Text(
                'Monitoring',
                style: GoogleFonts.aBeeZee(
                    fontStyle: FontStyle.normal, color: Colors.blueGrey),
              ),
              onTap: () {
                Toast.show(
                  'Coming Soon',
                  context,
                  duration: Toast.LENGTH_SHORT,
                  gravity: Toast.BOTTOM,
                  backgroundColor: Colors.red,
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.monetization_on_outlined,
                color: Colors.blueGrey,
                size: 35,
              ),
              title: Text(
                'Insentif Agent',
                style: GoogleFonts.aBeeZee(
                    fontStyle: FontStyle.normal, color: Colors.blueGrey),
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => InsentifAgentScreen()));
              },
            ),
            ListTile(
              leading: Icon(
                MdiIcons.logout,
                color: Colors.blueGrey,
                size: 35,
              ),
              title: Text(
                'Utility',
                style: GoogleFonts.aBeeZee(
                    fontStyle: FontStyle.normal, color: Colors.blueGrey),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => new AlertDialog(
                    title: new Text("KODE AKSES",
                        style:
                            GoogleFonts.aBeeZee(fontStyle: FontStyle.normal)),
                    content: fieldTokenU(),
                    actions: <Widget>[
                      FlatButton(
                        color: Colors.purple,
                        child: Text('Masuk',
                            style: GoogleFonts.aBeeZee(
                                fontStyle: FontStyle.normal,
                                color: Colors.white)),
                        onPressed: () {
                          tokenU = tokenUController.text;
                          print(tokenU);
                          if (tokenU == '010101') {
                            Navigator.of(context).pop();
                            tokenUController.clear();
                            Navigator.pushNamed(context, '/utility');
                          } else {
                            Toast.show(
                              'KODE AKSES SALAH',
                              context,
                              duration: Toast.LENGTH_SHORT,
                              gravity: Toast.BOTTOM,
                              backgroundColor: Colors.red,
                            );
                          }
                        },
                      )
                    ],
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(
                MdiIcons.shipWheel,
                color: Colors.blueGrey,
                size: 35,
              ),
              title: Text(
                'Lottery',
                style: GoogleFonts.aBeeZee(
                    fontStyle: FontStyle.normal, color: Colors.blueGrey),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/wheel');
              },
            ),
          ],
        ),
      ),
      body: visible
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
              ),
            )
          : ListView(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                      left: 16.0, right: 16.0, top: 16.0, bottom: 16.0),
                  child: Text('Pencairan 6 bulan terakhir',
                      style: GoogleFonts.aBeeZee(
                          fontStyle: FontStyle.normal, color: Colors.blueGrey)),
                ),
                Container(
                  color: Colors.white,
                  height: 300,
                  padding: EdgeInsets.all(16.0),
                  child: barChart(),
                ),
                Container(
                  padding: EdgeInsets.only(
                      left: 16.0, right: 16.0, top: 16.0, bottom: 16.0),
                  child: Text('Pencairan hari ini',
                      style: GoogleFonts.aBeeZee(
                          fontStyle: FontStyle.normal, color: Colors.blueGrey)),
                ),
                Container(
                  color: Colors.white,
                  height: 280,
                  padding: EdgeInsets.all(16.0),
                  child: sliderPencairanCurrent(),
                ),
                Container(
                  padding: EdgeInsets.only(
                      left: 16.0, right: 16.0, top: 16.0, bottom: 16.0),
                  child: Text('Interaksi hari ini',
                      style: GoogleFonts.aBeeZee(
                          fontStyle: FontStyle.normal, color: Colors.blueGrey)),
                ),
                Container(
                  color: Colors.white,
                  height: 280,
                  padding: EdgeInsets.all(16.0),
                  child: sliderInteraksiCurrent(),
                ),
              ],
            ),
    ));
  }

  Widget fieldToken() {
    return TextFormField(
      controller: tokenController,
      validator: (value) {
        if (value.isEmpty) {
          return 'Kode akses tidak boleh kosong...';
        }
        return null;
      },
      decoration: InputDecoration(
          //Add th Hint text here.
          hintText: "Masukkan Kode Akses",
          hintStyle: TextStyle(fontFamily: 'Montserrat Regular'),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          labelText: "Masukkan Kode Akses"),
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        WhitelistingTextInputFormatter.digitsOnly
      ],
      style: TextStyle(fontSize: 12, fontFamily: 'Montserrat Regular'),
    );
  }

  Widget fieldTokenU() {
    return TextFormField(
      controller: tokenUController,
      validator: (value) {
        if (value.isEmpty) {
          return 'Kode akses tidak boleh kosong...';
        }
        return null;
      },
      decoration: InputDecoration(
          //Add th Hint text here.
          hintText: "Masukkan Kode Akses",
          hintStyle: TextStyle(fontFamily: 'Montserrat Regular'),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          labelText: "Masukkan Kode Akses"),
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        WhitelistingTextInputFormatter.digitsOnly
      ],
      style: TextStyle(fontSize: 12, fontFamily: 'Montserrat Regular'),
    );
  }

  setBulan(String bulan) {
    switch (bulan) {
      case '01':
        return 'Jan';
        break;
      case '02':
        return 'Feb';
        break;
      case '03':
        return 'Mar';
        break;
      case '04':
        return 'Apr';
        break;
      case '05':
        return 'Mei';
        break;
      case '06':
        return 'Jun';
        break;
      case '07':
        return 'Jul';
        break;
      case '08':
        return 'Agu';
        break;
      case '09':
        return 'Sep';
        break;
      case '10':
        return 'Okt';
        break;
      case '11':
        return 'Nov';
        break;
      case '12':
        return 'Des';
        break;
    }
  }

  Widget sliderPencairanCurrent() {
    return SizedBox(
      height: 200,
      child: FutureBuilder(
        future: Provider.of<DisbursmentHariIniProvider>(context, listen: false)
            .getDisbursment(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor)),
            );
          }
          return Consumer<DisbursmentHariIniProvider>(
            builder: (context, data, _) {
              if (data.dataDisbursment.length == 0) {
                return Center(
                  child:
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Icon(
                          Icons.hourglass_empty_outlined,
                          size: 50,
                          color: Colors.red.shade400,
                        ),
                      ),
                    ),
                    Text(
                      'Belum Tersedia',
                      style: GoogleFonts.aBeeZee(
                          fontStyle: FontStyle.normal, color: Colors.blueGrey),
                    ),
                  ]),
                );
              } else {
                return ListView.builder(
                  itemCount: data.dataDisbursment.length,
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
                                      'SALES',
                                      setNull(data
                                          .dataDisbursment[index].namaSales)),
                                  namaField(
                                      'BRANCH',
                                      setNull(
                                          data.dataDisbursment[index].cabang)),
                                  namaField(
                                      'DEBITUR',
                                      setNull(
                                          data.dataDisbursment[index].debitur)),
                                  namaField(
                                      'PLAFOND',
                                      setNull(formatRupiah(data
                                          .dataDisbursment[index].plafond))),
                                  namaField(
                                      'JENIS KREDIT',
                                      setNull(data.dataDisbursment[index]
                                          .statusKredit)),
                                  namaField(
                                      'NO AKAD',
                                      setNull(data
                                          .dataDisbursment[index].nomorAkad)),
                                  namaField(
                                      'AKAD',
                                      setNull(data
                                          .dataDisbursment[index].tanggalAkad)),
                                  namaField(
                                      'PENCAIRAN',
                                      setNull(data.dataDisbursment[index]
                                              .tanggalPencairan +
                                          ' ' +
                                          data.dataDisbursment[index]
                                              .jamPencairan)),
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
                                      data.dataDisbursment[index].foto2,
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(top: 8.0),
                                    ),
                                    Text(
                                      data.dataDisbursment[index].namaSales,
                                      style: GoogleFonts.aBeeZee(
                                          fontStyle: FontStyle.normal,
                                          color: Colors.black,
                                          fontSize: 10),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 8.0),
                                    ),
                                    Text(
                                      data.dataDisbursment[index].cabang,
                                      style: GoogleFonts.aBeeZee(
                                          fontStyle: FontStyle.normal,
                                          color: Colors.black,
                                          fontSize: 10),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 8.0),
                                    ),
                                    Text(
                                      formatRupiah(
                                          data.dataDisbursment[index].plafond),
                                      style: GoogleFonts.aBeeZee(
                                          fontStyle: FontStyle.normal,
                                          color: Colors.black,
                                          fontSize: 10),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          );
        },
      ),
    );
  }

  Widget sliderInteraksiCurrent() {
    return SizedBox(
      height: 200,
      child: FutureBuilder(
        future: Provider.of<InteractionHariIniProvider>(context, listen: false)
            .getInteraction(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor)),
            );
          }
          return Consumer<InteractionHariIniProvider>(
            builder: (context, data, _) {
              if (data.dataInteraction.length == 0) {
                return Center(
                  child:
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Icon(
                          Icons.hourglass_empty_outlined,
                          size: 50,
                          color: Colors.red.shade400,
                        ),
                      ),
                    ),
                    Text(
                      'Belum Tersedia',
                      style: GoogleFonts.aBeeZee(
                          fontStyle: FontStyle.normal, color: Colors.blueGrey),
                    ),
                  ]),
                );
              } else {
                return ListView.builder(
                  itemCount: data.dataInteraction.length,
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
                                      'SALES',
                                      setNull(data
                                          .dataInteraction[index].namaSales)),
                                  namaField(
                                      'BRANCH',
                                      setNull(
                                          data.dataInteraction[index].branch)),
                                  namaField(
                                      'DEBITUR',
                                      setNull(data.dataInteraction[index]
                                          .namaPensiunan)),
                                  namaField(
                                      'JAM',
                                      setNull(data.dataInteraction[index]
                                          .jamKunjungan)),
                                  namaField(
                                      'KETERANGAN',
                                      setNull(data
                                          .dataInteraction[index].keterangan)),
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
                                      data.dataInteraction[index].foto1,
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(top: 8.0),
                                    ),
                                    Text(
                                      data.dataInteraction[index].namaSales,
                                      style: GoogleFonts.aBeeZee(
                                          fontStyle: FontStyle.normal,
                                          color: Colors.black,
                                          fontSize: 10),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 8.0),
                                    ),
                                    Text(
                                      data.dataInteraction[index].branch,
                                      style: GoogleFonts.aBeeZee(
                                          fontStyle: FontStyle.normal,
                                          color: Colors.black,
                                          fontSize: 10),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 8.0),
                                    ),
                                    Text(
                                      data.dataInteraction[index].namaPensiunan,
                                      style: GoogleFonts.aBeeZee(
                                          fontStyle: FontStyle.normal,
                                          color: Colors.black,
                                          fontSize: 10),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          );
        },
      ),
    );
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
                      fontStyle: FontStyle.normal, color: Colors.black),
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
                        fontStyle: FontStyle.normal, color: Colors.black),
                  ))),
        ],
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

  setNull(String data) {
    if (data == null || data == '') {
      return 'NULL';
    } else {
      return data;
    }
  }
}

class Sales {
  final String year;
  final int sales;

  Sales(this.year, this.sales);
}
