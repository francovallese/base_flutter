import 'dart:async';
import 'package:base/pagine/percorso.dart';
import 'package:base/pagine/scorrimento.dart';
import 'package:flutter/material.dart';
import '../utili/database/invarca_funzioni.dart';
import '../utili/database/sql_helper.dart';
import '../utili/database/visual.dart';
import '../route/funz.dart';
import '../utili/utile.dart';
import '../utili/variabili/costanti.dart';
import 'package:base/utili/variabili/global.dart' as globali;
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class Page2 extends StatefulWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  _Page2ConStato createState() => _Page2ConStato();
}

class _Page2ConStato extends State<Page2> implements Percorribile, Scorribile {
  double altezza = Costanti.altezzaBarra;
  late int funzione;
  final int primo = 0;
  late String strRecordInEvidenza;
  late bool vuota;
  late bool tipoLista;
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  @override
  initState() {
    SQLHelper.percorribile = this;
    MyVisual.percorribile = this;
    MyVisual.scorribile = this;
    MyInvarcaFunzioni.percorribile = this;
    MyInvarcaFunzioni.getLista();
    tipoLista = Costanti.completa;
    funzione = -1;
    strRecordInEvidenza = '-1'; // FRANCO se elimino la riga mi da errore
    vuota = false;
    super.initState();
  }

  @override
  List<String> percorso() {
    return ['p.2.1', 'm.1', 'm.2', 'm.3', 'm.4'];
    //throw UnimplementedError();
  }

  @override
  List<String> indirizzo() {
    return ['/page2/page2_1'];
    //throw UnimplementedError();
  }

  @override
  List<IconData> iconaCalamaio() {
    return [
      Icons.info_outline,
      Icons.add,
      Icons.edit,
      Icons.delete,
      Icons.search_rounded
    ];
    //throw UnimplementedError();
  }

  @override
  List<String> testoCalamaio() {
    return ["Info DB", "Nuovo", "Varia", "Cancella", "Cerca per titolo"];
    //throw UnimplementedError();
  }

  @override
  void cambiaNumRecordInEvidenza(
      String nuovoNumero, bool clickUtente, int tipoFunzione) {
    /*
    debugPrint(
        "nuovoNumero" + nuovoNumero + " tipoLista " + tipoLista.toString());
    */
    strRecordInEvidenza = nuovoNumero;

    if (clickUtente) {
      funzione = Costanti.evidenzaRecord;
    } else {
      funzione = tipoFunzione;
    }
    disegnaPagina();
  }

  @override
  String getNumRecordInEvidenza() {
    return strRecordInEvidenza;
    //throw UnimplementedError();
  }

  /// CHIAMATA SOLO QUANDO PREMO IL CALAMAIO DIVENTATO UN MENU
  @override
  Future<void> esegui(BuildContext context, int funz) async {
    funzione = funz;
    if (!getAbilitato(funzione)) {
      Utili.mostraMessaggioFondoPagina(context, "MENU' NON ATTIVO");
      return;
    }
    await calcola().whenComplete(() {
      if (funzione == Costanti.ricercaRecord) {
        return;
      }
      //debugPrint("dopo calcola " + tipoLista.toString());
    });
  }

  @override
  void disegnaPagina() {
/*
    debugPrint("DIPINGO con funzione " +
        funzione.toString() +
        " evi " +
        strRecordInEvidenza);
*/
    int pos = evidenza();

    setState(() {
      //getValue();
    });
    if (pos == -1) {
      return;
    }
    if ((funzione == Costanti.nuovoRecord ||
            funzione == Costanti.cancellaRecord) &&
        pos >= 0) {
      /*
      debugPrint(
          "mostraFine con " + pos.toString() + " sre " + strRecordInEvidenza);
      */
      mostraFine(pos);
    }
  }

  @override
  void mostraFine(int index) {
    itemScrollController.jumpTo(index: index, alignment: 0.5);
  }

  @override
  bool getAbilitato(int funz) {
    //debugPrint("vuota: "+ vuota.toString()+ " funz = "+funz.toString());
    if (tipoLista == Costanti.completa) {
      if (vuota && funzione > 1) return false;
    }
    if (tipoLista == !Costanti.completa) {
      // FASE RICERCA SOLO UNA VOLTA (PER SEMPLIFICARE)
      if (funzione >= Costanti.nuovoRecord) return false;
    }

    return true;

    //throw UnimplementedError();
  }

