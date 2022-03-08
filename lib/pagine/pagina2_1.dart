import 'package:base/pagine/percorso.dart';
import 'package:base/utili/database/sql_helper.dart';
import 'package:base/utili/variabili/costanti.dart';
import 'package:flutter/material.dart';
import '../utili/utile.dart';
import '../route/funz.dart';
import 'package:base/utili/variabili/global.dart' as globali;

class Page2sub1 extends StatelessWidget implements Percorribile {
  const Page2sub1({Key? key}) : super(key: key);

  String get dispositivo => globali.pathDbDispositivo;
  String get origine => globali.pathDbOrigine;
  double get altezza => Costanti.altezzaBarra;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight((globali.gruppoRadioMenu == 2) ? altezza : altezza),
        child: AppBar(
          leading: getFrecciaIndietro(context),
          backgroundColor: Costanti.coloreBgAppBar,
          title: getZonaTitolo(context, "INFO DB", altezza, this),
        ),
      ),
      body: corpo(context),
    );
  }

  corpo(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),

      /// width & heigth USATI DA CANVAS
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: const CanvasConImmagini(),
    );
  }

  void fai1(BuildContext context, int f) {
    if (SQLHelper.os == 'Web') {
      String msg = "Il FIRESTORE database contiene una sola raccolta items"
          "\n i cui campi sono:"
          "\n-id          NUMBER,"
          "\n-title       STRING,"
          "\n-description STRING,"
          "\n-createdAt   TIMESTAMP.";

      Utili.mostraMessaggio(context, 'FIRESTORE database', msg);
    } else {
      String msg = "Il database contiene una sola talella i cui campi sono:"
          "\n-id          INTEGER\nPRIMARY KEY AUTOINCREMENT NOT NULL,"
          "\n-title       TEXT,"
          "\n-description TEXT,"
          "\n-createdAt   TIMESTAMP\n NOT NULL DEFAULT CURRENT_TIMESTAMP";

      Utili.mostraMessaggio(context, 'I 4 campi della tabella items', msg);
    }
  }

  @override
  List<String> percorso() {
    //return ['m.1'  ,''     ,''   ];
    return ['m.1'];
    //throw UnimplementedError();
  }

  @override
  List<String> indirizzo() {
    return [];
    //throw UnimplementedError();
  }

  @override
  void esegui(BuildContext context, int funz) {
    switch (funz) {
      case 1:
        fai1(context, funz);
        break;
      default:
        debugPrint('choose a different number!');
    }
  }

  @override
  void disegnaPagina() {}
  @override
  bool getAbilitato(int funz) {
    return true;
    //throw UnimplementedError();
  }

  @override
  List<IconData> iconaCalamaio() {
    return [Icons.info_outline, Icons.warning, Icons.warning];
    //throw UnimplementedError();
  }

  @override
  List<String> testoCalamaio() {
    if (SQLHelper.os == 'Web') {
      return ["FIREBASE FIRESTORE"];
    } else {
      return ["SQL(create table)"];
    }
    //throw UnimplementedError();
  }

  @override
  void cambiaNumRecordInEvidenza(
      String nuovoNumero, bool clickUtente, int tipoFunzione) {
    // TODO: implement cambiaNumRecordInEvidenza
  }
  @override
  String getNumRecordInEvidenza() {
    return "0";
    //throw UnimplementedError();
  }
}
