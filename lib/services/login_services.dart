import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:physio/helpers/storage_helper.dart';
import 'package:physio/models/loginDto.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:physio/models/loginResultDto.dart';
import 'package:physio/src/config/app_settings.dart';

class LoginService {
  final _url = Uri.http(PhysioAppSettings.BaseUrl, 'api/Auth/Login');

  Future<LoginResultDto> Login (LoginDto userLogin) async{
    var jsonData = null;
    var data = null;

    final http.Response response = await http.post(
      _url, headers: <String,String>{
        'Content-Type' :'application/json; charset=UTF-8'
    },
      body: jsonEncode(userLogin.toDatabaseJson()),
    );

    if(response.statusCode == 200){
      LoginResultDto kullanici = LoginResultDto.fromDatabaseJson(json.decode(response.body));
      PhysioAppSettings.user = kullanici;
      data = kullanici;
      await UserSecureStorage.setUser(data);
      jsonData = json.decode(response.body);
      kullanici.basariDurumu = true;
      return kullanici;

    }else
      print(json.decode(response.body).toString());
    return LoginResultDto(basariDurumu: false, id: 0,fullName: "",isDoctor: false,userName: "",password: "");
  }
}