  @override
  ItemScrollController getItemScrollController() {
    return ItemScrollController();
    //throw UnimplementedError();
  }

  @override
  ItemPositionsListener getItemPositionsListener() {
    return ItemPositionsListener.create();
  }

  ///VEDI FILE COSTANTI
  /// * static const int  listaRecord    = 0;
  /// * static const int  nuovoRecord    = 1;
  /// * static const int  variaRecord    = 2;
  /// * static const int  cancellaRecord = 3;
  /// * static const int  ricercaRecord  = 4;
  Future<void> calcola() async {
    //tipoLista = Costanti.completa;
    //debugPrint("calcola tipoLista=" + tipoLista.toString());
    switch (funzione) {
      case Costanti.listaRecord:
        await MyInvarcaFunzioni.getLista();
        break;
      case Costanti.nuovoRecord:
        MyInvarcaFunzioni.titleController.text = '';
        MyInvarcaFunzioni.descriptionController.text = '';

        await MyVisual.miaModale(
                context,
                MyInvarcaFunzioni.titleController,
                MyInvarcaFunzioni.descriptionController,
                0,
                Costanti.nuovoRecord)
            .whenComplete(() {
          //debugPrint("FINE miaModale nuovo");
        });
        break;
      case Costanti.variaRecord:
        int n = int.parse(strRecordInEvidenza);
        List<Map<String, dynamic>> lista;
        if (tipoLista == Costanti.completa) {
          lista = MyInvarcaFunzioni.listaRecord;
        } else {
          lista = MyInvarcaFunzioni.listaRecordRicerca;
        }
        var nn = lista.indexWhere((element) => element['id'] == n, 0);
        MyInvarcaFunzioni.titleController.text = lista[nn]['title'];
        MyInvarcaFunzioni.descriptionController.text = lista[nn]['description'];

        await MyVisual.miaModale(
                context,
                MyInvarcaFunzioni.titleController,
                MyInvarcaFunzioni.descriptionController,
                nn,
                Costanti.variaRecord)
            .whenComplete(() {
          //debugPrint("FINE miaModale ");
        });
        break;
      case Costanti.cancellaRecord:
        int n = int.parse(strRecordInEvidenza);
        List<Map<String, dynamic>> lista;
        if (tipoLista == Costanti.completa) {
          lista = MyInvarcaFunzioni.listaRecord;
        } else {
          lista = MyInvarcaFunzioni.listaRecordRicerca;
        }
        var nn = lista.indexWhere((element) => element['id'] == n, 0);
        MyInvarcaFunzioni.titleController.text = lista[nn]['title'];
        MyInvarcaFunzioni.descriptionController.text = lista[nn]['description'];

        await MyVisual.miaModale(
                context,
                MyInvarcaFunzioni.titleController,
                MyInvarcaFunzioni.descriptionController,
                nn,
                Costanti.cancellaRecord)
            .whenComplete(() {
          //debugPrint("FINE miaModale ");
        });

        break;
      case Costanti.ricercaRecord:
        tipoLista = !Costanti.completa;
        await MyInvarcaFunzioni(
          context: context,
        ).mostraFormRicerca(int.parse(strRecordInEvidenza));

        break;
      default:
        debugPrint('choose a different number!');
    }
  }

  @override
  Widget build(BuildContext context) => makePag(context);

