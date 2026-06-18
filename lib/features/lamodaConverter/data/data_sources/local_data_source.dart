import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../dto/lamoda_dto.dart';

abstract interface class LamodaLocalDataSource {
  Future<void> setPath(LamodaDto lamodaDto);
  Future<LamodaDto?> getPath();
}

class LamodaLocalDataSourceImp implements LamodaLocalDataSource{
  final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();
  static const String _key = 'utils_lamoda';

  @override
  Future<void> setPath(LamodaDto lamodaDto) => 
      asyncPrefs.setString(_key, jsonEncode(lamodaDto.toJson()));

  @override
  Future<LamodaDto?> getPath() async {
    final json = await asyncPrefs.getString(_key);
    return json == null ? null : LamodaDto.fromJson(jsonDecode(json)); 
  }
}