import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' as mat;
import '../utile.dart';
import 'modello.dart';

class PaintSolido3D extends CustomPainter {
  Modello modello = Modello();
  Size size;
  double alfaX;
  double alfaY;
  double alfaZ;
  List<mat.Vector3> vertici = [];
  double _viewPortX = 0.0;
  double _viewPortY = 0.0;
  double zoom = 0.0;
  mat.Vector3 camera = mat.Vector3(0.0, 50.0, 0.0);
  mat.Vector3 sole = mat.Vector3(0.0, 0.0, 50.0);

  PaintSolido3D(
      this.size, this.modello, this.alfaX, this.alfaY, this.alfaZ, this.zoom) {
    _viewPortX = (size.width * 0.5).toDouble();
    _viewPortY = (size.height * 0.5).toDouble();
  }

  mat.Vector3 _calcoloVertici(mat.Vector3 vertex) {
    var trans = mat.Matrix4.translationValues(_viewPortX, _viewPortY, 1);
    trans.scale(zoom, -zoom);
    trans.rotateX(Utili.gradiToRadianti(alfaX));
    trans.rotateY(Utili.gradiToRadianti(alfaY));
    trans.rotateZ(Utili.gradiToRadianti(alfaZ));
    mat.Vector3 ret = trans.transform3(vertex);
    return ret;
  }

  @override
  void paint(Canvas canvas, Size size) {
    /// ------ SFONDO
    Size sizeSfondo = Size(size.width, size.height);
    var paint1 = Paint()
      ..color = Colors.black
      ..strokeWidth = 10;
    canvas.drawRect(const Offset(0, 0) & sizeSfondo, paint1);

    vertici = [];
    for (int i = 0; i < modello.vertici.length; i++) {
      vertici.add(_calcoloVertici(mat.Vector3.copy(modello.vertici[i])));
    }
    if (modello.colori.isEmpty) {
      for (int i = 0; i < modello.materiali.values.length; i++) {
        Color c = modello.materiali.values.elementAt(i);
        modello.colori.add(c);
      }
    }
    // Ordinamento
    List<Map<String, dynamic>> ordinamento = [];
    for (var i = 0; i < modello.facce.length; i++) {
      var faccia = modello.facce[i];
      var v1 = vertici[faccia[0] - 1];
      var v2 = vertici[faccia[1] - 1];
      var v3 = vertici[faccia[2] - 1];
      var distZ = (v1.z + v2.z + v3.z) / 3;
      ordinamento.add({"index": i, "order": distZ});
    }
    ordinamento.sort((Map a, Map b) => a["order"].compareTo(b["order"]));

    // DISEGNA FACCE
    for (int i = 0; i < ordinamento.length; i++) {
      var faccia = modello.facce[ordinamento[i]["index"]];
      var colore = modello.colori[ordinamento[i]["index"]];
      _paintFaccia(canvas, faccia, colore);
    }
  }

  @override
  bool shouldRepaint(PaintSolido3D oldDelegate) {
    return true;
  }
  void _paintFaccia(Canvas canvas, List<int> faccia, Color colore) {
    var v1 = vertici[faccia[0] - 1];
    var v2 = vertici[faccia[1] - 1];
    var v3 = vertici[faccia[2] - 1];

    // Luminosità
    mat.Vector3 s1 = mat.Vector3.copy(v2);
    s1.sub(v1);
    mat.Vector3 s3 = mat.Vector3.copy(v2);
    s3.sub(v3);
    var normale = mat.Vector3(
      (s1.y * s3.z) - (s1.z * s3.y),
      (s1.z * s3.x) - (s1.x * s3.z),
      (s1.x * s3.y) - (s1.y * s3.x),
    );
    var nvec1 = mat.Vector3.copy(normale).normalized();
    var nvec2 = mat.Vector3.copy(sole).normalized();
    var normal =
        (nvec1.x * nvec2.x) + (nvec1.y * nvec2.y) + (nvec1.z * nvec2.z);
    var illuminazione = normal.clamp(0.0, 1.0);

    var r = (illuminazione * colore.red).toInt();
    var g = (illuminazione * colore.green).toInt();
    var b = (illuminazione * colore.blue).toInt();

    var paint = Paint();
    paint.color = Color.fromARGB(255, r, g, b);
    paint.style = PaintingStyle.fill;

    var path = Path();
    path.moveTo(v1.x, v1.y);
    path.lineTo(v2.x, v2.y);
    path.lineTo(v3.x, v3.y);
    path.lineTo(v1.x, v1.y);
    path.close();
    canvas.drawPath(path, paint);
  }
}