  makePag(BuildContext context) {
    var rigaMenu = getRigaMenu(context, 'CRUD(INVARCA+RICERCA)', this, altezza);
    //debugPrint("h: "+ altezza.toString());
    rigaMenu = aggiungiExtra(rigaMenu);
    return DefaultTabController(
        initialIndex: 0,
        length: 5,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight((globali.gruppoRadioMenu == 2)
                ? altezza * 2 + 10
                : altezza * 2 + 10),
            child: AppBar(
              flexibleSpace: null,
              backgroundColor: Costanti.coloreBgAppBar,
              leading: getFrecciaIndietro(context),
              title: Container(
                  color: Colors.transparent,
                  height: altezza,
                  child: Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        rigaMenu.elementAt(5),
                        rigaMenu.elementAt(6)
                      ])),
              bottom: TabBar(
                isScrollable: true,
                tabs: <Widget>[
                  Tab(
                      child: Container(
                    alignment: Alignment.topCenter,
                    //width: 120,
                    height: (globali.gruppoRadioMenu == 2)
                        ? altezza * 3 / 2 + 10
                        : altezza * 3 / 2 + 10,
                    child: rigaMenu.elementAt(0),
                  )),
                  Tab(
                      child: Container(
                    alignment: Alignment.topCenter,
                    //width: 120,
                    height: (globali.gruppoRadioMenu == 2)
                        ? altezza * 3 / 2 + 10
                        : altezza * 3 / 2 + 10,
                    child: rigaMenu.elementAt(1),
                  )),
                  Tab(
                      child: Container(
                    alignment: Alignment.topCenter,
                    //width: 120,
                    height: (globali.gruppoRadioMenu == 2)
                        ? altezza * 3 / 2 + 10
                        : altezza * 3 / 2 + 10,
                    child: rigaMenu.elementAt(2),
                  )),
                  Tab(
                      child: Container(
                    alignment: Alignment.topCenter,
                    //width: 120,
                    height: (globali.gruppoRadioMenu == 2)
                        ? altezza * 3 / 2 + 10
                        : altezza * 3 / 2 + 10,
                    child: rigaMenu.elementAt(3),
                  )),
                  Tab(
                      child: Container(
                    alignment: Alignment.topCenter,
                    //width: 120,
                    height: (globali.gruppoRadioMenu == 2)
                        ? altezza * 3 / 2 + 10
                        : altezza * 3 / 2 + 10,
                    child: rigaMenu.elementAt(4),
                  )),
                ],
              ),
            ),
          ),
          body: Material(
            child: OrientationBuilder(
              builder: (context, orientation) => Column(
                children: <Widget>[
                  Expanded(
                    child: list(orientation),
                  ),
                  //positionsView, // +FRA
                ],
              ),
            ),
          ),
        ));
  }

  List<Widget> aggiungiExtra(List<Widget> rigaMenu) {
    // rigaMenu contiene il titolo
    var numElementi = rigaMenu.length;
    int primaDelTitolo = numElementi - 1;

    Widget extra = Container(
      height: altezza,
      width: 100,
      padding: const EdgeInsets.all(1.0),
      //constraints: const BoxConstraints(minWidth:3,maxWidth:3,minHeight:3,maxHeight:3),

      //width: Costanti.larghezzaEvidenzaRecord, //60,
      //height: Costanti.altezzaEvidenzaRecord,
      //padding: const EdgeInsets.all(12),
      alignment: Alignment.center,

      decoration: BoxDecoration(
        color: Colors.cyan,
        border: Border.all(color: Colors.lightBlueAccent, width: 2.0),
        borderRadius: const BorderRadius.all(Radius.circular(6.0)),
      ),

      child: Text(
        strRecordInEvidenza,
        style: const TextStyle(fontSize: 18, color: Colors.yellow),
        textAlign: TextAlign.center,
      ),
    );
    rigaMenu.insert(primaDelTitolo, extra);
    return rigaMenu;
  }

  Widget list(Orientation orientation) {
    List<Map<String, dynamic>> lista;
    if (tipoLista == Costanti.completa) {
      //debugPrint("list: " + MyInvarcaFunzioni.listaRecord.length.toString());
      lista = MyInvarcaFunzioni.listaRecord;
    } else {
      lista = MyInvarcaFunzioni.listaRecordRicerca;
    }
    return ScrollablePositionedList.builder(
      itemCount: lista.length,
      itemBuilder: (context, index) => item(index, orientation),
      itemScrollController: itemScrollController,
      itemPositionsListener: itemPositionsListener,
      reverse: false,
      // FRANCO verif scrollDirection
      //scrollDirection: orientation == Orientation.portrait ? Axis.vertical : Axis.horizontal,
    );
  }

  /*
  Widget list(Orientation orientation) => ScrollablePositionedList.builder(

        itemCount: MyInvarcaFunzioni.listaRecord.length,
        itemBuilder: (context, index) => item(index, orientation),
        itemScrollController: itemScrollController,
        itemPositionsListener: itemPositionsListener,
        reverse: false,
        //scrollDirection: orientation == Orientation.portrait
        //    ? Axis.vertical
        //    : Axis.horizontal,
        scrollDirection: Axis.vertical,
      );
*/
  Widget item(int index, Orientation orientation) {
    //debugPrint("ORIENT: " + orientation.toString());
    //double h = 70;
    //double w = MediaQuery.of(context).size.width;
    /*
    double h = 0;
    double w = 0;
    if (orientation == Orientation.portrait) {
      h = 70;
      w = MediaQuery.of(context).size.width;
    } else {
      h = 700;
      w = 70;
    }

     */
    return //SizedBox(
        //height: orientation == Orientation.portrait ? itemHeights[i] : null,
        //width: orientation == Orientation.landscape ? itemHeights[i] : null,
        //width: MediaQuery.of(context).size.width,

        //height: orientation == Orientation.portrait  ? 70 : null, //70
        //width: orientation == Orientation.landscape ? 100 : null,
        //height: h,
        //width: w,
        //child:
        Container(
      color: Colors.transparent,
      //height: orientation == Orientation.portrait ? 70 : null,
      //width: orientation == Orientation.landscape ? MediaQuery.of(context).size.width : null,

      //height: h,
      //width: w,
      alignment: Alignment.center,
      //color: itemColors[i],
      child: carica(context, index),
      //),
    );
  }

  carica(BuildContext context, int index) {
    List<Map<String, dynamic>> lista;
    if (tipoLista == Costanti.completa) {
      lista = MyInvarcaFunzioni.listaRecord;
    } else {
      lista = MyInvarcaFunzioni.listaRecordRicerca;
    }
    //debugPrint("--- lista --- "+ lista.toString() + " -- " + lista.length.toString());
    return Container(
      color: (() {
        if (lista.isEmpty) {
          return Colors.red;
        } else {
          Color color = Colors.red;
          int.parse(strRecordInEvidenza) == lista[index]['id']
              ? color = Costanti.coloreBgRecordSelezionato
              : color = Costanti.coloreBgRecord;
          return color;
        }
      })(),
      margin: const EdgeInsets.all(2),
      child: ListTile(
        onTap: () {
          cambiaNumRecordInEvidenza(
              lista[index]['id'].toString(), true, Costanti.evidenzaRecord);
        },
        title: Text(
          lista[index]['title'],
          style: const TextStyle(
            fontSize: 20,
            //fontFamily: 'Raleway',
          ),
          strutStyle: const StrutStyle(
            //fontFamily: 'Roboto',
            fontSize: 20,
            //height: 1.2,
          ),
        ),
        subtitle: Text(
          lista[index]['description'] +
              " [" +
              lista[index]['id'].toString() +
              "]",
          style: const TextStyle(
            fontSize: 20,
            //fontFamily: 'Raleway',
          ),
          strutStyle: const StrutStyle(
            //fontFamily: 'Roboto',
            fontSize: 20,
            //height: 1.2,
          ),
        ),
      ),
    );
  }

  int evidenza() {
    //bool mostrafine = false;
    int pos = -1;
    int nuovoStrRecordInEvidenza = -1;
    int lung = 0;
    List<Map<String, dynamic>> lista;
    if (tipoLista == Costanti.completa) {
      lista = MyInvarcaFunzioni.listaRecord;
    } else {
      lista = MyInvarcaFunzioni.listaRecordRicerca;
    }
    if (lista.isEmpty) {
      strRecordInEvidenza = "-1";
      vuota = true;
      Utili.mostraMessaggioFondoPagina(context, 'LISTA VUOTA');
      return pos;
    }
    if (funzione == Costanti.listaRecord ||
        funzione == Costanti.cancellaRecord ||
        funzione == Costanti.ricercaRecord) {
      lung = lista.length;
      nuovoStrRecordInEvidenza = lista[primo]['id'];
      if (lung > 0) {
        pos = primo;
        strRecordInEvidenza = nuovoStrRecordInEvidenza.toString();
      }
    } else if (funzione == Costanti.nuovoRecord) {
      lung = lista.length;
      nuovoStrRecordInEvidenza = lista[lung - 1]['id'];
      if (lung > 0) {
        pos = lung - 1;
        strRecordInEvidenza = nuovoStrRecordInEvidenza.toString();
      }
    } else if (funzione == Costanti.variaRecord ||
        funzione == Costanti.evidenzaRecord) {
      lung = lista.length;
      if (lung > 0) {
        int n = int.parse(strRecordInEvidenza);
        pos = lista.indexWhere((element) => element['id'] == n, 0);
      }
    } else {
      // PRIMA VOLTA CON LISTA PIENA funzione -1 e in evidenza -1
      pos = primo;
      strRecordInEvidenza = lista[primo]['id'].toString();
    }

    return pos;
  }
}
