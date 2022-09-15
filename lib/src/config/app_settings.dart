import 'package:flutter/cupertino.dart';
import 'package:physio/models/loginResultDto.dart';

class PhysioAppSettings{
  static PhysioAppSettings? _instance;
  static const String ProjectName = "Physio";
  //static const String BaseUrl = '192.168.1.2:5000';
  static const String BaseUrl = 'localhost:5000';
  static late BuildContext currentContext;
  static LoginResultDto? user;

  factory PhysioAppSettings() => _instance ??= PhysioAppSettings._();
  PhysioAppSettings._();
}