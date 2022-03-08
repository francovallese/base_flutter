import 'package:base/utili/database/sql_helper.dart';
import 'package:base/utili/database/visual.dart';
import 'package:base/utili/variabili/costanti.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../pagine/percorso.dart';
import '../utile.dart';
import 'package:base/utili/variabili/global.dart' as globali;

class MyInvarcaFunzioni {
  BuildContext context;
  static List<Map<String, dynamic>> listaRecord = [];
  static List<Map<String, dynamic>> listaRecordRicerca = [];
  static bool isLoading = false;
  static final TextEditingController titleController = TextEditingController();
  static final TextEditingController descriptionController =
      TextEditingController();
  static Percorribile? percorribile;

  MyInvarcaFunzioni({
    required this.context,
  });
  static late List<Map<String, dynamic>>? data;

  static Future<bool?> getLista() async {
    bool ret = false;
    if (SQLHelper.os == "Web") {
      List<Map<String, dynamic>> lista = [];
      fetchAllContact().then((List? list) {
        lista = list!.cast<Map<String, dynamic>>();
        MyInvarcaFunzioni.listaRecord = lista;
        MyInvarcaFunzioni.isLoading = true;
        globali.ultimoId = lista.elementAt(lista.length - 1)['id'];
        //debugPrint("ultimo----->" + globali.ultimoId.toString());
        //percorribile?.cambiaNumRecordInEvidenza(ret[primo]['id'].toString());
        percorribile?.disegnaPagina();
        ret = true;
      });
    } else {
      await SQLHelper.getItems().whenComplete(() {
        ret = true;
      });
    }
    return ret;
  }

  Future<bool?> addItem() async {
    bool ret = false;
    if (SQLHelper.os == "Web") {
      FirebaseFirestore mydb = FirebaseFirestore.instance;
      CollectionReference nuovo = mydb.collection(Costanti.nomeTAB);
      int id = globali.ultimoId + 1;
      await nuovo.add({
        'id': id,
        'title': titleController.text,
        'description': descriptionController.text,
        'createdAt': DateTime.now().toString()
      }).whenComplete(() async {
        await getLista().whenComplete(() {
          percorribile?.cambiaNumRecordInEvidenza(
              id.toString(), false, Costanti.nuovoRecord);
          ret = true;
        });
      });
    } else {
      await SQLHelper.createItem(
              titleController.text, descriptionController.text)
          .whenComplete(() {
        ret = true;
      });
    }

    if (ret) {
      await Utili.mostraMessaggioFondoPagina(context, 'OK! INSERITO');
    }
    return ret;
  }

  // Update an existing journal
  Future<void> updateItem(int id) async {
    if (SQLHelper.os == "Web") {
      var xx = listaRecord.firstWhere((dropdown) => dropdown['id'] == id);
      var docu = xx['doc'];
      FirebaseFirestore mydb = FirebaseFirestore.instance;
      CollectionReference modif = mydb.collection(Costanti.nomeTAB);
      await modif.doc(docu).update({
        'title': titleController.text,
        'description': descriptionController.text,
        'createdAt': DateTime.now().toString()
      }).whenComplete(() async {
        await Utili.mostraMessaggioFondoPagina(context, 'OK! MODIFICATO');
        await getLista().whenComplete(() {
          percorribile?.cambiaNumRecordInEvidenza(
              id.toString(), false, Costanti.variaRecord);
        });
      });
    } else {
      await SQLHelper.updateItem(
          id, titleController.text, descriptionController.text);
      await Utili.mostraMessaggioFondoPagina(context, 'OK! MODIFICATO');
    }
  }

  // Delete an item
  Future<int> deleteItem(int id) async {
    int ret = -1;
    if (SQLHelper.os == "Web") {
      var xx = listaRecord.firstWhere((dropdown) => dropdown['id'] == id);
      var docu = xx['doc'];
      FirebaseFirestore mydb = FirebaseFirestore.instance;
      CollectionReference del = mydb.collection(Costanti.nomeTAB);

      await del.doc(docu).delete().whenComplete(() async {
        await Utili.mostraMessaggioFondoPagina(context, 'OK! CANCELLATO');
        await getLista().whenComplete(() {
          ret = 1;
        });
      });
    } else {
      ret = await SQLHelper.deleteItem(id);
      await Utili.mostraMessaggioFondoPagina(context, 'OK! CANCELLATO');
    }
    return ret;
  }

  // Ricerca
  Future<void> ricerca(String titolo) async {
    if (SQLHelper.os == "Web") {
      List<Map<String, dynamic>> ret = [];
      MyInvarcaFunzioni.listaRecordRicerca = ret;
      FirebaseFirestore mydb = FirebaseFirestore.instance;
      CollectionReference ric = mydb.collection(Costanti.nomeTAB);

      await ric
          .where('title', isEqualTo: titolo.toString())
          .get()
          .then((value) {
        QuerySnapshot<Map<String, dynamic>>? xx =
            value as QuerySnapshot<Map<String, dynamic>>?;

        //debugPrint("size "+ xx.size.toString()+" "+xx.toString());

        for (var documentSnapshot in xx!.docs) {
          //debugPrint("+++++++++++++ " + documentSnapshot.data().toString());
          var yy = documentSnapshot.data();
          String zz = documentSnapshot.id;
          yy.putIfAbsent('doc', () => zz);
          //debugPrint("****" + yy.toString());

          MyInvarcaFunzioni.listaRecordRicerca.add(yy);
        }

        MyInvarcaFunzioni.isLoading = true;
        //percorribile?.cambiaNumRecordInEvidenza(ret[primo]['id'].toString());
        percorribile?.disegnaPagina();
      });
    } else {
      await SQLHelper.searchTitle(titolo);
    }
  }

  // This function is used to fetch all data from the database

  static Future<bool?> getListaRicerca() async {
    return true;
  }

  Future<void> mostraForm(int index, int operazione) async {
    if (operazione == Costanti.variaRecord) {
      titleController.text = listaRecord[index]['title'];
      descriptionController.text = listaRecord[index]['description'];
    }
    await MyVisual.miaModale(
        context, titleController, descriptionController, index, operazione);
  }

  Future<void> mostraFormRicerca(int? id) async {
    titleController.text = ""; //existingJournal['title'];
    descriptionController.text = ""; //existingJournal['description'];

    await MyVisual.miaModale(context, titleController, descriptionController,
        id, Costanti.ricercaRecord);
  }

  static Future<List<Map<String, dynamic>>> fetchAllContact() async {
    List<Map<String, dynamic>> contactList = [];
    FirebaseFirestore mydb = FirebaseFirestore.instance;
    await mydb.collection(Costanti.nomeTAB).orderBy('id').get().then((value) {
      QuerySnapshot<Map<String, dynamic>> xx = value;

      //debugPrint("size "+ xx.size.toString()+" "+xx.toString());

      for (var documentSnapshot in xx.docs) {
        //print(documentSnapshot.data());
        //debugPrint("+++++++++++++ " + documentSnapshot.data().toString());
        var yy = documentSnapshot.data();
        String zz = documentSnapshot.id;
        yy.putIfAbsent('doc', () => zz);
        //debugPrint("****" + yy.toString());
        //contactList.add(documentSnapshot.data());
        contactList.add(yy);
      }
    });

    //debugPrint(contactList.toString());
    return contactList;
  }
}
