import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart';

class Modello {
  Modello() {/* */}
  List<Vector3> vertici = [];
  List<List<int>> facce = [];
  List<String> nomeColoreFaccia = [];
  List<Color> colori = [];
  Map<String, Color> materiali = {}; //Solo colore

  Color _toRGBA(double r, double g, double b) {
    return Color.fromRGBO(
        (r * 255).toInt(), (g * 255).toInt(), (b * 255).toInt(), 1);
  }

  Future<String> analizzaObj(String string) async {
    String ret = "";
    String nomeFilemtl = "";
    String codiceColoreAttuale = "";
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
        List<int> nn = [];
        for(int i = 0; i<values.length;i++){
          int iv = int.parse(values[i].split("/")[0]);
          nn.add(iv);
        }
        facce.add(nn);
        nomeColoreFaccia.add(codiceColoreAttuale);
      } else if (line.startsWith("mtllib ")) {
        nomeFilemtl = line.substring(7);
      } else if (line.startsWith("usemtl ")) {
        codiceColoreAttuale = line.substring(7).trim();


    }
    }
    ret = nomeFilemtl;
    //debugPrint("->"+ nomeColoreFaccia.toString());
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