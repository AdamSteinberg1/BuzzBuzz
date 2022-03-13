import 'dart:io';
import 'package:path_provider/path_provider.dart';


class Options {
  static Future<String> getLocalPath() async{
    var dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  static Future<File> getLocalFile() async{
    String path = await getLocalPath();
    return File('$path/OptionsData.txt');
  }

  static Future<File> write(String s) async{
    File file = await getLocalFile();
    return file.writeAsString(s);
  }
  static Future<String> read() async{
    try{
      final file= await getLocalFile();
      String contents = await file.readAsString();
      return contents;
    }catch(e){
      return "Null";
    }
  }
}