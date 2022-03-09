import 'package:base/pagine/percorso.dart';
import 'package:base/utili/variabili/costanti.dart';
import 'package:base/utili/variabili/global.dart' as globali;
import 'package:flutter/material.dart';

import '../route/funz.dart';
import '../utili/albero/tree_data.dart';
import '../utili/albero/tree_view.dart';
import '../utili/utile.dart';

class Page1 extends StatefulWidget {
  const Page1({Key? key}) : super(key: key);
  @override
  _Page1ConStato createState() => _Page1ConStato();
}

class _Page1ConStato extends State<Page1> implements Percorribile {
  double altezza = Costanti.altezzaBarra;

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(
              (globali.gruppoRadioMenu == 2) ? altezza : altezza),
          child: AppBar(
            backgroundColor: Costanti.coloreBgAppBar,
            title: getZonaTitolo(context, Costanti.titoloApp, altezza, this),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              corpo(),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                height: 10,
                thickness: 0,
                indent: 0,
                endIndent: 0,
                color: Colors.blue,
              ),
              miaApp()
            ],
          ),
          //),
        ));
  }

  corpo() {
    return TreeView(context: context,
      data: treeMenu,
    );
  }

  miaApp() {
    return TreeView(context: context,
      data: treeApp,
    );
  }

  @override
  List<String> percorso() {
    return ['p.2.0', 'p.3.0', 'm.1'];
    //throw UnimplementedError();
  }

  @override
  List<String> indirizzo() {
    return ['/page2', '/page3'];
    //throw UnimplementedError();
  }

  Future<void> fai1(BuildContext context, int f) async {
    String msg =
        "RADIO SCELTA funzione " + f.toString() + "\n Scelta Menu con:";
    List<String> scelte = Costanti.scelteGruppoOpzioniMenu;
    int inEvidenza = globali.gruppoRadioMenu;
    //debugPrint("PRIMA GLOBAL:"+inEvidenza.toString());
    await Utili.mostraRadioScelta(context, scelte, inEvidenza, msg, this);
    //debugPrint("DOPO GLOBAL:"+globali.gruppoRadioMenu.toString());
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
  void disegnaPagina() {
    setState(() {
      //getValue();
    });
  }

  @override
  bool getAbilitato(int funz) {
    return true;
    //throw UnimplementedError();
  }

  @override
  List<IconData> iconaCalamaio() {
    return [Icons.archive, Icons.search, Icons.warning];
    //throw UnimplementedError();
  }

  @override
  List<String> testoCalamaio() {
    return ["Pagina 2", "Pagina 3", "Es. Radio test"];
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
