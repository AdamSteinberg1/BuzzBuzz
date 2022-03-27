import 'package:shared_preferences/shared_preferences.dart';

class Options {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  int? _buzzMode;

  Options();

  Future<int> getBuzzMode() {
    if (_buzzMode == null) {
      return _readMode();
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
}