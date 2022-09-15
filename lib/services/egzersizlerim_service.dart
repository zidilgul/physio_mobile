import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:physio/models/egzersizlerimResultDto.dart';
import 'dart:async';

import '../src/config/app_settings.dart';

class EgzersizlerimService{

  // final _url = Uri.https(PhysioAppSettings.BaseUrl, "api/PatientsMove");

  Future<List<EgzersizlerimResultDto>> getEgzersizListe (id) async {

    final requestURL =
    Uri.http(PhysioAppSettings.BaseUrl, 'api/PatientsMove/'+id.toString());

    final http.Response response = await http.get(
        requestURL,
        headers: <String,String>{
          'Content-Type': 'application/json',
        });

    if(response.statusCode == 200){

      dynamic sonuc = json.decode(response.body);

      List<EgzersizlerimResultDto> temp = (sonuc as List).map((e) => EgzersizlerimResultDto.fromDatabaseJson(e)).toList();

      return temp;

    }else{
      print(json.decode(response.body).toString());
      throw Exception(json.decode(response.body));
    }

  }
}