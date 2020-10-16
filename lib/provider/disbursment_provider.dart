import 'package:hrapps/model/disbursment_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DisbursmentProvider extends ChangeNotifier {
  List<DisbursmentModel> _data = [];
  List<DisbursmentModel> get dataDisbursment => _data;

  Future<List<DisbursmentModel>> getDisbursment() async {
    final url =
        'https://www.nabasa.co.id/api_marsit_v1/tes.php/getDisbursmentNotification';
    final response = await http.get(url);
    //final response = await http.get(url);

    if (response.statusCode == 200) {
      final result = json
          .decode(response.body)['Daftar_Disbursment']
          .cast<Map<String, dynamic>>();
      _data = result
          .map<DisbursmentModel>((json) => DisbursmentModel.fromJson(json))
          .toList();
      return _data;
    } else {
      throw Exception();
    }
  }
}
