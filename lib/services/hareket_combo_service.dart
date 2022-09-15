import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:physio/models/hareketlerComboResultDto.dart';
import 'package:physio/models/hastalarListeResultDto.dart';
import 'dart:async';

import '../src/config/app_settings.dart';

class HareketlerimListeService{

  // final _url = Uri.http(PhysioAppSettings.BaseUrl, "api/Patients/");

  Future<List<HareketlerResultDto>> getHareketler (bodyPartId) async {

    final requestURL =
    Uri.http(PhysioAppSettings.BaseUrl,'api/Move/'+bodyPartId.toString());

    final http.Response response = await http.get(
        requestURL,
        headers: <String,String>{
          'Content-Type': 'application/json',
        });

    if(response.statusCode == 200){

      dynamic sonuc = json.decode(response.body);

      List<HareketlerResultDto> temp = (sonuc as List).map((e) => HareketlerResultDto.fromDatabaseJson(e)).toList();

      return temp;

    }else{
      print(json.decode(response.body).toString());
      throw Exception(json.decode(response.body));
    }

  }

}