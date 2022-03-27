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

  late TreeView alberoDart;
  late Text areaTesto;

  String unTesto = '';
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //creaAreaTesto();
    miaApp();
    /*
    final double lar = MediaQuery
        .of(context)
        .size
        .width / 2;
    final double alt = MediaQuery
        .of(context)
        .size
        .height * 0.8;

     */
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
              const Divider(height: 10,thickness: 5,color:Colors.blue),
              IntrinsicHeight(
              child: Container( color:Colors.black12,child:Row(children: [
                alberoDart

              ]))),
            ],
          ),
          //),
        ));
  }

  corpo() {
    return TreeView(context: context,data: treeMenu,note:false);
  }

  miaApp() {
    alberoDart = TreeView(context: context,data: treeApp,note:true,
      titleOnTap: (value){
      //debugPrint("----> " + value.toString());
        mostraNoteFileDart(value);
      }
        //mostraNoteFileDart(titleKey);
    );

  }
  mostraNoteFileDart(String nomeFile) {

    unTesto = "";
    if (nomeFile.startsWith('rotta')) {
    String ret =
    "class RottaPagine {"
    "\n  static Route<dynamic>? generateRoute(RouteSettings settings)"
    "\n  {"
    "\n    switch (settings.name) {"
    "\n      case '/': "
    "\n        return MaterialPageRoute(builder: (_) => const Page1());"
    "\n      case '/page2':"
    "\n        return MaterialPageRoute(builder: (_) => const Page2());"
    "\n      case '/page2/page2_1':"
    "\n        return MaterialPageRoute(builder: (_) => const Page2sub1());"
    "\n      case '/page3':"
    "\n        return MaterialPageRoute(builder: (_) => const Page3());"
    "\n    }"
    "\n    return null;"
    "\n  }"
    "\n}"
    "\nL'applicazione prevede 4 pagine; ogni pagina implementa l'interfaccia"
    "\nPercorribile descritta in percorso.dart.";


    unTesto =  ret;
    }
    else if (nomeFile.startsWith('percorso')) {
    String ret =
    "abstract class Percorribile {"
    "\n  List<String> percorso();"
    "\n  List<String> indirizzo();"
    "\n  void esegui(BuildContext context,int funz);"
    "\n  List<IconData> iconaCalamaio();"
    "\n  List<String> testoCalamaio();"
    "\n  void cambiaNumRecordInEvidenza(String nuovoNumero,bool clickUtente,int tipoFunzione);"
    "\n  String getNumRecordInEvidenza();"
    "\n  bool getAbilitato(int funz);"
    "\n  void disegnaPagina();"
    "\n}"
    "\nOgni pagina deve implementare tutti questi metodi come ad esempio la pagina 2:"
    "\n  percorso:"
    "\n  return ['p.2.1', 'm.1', 'm.2', 'm.3', 'm.4'];"
    "\n  dove se l'elemento inizia con p è una pagina se inizia con m è una funzione."
    "\n  indirizzo:"
    "\n  return ['/page2/page2_1'];"
    "\n  dove l'elemento dichiara l'indirizzo della sotto-pagina o pagina successiva."
    "\n  esegui(BuildContext context, int funz):"
    "\n  la funzione viene attivata quando viene premuto il calamaio(InkWell ontap)"
    "\n  iconaCalamaio e testoCalamaio:"
    "\n  I due metodi descrivono l'icona e la stringa del calamaio."
    "\n  cambiaNumRecordInEvidenza e getNumRecordInEvidenza:"
    "\n  I due metodi descrivono la gestione dell'Id della tabella del database."
    "\n  cambiaNumRecordInEvidenza e getNumRecordInEvidenza:"
    "\n  I due metodi descrivono la gestione dell'Id della tabella del database."
    "\n  getAbilitato:"
    "\n  Il metodo permette di gestire l'abilitazione dei calamai ovvero dei pulsanti menù."
    "\n  Infine disegnaPagina:"
    "\n  Permette di ridisegnare la pagina  attraverso il lancio di setState((){})";

    unTesto =  ret;
    }
    else if (nomeFile.startsWith('scorrimento')) {
    String ret =
    "abstract class Scorribile {"
    "\n  ItemScrollController getItemScrollController();"
    "\n  ItemPositionsListener getItemPositionsListener();"
    "\n  void mostraFine(int index);"
    "\n}"
    "\n In particolare mostraFine permette di posizionarsi alla fine di una lista."
    "\n Risulta utile quando si inserisce un nuovo record e si desidera mostrarlo,"
    "\n per poterlo fare bisogna spostare la visione dei records alla fine.";
    unTesto =  ret;
    }
    else if (nomeFile.startsWith('funz')) {
    String ret =
    "Nel Tentativo di separare il codice, al fine di migliorarne la manutenzione,questo file"
    "\ncontiene la parte di 'AppBar' presente in tutte le pagine descrivendone:"
    "\n"
    "\ngetRigaMenu -> Per progettare tutti i calamai della singola pagina."
    "\n"
    "\ngetFrecciaIndietro -> Per gestire il ritorno alla pagina precedente."
    "\n"
    "\ngetZonaTitolo -> Per una gestione più semplice(quando possibile) della 'AppBar'.";

    unTesto =  ret;
    }
    else if (nomeFile.startsWith('invarca')) {
    String ret =
    "Il file contiene la classe MyInvarcaFunzioni che con le sue funzioni fa da ponte"
    "\ntra la maschera di input (miaModale in visual.dart) e le funzioni a basso livello"
    "\nper l'accesso al database(sql_helper.dart);"
    "\n"
    "\naddItem() -> Per inserire un nuovo record(leggi documento in Firestore)."
    "\n"
    "\nupdateItem(int id) -> Per la variazione del record."
    "\n"
    "\ndeleteItem(int id) -> Per la cancellazione del record.";
    unTesto =  ret;
    }
    else if (nomeFile.startsWith('visual')) {
    String ret =
    "Il file contiene la classe MyVisual che con la funzione miaModale"
    "\nstatic Future<void> miaModale("
    "\nBuildContext context,TextEditingController _titleController,"
    "\nTextEditingController _descriptionController,"
    "\nint? id,int? operazione)"
    "\n"
    "\nviene costruita l'unica maschera per la gestione dell'inserimento, variazione etc."
    "\ndel database.";
    unTesto =  ret;
    }
    else if (nomeFile.startsWith('sql_helper')) {
    String ret =
    "Il file contiene la classe SQLHelper che con le sue funzioni gestisce il database"
    "\n"
    "\nSQLITE:"
    "\n"
    "\ngetItems()."
    "\n"
    "\ncreateItem(String title, String? descrption)."
    "\n"
    "\nupdateItem(int id, String title, String? descrption)."
    "\n"
    "\ne altro...";
    unTesto =  ret;
    }
    else if (nomeFile.startsWith('solido')) {
      String ret =
          "La classe Solido viene lanciata da pagina 4 con 2 parametri"
          "\nzoom e path: assets/3D/cubo.obj"
          "\ncubo.obj e cubo.mtl rappresentano i dati del solido."
          "\nIn particolare:"
          "\n        nel file cubo.obj"
          "\n  v 0.000000 1.000000 0.000000 un vertice di coordinate x y z."
          "\n  f 1 2 3 i vertici in senso antiorario della faccia F1."
          "\n        nel file cubo.mtl"
          "\n  Kd 0.000000 0.000000 1.000000 il colore della faccia F1."
          "\nIn modello.dart la classe Modello raccoglie i parametri del solido."
          "\nIn dipingi.dart la classe PaintSolido3D dove:"
          "\n  void _paintFaccia(Canvas canvas, List<int> faccia, Color colore)"
          "\nrappresenta il punto di arrivo della grafica 3D."
          "\nNOTA:I files obj e mtl sono stati ricavati con Blender(free).";
      unTesto =  ret;
    }
    if(unTesto != "") {
      Utili.mostraMessaggio(context, 'Info '+nomeFile , unTesto);
    }

    //setState((){});
  }

  @override
  List<String> percorso() {
    return ['p.2.0', 'p.3.0', 'p.4.0', 'm.1'];
    //throw UnimplementedError();
  }

  @override
  List<String> indirizzo() {
    return ['/page2', '/page3', '/page4'];
    //throw UnimplementedError();
  }

  Future<void> fai1(BuildContext context, int f) async {
    String msg =
        "Scelta Menu:";
    List<String> scelte = Costanti.scelteGruppoOpzioniMenu;
    int inEvidenza = globali.gruppoRadioMenu;
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
/*
  @override
  List<IconData> iconaCalamaio() {
    return const [Icons.archive, Icons.video_call, Icons.warning];
    //throw UnimplementedError();
  }

 */
  @override
  List<Icone> listaIcone(){
    return [
      Icone('DB',Icons.archive),
      Icone('Video',Icons.video_call),
      Icone('3D',Icons.view_in_ar),
      Icone('Radio Es.',Icons.warning)
    ];
  }
  /*
  @override
  List<String> testoCalamaio() {
    return ["DB", "Video", "Radio Es."];
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
