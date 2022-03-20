import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart';

class Modello {
  Modello() {/* */}
  List<Vector3> vertici = [];
  List<List<int>> facce = [];
  List<Color> colori = [];
  Map<String, Color> materiali = {}; //Solo colore

  Color _toRGBA(double r, double g, double b) {
    return Color.fromRGBO(
        (r * 255).toInt(), (g * 255).toInt(), (b * 255).toInt(), 1);
  }

  Future<String> analizzaObj(String string) async {
    String ret = "";
    String nomeFilemtl = "";
    List<String> lines = string.split("\n");
    for (var line in lines) {
      if (line.startsWith("v ")) {
        var values = line.substring(2).split(" ");
        vertici.add(Vector3(
          double.parse(values[0]),
          double.parse(values[1]),
          double.parse(values[2]),
        ));
      } else if (line.startsWith("f ")) {
        var values = line.substring(2).split(" ");
        facce.add(List.from([
          int.parse(values[0].split("/")[0]),
          int.parse(values[1].split("/")[0]),
          int.parse(values[2].split("/")[0]),
        ]));
      } else if (line.startsWith("mtllib ")) {
        nomeFilemtl = line.substring(7);
      }
    }
    ret = nomeFilemtl;
    return ret;
  }

  /// Carico solo colori
  Future<void> caricaMateriali(String string) async {
    String chiaveColore = "";

    List<String> lines = string.split("\n");
    for (var line in lines) {
      if (line.startsWith("newmtl ")) {
        chiaveColore = line.substring(7);
      } else if (line.startsWith("Kd ")) {
        var values = line.substring(3).split(" ");
        double cr = double.parse(values[0]);
        double cg = double.parse(values[1]);
        double cb = double.parse(values[2]);
        Color c = _toRGBA(cr, cg, cb);
        Map<String, Color> m = {chiaveColore: c};
        materiali.addAll(m);
      }
    }
  }
}