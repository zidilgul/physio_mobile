import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'package:physio/models/bolgeComboResultDto.dart';
import 'package:physio/src/config/app_settings.dart';


class BolgeComboService{

  final _url = Uri.http(PhysioAppSettings.BaseUrl, "api/BodyPart");

  Future<List<BolgeResultDto>> getBolgeler () async {

    final http.Response response = await http.get(
        _url,
        headers: <String,String>{
          'Content-Type': 'application/json',
        });

    if(response.statusCode == 200){

      dynamic sonuc = json.decode(response.body);

      List<BolgeResultDto> temp = (sonuc as List).map((e) => BolgeResultDto.fromDatabaseJson(e)).toList();

      return temp;

    }else{
      print(json.decode(response.body).toString());
      throw Exception(json.decode(response.body));
    }

  }
}