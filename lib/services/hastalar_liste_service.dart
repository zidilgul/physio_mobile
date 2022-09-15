import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:physio/models/hastalarListeResultDto.dart';
import 'dart:async';

import '../src/config/app_settings.dart';

class HastalarListeService{

  // final _url = Uri.http(PhysioAppSettings.BaseUrl, "api/Patients/");

  Future<List<HastalarListeResultDto>> getHastaListe (id) async {

    final requestURL =
    Uri.http(PhysioAppSettings.BaseUrl,'api/Patients/'+id.toString());

    final http.Response response = await http.get(
        requestURL,
      headers: <String,String>{
        'Content-Type': 'application/json',
      });

    if(response.statusCode == 200){

      dynamic sonuc = json.decode(response.body);

      List<HastalarListeResultDto> temp = (sonuc as List).map((e) => HastalarListeResultDto.fromDatabaseJson(e)).toList();

      return temp;

    }else{
      print(json.decode(response.body).toString());
      throw Exception(json.decode(response.body));
    }

  }

}