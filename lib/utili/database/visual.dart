import 'package:flutter/material.dart';
import '../../pagine/percorso.dart';
import '../../pagine/scorrimento.dart';
import '../variabili/costanti.dart';
import 'invarca_funzioni.dart';

class MyVisual {
  static Percorribile? percorribile;
  static Scorribile? scorribile;

  static Future<void> miaModale(
      BuildContext context,
      TextEditingController _titleController,
      TextEditingController _descriptionController,
      int? id,
      int? operazione) async {
    showModalBottomSheet(
      isDismissible: false, // FRANCO vero modale
      context: context,
      elevation: 5,
      isScrollControlled: true,
      builder: (_) => Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(hintText: 'Title'),
              ),
              const SizedBox(
                height: 5,
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(hintText: 'Description'),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 50,
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('ANNULLA'),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      //if (id != null) {
                      if (operazione == Costanti.nuovoRecord) {
                        await MyInvarcaFunzioni(
                          context: context,
                        ).addItem();
                      } else if (operazione == Costanti.variaRecord) {
                        final idMod =
                            MyInvarcaFunzioni.listaRecord.elementAt(id!)['id'];
                        await MyInvarcaFunzioni(
                          context: context,
                        ).updateItem(idMod);
                      } else if (operazione == Costanti.cancellaRecord) {
                        final idMod =
                            MyInvarcaFunzioni.listaRecord.elementAt(id!)['id'];
                        await MyInvarcaFunzioni(
                          context: context,
                        ).deleteItem(idMod);
                      } else if (operazione == Costanti.ricercaRecord) {
                        await MyInvarcaFunzioni(
                          context: context,
                        ).ricerca(_titleController.text).whenComplete(() {
                          //MyInvarcaFunzioni.getListaRicerca(_titleController.text);
                        });
                      }
                      //}

                      // Clear the text fields
                      _titleController.text = '';
                      _descriptionController.text = '';
                      Navigator.of(context).pop();
                    },
                    child: getWidget(operazione),
                  ),
                ],
              ),
            ],
          )),
    );
  }

  static getWidget(operazione) {
    if (operazione == Costanti.nuovoRecord) {
      return const Text('CREA NUOVO');
    } else if (operazione == Costanti.ricercaRecord) {
      return const Text('RICERCA');
    } else if (operazione == Costanti.variaRecord) {
      return const Text('MODIFICA');
    } else {
      return const Text('CANCELLA');
    }
  }
}
