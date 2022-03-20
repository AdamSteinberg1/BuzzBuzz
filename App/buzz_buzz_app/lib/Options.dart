import 'dart:io';
import 'package:path_provider/path_provider.dart';


class Options {
  int? _buzzMode;
  File? _buzzModeFile;

  Options() {
    _getBuzzModeFile().then((buzzModeFile) {
      _buzzModeFile = buzzModeFile;
      _readMode().then((buzzMode) => (_buzzMode = buzzMode));
    });
  }

  Future<int> getBuzzMode() {
    if (_buzzMode == null) {
      return _readMode();
    } else {
      return Future.value(_buzzMode);
    }
  }

  void setBuzzMode(int mode) {
    _buzzMode = mode;
    _writeMode(_buzzMode!);
  }

  Future<File> _getBuzzModeFile() async{
    Directory dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/OptionsData.txt');
  }

  void _writeMode(int mode) async{
    _buzzModeFile ??= await _getBuzzModeFile();
    _buzzModeFile!.writeAsString("$mode");
  }
  Future<int> _readMode() async{
    _buzzModeFile ??= await _getBuzzModeFile();
    String contents = await _buzzModeFile!.readAsString();
    return int.tryParse(contents) ?? 0;
  }
}