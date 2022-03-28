import 'dipingi.dart';
import 'modello.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import '../variabili/costanti.dart';

class Solido extends StatefulWidget {
  final String path;
  final double zoom;
  final double alfaXini;
  final double alfaYini;
  final bool animato;
  const Solido({Key? key, required this.path, required this.zoom, required this.alfaXini, required this.alfaYini, required this.animato})
      : super(key: key);

  @override
  _SolidoState createState() => _SolidoState();
}

class _SolidoState extends State<Solido> {
  double alfaX = 0.0;
  double alfaY = 0.0;
  double alfaZ = 0.0;
  late Timer _timer;
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
            alfaX = widget.alfaXini; //15; //14.321350097;
            alfaY = widget.alfaYini;//150; //71.777221679;
            if(widget.animato){
              _timer = Timer.periodic(
                  Duration(milliseconds: Costanti.animazioneMillisec*2),
                      (Timer _timer) => _eseguiRotazione());
            }
            setState(() {});
          });
        });
      });
    });
    super.initState();
  }
  _eseguiRotazione() {
    alfaY += 1;
    if (alfaY > 360) {
      alfaY = alfaY - 360;
    } else if (alfaY < 0) {
      alfaY = 360 - alfaY;
    }
    alfaX += 1;
    if (alfaX > 360) {
      alfaX = alfaX - 360;
    } else if (alfaX < 0) {
      alfaX = 360 - alfaX;
    }
    setState(() {});
  }
  _ruota(DragUpdateDetails update) {

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
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size/2;

    return GestureDetector(
      child: CustomPaint(
        painter: PaintSolido3D(size, modello, alfaX, alfaY, alfaZ, widget.zoom),
        size: size,
      ),
      onPanUpdate: (DragUpdateDetails update){
        //debugPrint("update " + update.toString())
        _ruota(update);
      },
    );
  }
  @override
  void dispose() {
    if(widget.animato) {
      if (_timer.isActive) {
        _timer.cancel();
      }
    }
    super.dispose();
  }
}