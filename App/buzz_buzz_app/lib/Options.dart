import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class Options {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  int? _buzzMode;
  double? _restingHeartrate;
  Options();

  Future<int> getBuzzMode() {
    if (_buzzMode == null) {
      return _readMode().then((value) => _buzzMode=value);
    } else {
      return Future.value(_buzzMode);
    }
  }

  void setBuzzMode(int mode) {
    _buzzMode = mode;
    _writeMode(mode);
  }

  void _writeMode(int mode) async{
    final SharedPreferences prefs = await _prefs;
    prefs.setInt("buzzMode", mode);
  }
  Future<int> _readMode() async{
    final SharedPreferences prefs = await _prefs;
    return prefs.getInt("buzzMode") ?? 0;
  }

  Future<double?> getRestingHeartrate() {
    if (_restingHeartrate == null) {
      return _readRestingHeartrate().then((value) => _restingHeartrate = value);
    } else {
      return Future.value(_restingHeartrate);
    }
  }

  Future<double?> _readRestingHeartrate() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getDouble("restingHeartrate");
  }

  void setRestingHeartrate(double heartrate) {
    _restingHeartrate = heartrate;
    _writeRestingHeartrate(heartrate);
  }

  void _writeRestingHeartrate(double heartrate) async{
    final SharedPreferences prefs = await _prefs;
    prefs.setDouble("restingHeartrate", heartrate);
  }
}