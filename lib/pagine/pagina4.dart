import 'package:base/pagine/percorso.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../utili/solidi/solido.dart';
import '../utili/variabili/costanti.dart';
import '../route/funz.dart';
import '../utili/utile.dart';
import 'package:base/utili/variabili/global.dart' as globali;
enum Orientamento {verticale,orizzontale}
class Page4 extends StatefulWidget {
  const Page4({Key? key}) : super(key: key);
  @override
  _Page4ConStato createState() => _Page4ConStato();
}

class _Page4ConStato extends State<Page4> implements Percorribile {
  double zoom = 0;
  double get altezza => Costanti.altezzaBarra;

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var orientamento = MediaQuery.of(context).orientation;
    //debugPrint("orientamento"+orientamento.toString());
    if (zoom == 0) {
      zoom = MediaQuery.of(context).size.width / 8;
      if(orientamento == Orientamento.orizzontale) {
        zoom = MediaQuery.of(context).size.width / 10;
      }
    }
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight((globali.gruppoRadioMenu == 2) ? altezza : altezza),
        child: AppBar(
          leading: getFrecciaIndietro(context),
          backgroundColor: Costanti.coloreBgAppBar,
          title: getZonaTitolo(context, "3D", altezza, this),
        ),
      ),
      body: corpo(context),
    );
  }

  corpo(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: Colors.blueGrey,
      child: Listener(
          onPointerSignal: (pointerSignal) {
            if (pointerSignal is PointerScrollEvent) {
              if (pointerSignal.scrollDelta.direction > 0) {
                zoom = zoom - 10;
              } else {
                zoom = zoom + 10;
              }
              setState(() {});
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                  alignment: Alignment.centerLeft,
                  child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Solido(
                        zoom: zoom,
                        path: Costanti.cubo,
                        alfaXini:15,
                        alfaYini:150,
                      ))),
              Container(
                  alignment: Alignment.centerRight,
                  child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Solido(
                        zoom: zoom+20,
                        path: Costanti.tetraedro,
                        alfaXini:15,
                        alfaYini:150,
                      ))),
            ],
          )),
    );
  }

//Utili.mostraMessaggio(context, 'Eseguo Funzione ' + f.toString(), 'msg');
  void fai1(BuildContext context, int f) {
    zoom = zoom + 10;
    setState(() {});
  }

  void fai2(BuildContext context, int f) {
    zoom = zoom - 10;
    setState(() {});
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
    return true;
    //throw UnimplementedError();
  }

  @override
  List<Icone> listaIcone() {
    return [Icone('Zoom+', Icons.zoom_in), Icone('Zoom-', Icons.zoom_out)];
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
