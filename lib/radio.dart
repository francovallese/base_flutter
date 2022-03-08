import 'package:base/utili/variabili/global.dart' as globali;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RadioExample extends StatefulWidget {
  final List<String> rows;
  final int attivo;

  const RadioExample({required this.rows, required this.attivo, Key? key})
      : super(key: key);

  @override
  RadioExampleState createState() => RadioExampleState();
}

class RadioExampleState extends State<RadioExample> {
  int attivo = 0;

  RadioExampleState();

  @override
  void initState() {
    super.initState();
    attivo = widget.attivo;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Column(
        children: createChildren(),
      ),
    );
  }

  List<Widget> createChildren() {
    int lung = widget.rows.length;
    return List<Widget>.generate(lung, (int index) {
      return buildItem(widget.rows[index].toString(), index);
    });
  }

  Widget buildItem(String text, int value) {
    return ListTile(
      title: Text(text),
      leading: Radio<int>(
        groupValue: attivo,
        value: value,
        onChanged: _controlloscelta,
      ),
    );
  }

  void _controlloscelta(int? value) {
    setState(() {
      globali.gruppoRadioMenu = value!;
      attivo = globali.gruppoRadioMenu;
      aggiornaProperties('gruppoRadioMenu',attivo);

    });
  }

  Future<void> aggiornaProperties(String s, int attivo) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('gruppoRadioMenu',attivo);

  }
}
