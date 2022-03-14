import 'package:base/pagine/percorso.dart';
import 'package:flutter/material.dart';
import '../utili/database/sql_helper.dart';
import '../utili/variabili/costanti.dart';
import '../route/funz.dart';
import '../utili/utile.dart';
import 'package:base/utili/variabili/global.dart' as globali;

class Page3 extends StatefulWidget  {
  const Page3({Key? key}) : super(key: key);
  @override
  _Page3ConStato createState() => _Page3ConStato();
}
class _Page3ConStato extends State<Page3> implements Percorribile{

  double get altezza => Costanti.altezzaBarra;
  late final PaginaConVideo? video;
  @override
  initState() {
    if(SQLHelper.os == 'Linux') {
      video = null;
    }
    else {
      video = const PaginaConVideo();
    }
    super.initState();
  }
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
          title: getZonaTitolo(context,"Video",altezza,this),

        ),
      ),
      body: corpo( context),
    );
  }

  corpo(BuildContext context) {
    if(SQLHelper.os == 'Linux') {
      return  const Center(child: Text('Sorry'));
    }
    else {

      return Container(
        alignment: Alignment.center,
        color: Colors.transparent,
        margin: const EdgeInsets.all(10),
        child: video,
      );
    }
  }

  void fai1(BuildContext context, int f) {
    if(video != null) {
      video?.pausa();
    }
    //Utili.mostraMessaggio(context, 'Eseguo Funzione ' + f.toString(), 'msg');
  }

  void fai2(BuildContext context, int f) {
    //Utili.mostraMessaggio(context, 'Eseguo Funzione ' + f.toString(), 'msg');
    if(video != null) {
      video?.play();
    }

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
    if (!getAbilitato(funz)) {
      Utili.mostraMessaggioFondoPagina(context, "MENU' NON ATTIVO");
      return;
    }

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
    if(video != null) {
      return true;
    }
    else {
      return false;
    }
    //throw UnimplementedError();
  }
/*
  @override
  List<IconData> iconaCalamaio() {
    return const [Icons.pause, Icons.play_arrow, Icons.warning];
    ///  Icons.warning non usata e non da errore
    //throw UnimplementedError();
  }

 */
  @override
  List<Icone> listaIcone(){
    return [
      Icone('Pause',Icons.pause),
      Icone('Play',Icons.play_arrow)
    ];
  }
  /*
  @override
  List<String> testoCalamaio() {
    return ["Pause", "Play"];
    //throw UnimplementedError();
  }

   */

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
