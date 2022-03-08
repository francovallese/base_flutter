import 'package:base/pagine/percorso.dart';
import 'package:flutter/material.dart';
import '../utili/variabili/costanti.dart';
import '../route/funz.dart';
import '../utili/utile.dart';
import 'package:base/utili/variabili/global.dart' as globali;

class Page3 extends StatelessWidget implements Percorribile {
  const Page3({Key? key}) : super(key: key);

  double get altezza => Costanti.altezzaBarra;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight((globali.gruppoRadioMenu == 2)
            ? altezza
            : altezza),
        child: AppBar(
          leading: getFrecciaIndietro(context),
          backgroundColor: Costanti.coloreBgAppBar,
          title: getZonaTitolo(context,"Pagina 3",altezza,this),

        ),
      ),
      body: corpo(),
    );
  }

  corpo() {
    return const Center(
      child: Text('Pagina 3'),
    );
  }

  void fai1(BuildContext context, int f) {
    Utili.mostraMessaggio(context, 'Eseguo Funzione ' + f.toString(), 'msg');
  }

  void fai2(BuildContext context, int f) {
    Utili.mostraMessaggio(context, 'Eseguo Funzione ' + f.toString(), 'msg');
  }

  @override
  List<String> percorso() {
    return ['m.1', 'm.2'];
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
      case 2:
        fai2(context, funz);
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
    return [Icons.work, Icons.account_tree, Icons.warning];
    ///  Icons.warning non usata e non da errore
    //throw UnimplementedError();
  }

  @override
  List<String> testoCalamaio() {
    return ["F1", "F2"];
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
