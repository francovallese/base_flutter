import 'package:base/utili/variabili/costanti.dart';
import 'package:flutter/material.dart';
import 'tree_node.dart';

class TreeView extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final BuildContext context;
  final String titleKey;
  final String leadingKey;
  final String expanedKey;
  final String childrenKey;
  final double offsetLeft;

  final Function? titleOnTap;
  final Function? leadingOnTap;
  final Function? trailingOnTap;

  const TreeView({required this.context,
    required this.data,
    this.titleKey = 'title',
    this.leadingKey = 'leading',
    this.expanedKey = 'expaned',
    this.childrenKey = 'children',
    this.offsetLeft = 20.0,
    this.titleOnTap,
    this.leadingOnTap,
    this.trailingOnTap,
    Key? key})
      : super(key: key);

  List<TreeNode> _geneTreeNodes(List list, BuildContext context) {
    List treeNodes = <TreeNode>[];
    final double lar = MediaQuery
        .of(context)
        .size
        .width / 4;
    final double alt = MediaQuery
        .of(context)
        .size
        .height - 80.0;
    for (int i = 0; i < list.length; i++) {
      final Map<String, dynamic> item = list[i];
      final title = item[titleKey] == null
          ? null
          : Tooltip(
          message: preparaTooltip(item[titleKey].toString()),
          textStyle: const TextStyle(fontSize: 15,color : Colors.white),
          padding: const EdgeInsets.all(10),
          margin: EdgeInsets.only(left: lar,top:50),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            gradient: const LinearGradient(
                colors: <Color>[Colors.black, Colors.blueGrey]),
          ),
          height: alt,
          preferBelow: false,
          child: Text(item[titleKey],
              style: TextStyle(
                color: (item[titleKey].toString().startsWith("P") ||
                    item[titleKey].toString().startsWith("pagine") ||
                    item[titleKey].toString().startsWith("route") ||
                    item[titleKey].toString().startsWith("utili") ||
                    item[titleKey].toString().startsWith("albero") ||
                    item[titleKey].toString().startsWith("database") ||
                    item[titleKey].toString().startsWith("variabili"))
                    ? Costanti.coloreBgCalamaioPag
                    : Costanti.coloreBgCalamaioMenu,
              )));
      final leading = item[leadingKey] == null ? null : Text(item[leadingKey]);
      final expaned = item[expanedKey] ?? false;
      final children = item[childrenKey] as List;

      treeNodes.add(TreeNode(
        title: title,
        leading: leading,
        expaned: expaned,
        offsetLeft: offsetLeft,
        titleOnTap: titleOnTap,
        leadingOnTap: leadingOnTap,
        trailingOnTap: trailingOnTap,
        children: _geneTreeNodes(children, context),
      ));
    }

    return treeNodes as List<TreeNode>;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(data.length, (int index) {
        final Map<String, dynamic> item = data[index];
        final title = item[titleKey] == null ? null : Text(item[titleKey]);
        final leading =
        item[leadingKey] == null ? null : Text(item[leadingKey]);
        final expaned = item[expanedKey] ?? false;
        final children = item[childrenKey] as List;

        return TreeNode(
          title: title,
          leading: leading,
          expaned: expaned,
          offsetLeft: offsetLeft,
          titleOnTap: titleOnTap,
          leadingOnTap: leadingOnTap,
          trailingOnTap: trailingOnTap,
          children: _geneTreeNodes(children, context),
        );
      }),
    );
  }

  preparaTooltip(String string) {
    if (string.endsWith('dart')) {
      if (string.startsWith('rotta')) {
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


        return ret;
      }
      else if (string.startsWith('percorso')) {
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

        return ret;
      }
      else if (string.startsWith('scorrimento')) {
        String ret =
            "abstract class Scorribile {"
            "\n  ItemScrollController getItemScrollController();"
            "\n  ItemPositionsListener getItemPositionsListener();"
            "\n  void mostraFine(int index);"
            "\n}"
            "\n In particolare mostraFine permette di posizionarsi alla fine di una lista."
            "\n Risulta utile quando si inserisce un nuovo record e si desidera mostrarlo,"
            "\n per poterlo fare bisogna spostare la visione dei records alla fine.";
        return ret;
      }
      else if (string.startsWith('funz')) {
        String ret =
            "Nel Tentativo di separare il codice, al fine di migliorarne la manutenzione,questo file"
            "\ncontiene la parte di 'AppBar' presente in tutte le pagine descrivendone:"
            "\n"
            "\ngetRigaMenu -> Per progettare tutti i calamai della singola pagina."
            "\n"
            "\ngetFrecciaIndietro -> Per gestire il ritorno alla pagina precedente."
            "\n"
            "\ngetZonaTitolo -> Per una gestione più semplice(quando possibile) della 'AppBar'.";

        return ret;
      }
      else if (string.startsWith('invarca')) {
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
        return ret;
      }
      else if (string.startsWith('visual')) {
        String ret =
            "Il file contiene la classe MyVisual che con la funzione miaModale"
            "\nstatic Future<void> miaModale("
            "\nBuildContext context,TextEditingController _titleController,"
            "\nTextEditingController _descriptionController,"
            "\nint? id,int? operazione)"
            "\n"
            "\nviene costruita l'unica maschera per la gestione dell'inserimento, variazione etc."
            "\ndel database.";
        return ret;
      }
      else if (string.startsWith('sql_helper')) {
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
        return ret;
      }
      else {
        return "";
      }
    } else {
      return "";
    }
  }
}