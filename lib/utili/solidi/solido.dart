import 'dipingi.dart';
import 'modello.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Solido extends StatefulWidget {
  final String path;
  final double zoom;

  const Solido({Key? key, required this.path, required this.zoom})
      : super(key: key);

  @override
  _SolidoState createState() => _SolidoState();
}

class _SolidoState extends State<Solido> {
  double alfaX = 0.0;
  double alfaY = 0.0;
  double alfaZ = 0.0;
  //double zoom = 0.0;
  Modello modello = Modello();

  @override
  void initState() {
    rootBundle.loadString(widget.path).then((value) {
      modello.analizzaObj(value).then((value) {
        String nomeFilemtl = value;
        String nomeObj = widget.path.split("/").last;
        String percorsoMtl = widget.path.replaceAll(nomeObj, nomeFilemtl);
        rootBundle.loadString(percorsoMtl).then((value) {
          modello.caricaMateriali(value).then((value) {
            alfaX = 87.34530639648438;
            alfaY = 90.627197265625;
            setState(() {});
          });
        });
      });
    });
    super.initState();
  }

  _ruota(DragUpdateDetails update) {
    setState(() {
      alfaY += update.delta.dx;
      if (alfaY > 360) {
        alfaY = alfaY - 360;
      } else if (alfaY < 0) {
        alfaY = 360 - alfaY;
      }
      alfaX += update.delta.dy;
      if (alfaX > 360) {
        alfaX = alfaX - 360;
      } else if (alfaX < 0) {
        alfaX = 360 - alfaX;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return GestureDetector(
      child: CustomPaint(
        painter: PaintSolido3D(size, modello, alfaX, alfaY, alfaZ, widget.zoom),
        size: size,
      ),
      onPanUpdate: (DragUpdateDetails update) => _ruota(update),
    );
  }
}