import 'package:http/http.dart' as http;
import 'package:physio/models/islemSonucDto.dart';
import 'package:physio/models/newClickDto.dart';

import 'dart:convert';

import 'package:physio/models/patientsMoveResultDto.dart';

import '../src/config/app_settings.dart';

class ClickPostService{
  final _url = Uri.http(PhysioAppSettings.BaseUrl, 'api/LastClicked' );

  Future<IslemSonucDto> postClick (NewClickDto newClickDto) async {

    final http.Response response = await http.post(_url,headers: <String,String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
        body: jsonEncode(newClickDto.toDatabaseJson())
    );

    if(response.statusCode == 200){


      return IslemSonucDto(basariDurumu: true);

    }else{
      throw Exception(response.body);
    }
  }
}