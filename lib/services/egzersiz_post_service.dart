import 'package:http/http.dart' as http;
import 'package:physio/models/islemSonucDto.dart';

import 'dart:convert';

import 'package:physio/models/patientsMoveResultDto.dart';

import '../src/config/app_settings.dart';

class PatientMovePostService{
  final _url = Uri.http(PhysioAppSettings.BaseUrl, 'api/PatientsMove/NewPatientMove' );

  Future<IslemSonucDto> postHareketlerim (PatientsMoveResultDto requestDto) async {

    final http.Response response = await http.post(_url,headers: <String,String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
        body: jsonEncode(requestDto.toDatabaseJson())
    );

    if(response.statusCode == 200){


      return IslemSonucDto(basariDurumu: true);

    }else{
      throw Exception(response.body);
    }
  }
}