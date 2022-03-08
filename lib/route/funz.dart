import 'package:base/pagine/percorso.dart';
import 'package:base/utili/variabili/costanti.dart';
import 'package:flutter/material.dart';
import '../utili/variabili/global.dart' as globali;

List<Widget> getRigaMenu(BuildContext context, String titolo,
    Percorribile percorribile, double altezza) {
  List<String> percorso = percorribile.percorso();
  int numCalamai = percorso.length;

  //debugPrint("LUNG= " + lung.toString());
  List<Widget> xx = [];

  xx = List<Widget>.generate(numCalamai, (int index) {
    return getElementoMenu(
        context, percorribile, percorso[index], index, altezza);
  });

  xx.add(Container(
      alignment: Alignment.center,
      height: altezza,
      child: Text(
        titolo,
        style: const TextStyle(
          color: Costanti.coloreTitoloBarra,
        ),
      )));

  return xx;
}

Widget getElementoMenu(BuildContext context, Percorribile percorribile,
    String calamaio, int indice, double altezza) {
  final splitted = calamaio.split('.');
  String pm = splitted[0].trim(); //p=altra pagina, m=esegui funzione
  String dopoPm = splitted[1].trim();
  if (globali.gruppoRadioMenu == Costanti.icone) {
    return Container(
        color: Colors.transparent,
        height: altezza,
        child: InkWell(
          radius: altezza / 2,
          onTap: () {
            //final splitted = calamaio.split('.');
            //var pm = splitted[0].trim(); //p=altra pagina, m=esegui funzione
            if (pm == 'p') {
              var pag = percorribile.indirizzo()[indice];
              Navigator.of(context).pushNamed(pag);
            } else {
              int funz = int.parse(dopoPm);
              percorribile.esegui(context, funz);
            }
          },
          child: Tooltip(
            message: percorribile.testoCalamaio()[indice],
            child: CircleAvatar(
              radius: altezza / 2,
              child: icona(percorribile, indice, pm, altezza * 85 / 100),
              backgroundColor: (calamaio.isEmpty)
                  ? Colors.black
                  : (pm.compareTo("p") == 0)
                      ? Costanti.coloreBgCalamaioPag
                      : (percorribile.getAbilitato(indice))
                          ? Costanti
                              .coloreBgCalamaioMenu // FRANCO offuscare? come!
                          : Costanti.coloreBgCalamaioMenuO,
            ),
          ),
        ));
  } //-------------------------------------------------------------------------
  else if (globali.gruppoRadioMenu == Costanti.testo) {
    return testoCalamaio(context, pm, dopoPm, percorribile, indice, altezza);
  } else {
    /// Costanti.iconeConTtesto ----------------2------------------
    return Container(
        height: altezza + altezza / 2,
        alignment: Alignment.center,
        child: Column(
            //crossAxisAlignment: CrossAxisAlignment.center,
            verticalDirection: VerticalDirection.up,
            children: [
              InkWell(
                radius: altezza / 4,
                onTap: () {
                  //final splitted = calamaio.split('.');
                  //var pm = splitted[0].trim(); //p=altra pagina, m=esegui funzione
                  if (pm == 'p') {
                    var pag = percorribile.indirizzo()[indice];
                    Navigator.of(context).pushNamed(pag);
                  } else {
                    int funz = int.parse(splitted[1].trim());
                    percorribile.esegui(context, funz);
                  }
                },
                child: CircleAvatar(
                  radius: altezza / 4, //Costanti.raggioCircleAvatar/2,
                  child: icona(percorribile, indice, pm, altezza / 3),
                  backgroundColor: (calamaio.isEmpty)
                      ? Colors.red
                      : (pm.compareTo("p") == 0)
                          ? Costanti.coloreBgCalamaioPag
                          : Costanti.coloreBgCalamaioMenu,
                ),
              ),
              testoCalamaio(
                  context, pm, dopoPm, percorribile, indice, altezza / 2),
            ]));
  }
}

testoCalamaio(BuildContext context, String pm, String dopoPm,
    Percorribile percorribile, int indice, double altezza) {
  var unTesto = percorribile.testoCalamaio().elementAt(indice);
  //final ButtonStyle style =
  //ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 30));

  return Container(
      color: Colors.transparent,
      height: altezza,
      alignment: Alignment.center,
      child: ElevatedButton(
        child: Text(unTesto),
        onPressed: () {
          //if (globali.gruppoRadioMenu == 1) {
          if (pm == 'p') {
            var pag = percorribile.indirizzo()[indice];
            Navigator.of(context).pushNamed(pag);
          } else if (pm == 'm') {
            int funz = int.parse(dopoPm);
            percorribile.esegui(context, funz);
          }
          //}
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all((pm == 'p')
              ? Costanti.coloreBgCalamaioPag
              : Costanti.coloreBgCalamaioMenu),
        ),
      ));
}

Icon icona(Percorribile percorribile, int indice, String pm, double altezza) {
  var ic = percorribile.iconaCalamaio();
  IconData icdata = ic.elementAt(indice);
  var codePoint = icdata.codePoint;
  IconData(codePoint, fontFamily: 'MaterialIcons');
  return Icon(
    IconData(codePoint, fontFamily: 'MaterialIcons'),
    size: altezza,
    color: (pm == "p") // == 0)percorribile.getAbilitato(indice))
        ? Colors.black //Costanti.coloreBgAppBar
        : (percorribile.getAbilitato(indice))
            ? Costanti.coloreIconaMenu
            : Costanti.coloreIconaMenuO,
  );
}

Widget getFrecciaIndietro(BuildContext context) {
  return IconButton(
    icon: const Icon(Icons.arrow_back, color: Costanti.coloreFrecciaBack),
    onPressed: () => Navigator.of(context).pop(),
  );
}

Widget getZonaTitolo(
    BuildContext context, String titolo, altezza, Percorribile percorribile) {
  return Container(
      color: Colors.transparent,
      height: (globali.gruppoRadioMenu == 2) ? altezza : altezza,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: getRigaMenu(context, titolo, percorribile, altezza),
      ));
}
