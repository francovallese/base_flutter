import 'package:base/utili/database/sql_helper.dart';
import 'package:flutter/material.dart';

class Costanti {
  static const String fileProperties = 'app_settings';
  // BARRA ANGOLO DESTRO IN ALTO (DEBUG)
  static const bool barraRossa = true;
  // TIPO GRAFICA MENU
  static const List<String> scelteGruppoOpzioniMenu = [
    "Icone",
    "Testo",
    "Icone+Testo"
  ];
  static const int icone = 0;
  static const int testo = 1;
  static const int iconeConTtesto = 2;
  //PARAMETRI MENU
  static double defaultBarra = 6;
  static double altezzaBarra =
      SQLHelper.os == 'Android' ? 40.0 + defaultBarra : 40;
  static const Color coloreBgAppBar = Colors.white30;
  static const Color coloreBgCalamaioPag = Colors.blue;
  static const Color coloreBgCalamaioMenu = Colors.green;
  static const Color coloreBgCalamaioMenuO = Colors.lightGreen;
  static const Color coloreIconaMenu = Colors.black;
  static const Color coloreIconaMenuO = Colors.blueGrey;
  static const Color coloreTitoloBarra = Colors.blue;
  static const Color coloreFrecciaBack = Colors.black;

  static const String titolo = 'Titolo';
  static const String titoloApp = 'Home';
  // PATH DATABASE
  static const String nomeDB = 'mydb.db';
  static const String nomeTAB = 'items';
  static const String nomeAndroidDB = 'assets/db/mydb.db';
  static const String nomeLinuxDB = '/home/franco/Documenti/mydb.db';
  static const String nomeWindowsDB = 'mydb.db';
  // COLORI RECORD
  static const Color coloreBgRecord = Colors.grey;
  static const Color coloreBgRecordSelezionato = Colors.purpleAccent;
  //FUNZIONI
  static const int listaRecord = 0;
  static const int nuovoRecord = 1;
  static const int variaRecord = 2;
  static const int cancellaRecord = 3;
  static const int ricercaRecord = 4;
  static const int evidenzaRecord = 5;

  // TIPO LISTA
  static bool completa = true; // se false RICERCA

  static double larghezzaEvidenzaRecord =
      SQLHelper.os == 'Android' ? 60.0 * 90 / 100 : 60;
  static double altezzaEvidenzaRecord =
      SQLHelper.os == 'Android' ? 40.0 * 80 / 100 : 40;

  static IconData device = SQLHelper.os == 'Web'
      ? Icons.chrome_reader_mode
      : SQLHelper.os == 'Android'
          ? Icons.phone_android
          : Icons.computer;
  static int animazioneMillisec = 25;
}
