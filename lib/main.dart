import 'package:base/route/rotta.dart';
import 'package:base/utili/database/sql_helper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:base/utili/variabili/global.dart' as globali;
/// IN LINUX
/// MODIFICARE IN Costanti.dart
/// static const String nomeLinuxDB = '/home/franco/Documenti/mydb.db';
/// IN Terminal prima del comando :  flutter run -d linux
///  CHROME_EXECUTABLE=/snap/bin/chromium; export CHROME_EXECUTABLE
///  nel caso si usi chromium
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (SQLHelper.os == 'Windows' || SQLHelper.os == 'Linux') {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  SQLHelper.caricaDb().then((value){
    debugPrint("PIATTAFORMA:" + SQLHelper.os);
    //debugPrint("main per dispositivo:" + globali.pathDbDispositivo);
    //debugPrint("main ori dispositivo:" + globali.pathDbOrigine);
  });

  final prefs = await SharedPreferences.getInstance();
  try {
    globali.gruppoRadioMenu = prefs.getInt('gruppoRadioMenu')!;

  }
  catch(e){
    globali.gruppoRadioMenu = 0;
  }

  //var xx = await GlobalConfiguration().loadFromAsset(Costanti.fileProperties);
  //globali.gruppoRadioMenu = xx.get('gruppoRadioMenu');
  runApp(
    const MaterialApp(
      onGenerateRoute: RottaPagine.generateRoute,
      initialRoute: '/', //'/page1'
    ),
  );
}