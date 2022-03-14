import 'package:flutter/material.dart';
/// percorso Es: ['p.2.1', 'm.1', 'm.2']
/// * p=salto pagina
/// * m=funzione
///
/// indirizzo Es: ['/page2/page2_1']
///
/// esegui Es:
///
/// void esegui(BuildContext context, int funz) {
///
///   setState(() {
///     _isPagina = !_isPagina;
///     _numFunzione = funz;
///     _value = getValue();
///   }
///   );
/// }
///
/// iconaCalamaio Es: [Icons.mail, Icons.dashboard, Icons.ac_unit]
///
/// testoCalamaio Es: ["Pagina 2 1", "F1", "F2"]

abstract class Percorribile {
  List<String> percorso();
  List<String> indirizzo();
  void esegui(BuildContext context,int funz);
  //List<IconData> iconaCalamaio();
  //List<String> testoCalamaio();
  void cambiaNumRecordInEvidenza(String nuovoNumero,bool clickUtente,int tipoFunzione);
  String getNumRecordInEvidenza();
  void disegnaPagina();
  bool getAbilitato(int funz);
  List<Icone> listaIcone();
}
class Icone {
String nome;
IconData icona;

Icone(this.nome, this.icona);
}
