import 'package:hrapps/model/interaction_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InteractionHariIniProvider extends ChangeNotifier {
  List<InteractionModel> _data = [];
  List<InteractionModel> get dataInteraction => _data;

  Future<List<InteractionModel>> getInteraction() async {
    final url =
        'https://www.nabasa.co.id/api_remon_v1/tes.php/getInteractionHariIni';
    final response = await http.get(url);
    //final response = await http.get(url);

    if (response.statusCode == 200) {
      final result = json
          .decode(response.body)['Daftar_Interaksi']
          .cast<Map<String, dynamic>>();
      _data = result
          .map<InteractionModel>((json) => InteractionModel.fromJson(json))
          .toList();
      return _data;
    } else {
      throw Exception();
    }
  }
}
