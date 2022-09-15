import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:physio/models/loginResultDto.dart';

class UserSecureStorage{
  static final _storage = FlutterSecureStorage();
  
  static const _id = 'id';
  static const _name = 'fullName';

  static Future setUser(LoginResultDto user) async {
    await _storage.write(key: _id, value: user.id.toString());
    await _storage.write(key: _name, value: user.fullName);

  }

  static Future<LoginResultDto?> getUser()async {
    await _storage.read(key: _id);
    await _storage.read(key: _name);
  }
}