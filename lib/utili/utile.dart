import 'dart:math';

import 'package:base/pagine/percorso.dart';
import 'package:base/utili/database/sql_helper.dart';
import 'package:base/utili/variabili/costanti.dart';
import 'package:flutter/material.dart';
import '../radio.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
import 'dart:async';
import 'package:base/utili/variabili/global.dart' as globali;
import 'package:path/path.dart';

class Utili {
  static Future<void> mostraMessaggioFondoPagina(
      BuildContext context, String unMessaggio) async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(
        seconds: 2,
      ),
      content: Text(
        unMessaggio,
        style: const TextStyle(
          fontSize: 20,
          fontFamily: 'Raleway',
        ),
        strutStyle: const StrutStyle(
          fontFamily: 'Roboto',
          fontSize: 20,
          height: 1.5,
        ),
      ),
    ));
  }

  static Future<void> mostraMessaggio(
      BuildContext context, String titolo, String unMessaggio) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            titolo,
            style: const TextStyle(
              fontSize: 30,
              fontFamily: 'Raleway',
            ),
            strutStyle: const StrutStyle(
              fontFamily: 'Roboto',
              fontSize: 15,
              height: 1.5,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  unMessaggio,
                  style: const TextStyle(
                    fontSize: 15,
                    fontFamily: 'Raleway',
                  ),
                  strutStyle: const StrutStyle(
                    fontFamily: 'Roboto',
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),
                //Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Image(
                  image: AssetImage(
                      "assets/images/cubo.jpg")), //const Icon(Icons.volume_up),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            /*
            TextButton(
              child: const Text('Ok',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Raleway',
                ),
                strutStyle: StrutStyle(
                  fontFamily: 'Roboto',
                  fontSize: 30,
                  height: 1.5,
                ),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            */
          ],
        );
      },
    );
  }

  static Future<void> mostraRadioScelta(
      BuildContext context,
      List<String> scelte,
      int inEvidenza,
      String msg,
      Percorribile percorribile) async {
    RadioExample ww = RadioExample(
      rows: scelte,
      attivo: inEvidenza,
    );
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  msg,
                  style: const TextStyle(
                    fontSize: 32,
                    fontFamily: 'Raleway',
                  ),
                  strutStyle: const StrutStyle(
                    fontFamily: 'Roboto',
                    fontSize: 30,
                    height: 1.5,
                  ),
                ),
                //Text('Would you like to approve of this message?'),
                ww,
              ],
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Image(
                  image: AssetImage(
                      "assets/images/cubo.jpg")), //const Icon(Icons.volume_up),

              onPressed: () {
                Navigator.of(context).pop();
                percorribile.disegnaPagina();
              },
            ),
          ],
        );
      },
    );
  }
}

///
///
///
class CanvasConImmagini extends StatefulWidget {
  const CanvasConImmagini({Key? key}) : super(key: key);

  @override
  _CanvasConImmaginiState createState() => _CanvasConImmaginiState();
/*
  ui.Image? getImmagine() {
    return _CanvasConImmaginiState().getImg();
  }

 */
}

class _CanvasConImmaginiState extends State<CanvasConImmagini> {
  ui.Image? image;
  ui.Image? zizzo;
  int conta = 0;
  late Timer _timer;
  @override
  void initState() {
    // Add your own asset image link
    if (SQLHelper.os == 'Web') {
      _load('assets/images/fire.png');
    } else {
      _load('assets/images/database.png');
    }
    _load('assets/images/zizzo.png');
    //int _start = 0;

    var oneDecimal = Duration(milliseconds: Costanti.animazioneMillisec);
    _timer = Timer.periodic(
        oneDecimal,
        (Timer _timer) => setState(() {
              //if (_start > 1000 * 10) {
              //debugPrint("passo canc " + conta.toString());
              //_timer.cancel();
              //} else {
              //_start = _start + 100;
              conta = 1;
              //conta = conta % 100;
              //debugPrint("passo boh " + conta.toString());
              //}
            }));

    super.initState();
  }

  @override
  void dispose() {
    if (_timer.isActive) {
      _timer.cancel();
    }
    super.dispose();
  }

  /*
  @override
  void didUpdateWidget(covariant CanvasConImmagini oldWidget) {
    conta++;
    setState(() {});
    super.didUpdateWidget(oldWidget);

  }

   */
  void _load(String path) async {
    var bytes = await rootBundle.load(path);
    if (path.endsWith('zizzo.png')) {
      zizzo = await decodeImageFromList(bytes.buffer.asUint8List());
    } else {
      image = await decodeImageFromList(bytes.buffer.asUint8List());
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    //debugPrint("passo boh " + conta.toString());

    return SizedBox(
      //width: 400,
      //height: 600,
      child: CustomPaint(
        painter: PaginaGrafica(zizzo: zizzo, image: image, timer: conta),
        //child: SizedBox.expand(),
      ),
    );
  }
/*
  ui.Image? getImg() {
    return image;
  }

 */
}

class PaginaGrafica extends CustomPainter {
  PaginaGrafica(
      {required this.zizzo, required this.image, required this.timer});
  ui.Image? image;
  ui.Image? zizzo;
  int timer;
  static int ticPallina = 0;
  static int ticSole = 0;
  static int ticZizzo = 0;
  static bool avanti = true;
  static Color c1 = Colors.blue;
  static Color c2 = c1;
  static Color c11 = Colors.green;
  static Color c22 = c11;
  @override
  void paint(Canvas canvas, Size size) async {
    //debugPrint("paint w:" + size.width.toString() + " h: " + size.height.toString());
    ticPallina++;
    ticSole++;
    ticZizzo++;
    //debugPrint("passo"+conta.toString());

    double daDbX = 0;
    if (image != null) {
      daDbX = daDbX + image!.width;
    }
    double daDbY = 0;
    if (image != null) {
      daDbY = daDbY + image!.height;
    }
    double livelloPianura = size.height * 2 / 3 - 1;
    double fontDispositivo = 100;
    double adispositivoX = size.width / 2;
    //double adispositivoY = size.height / 2;
    double inizioLineaX = daDbX * 2;
    double inizioLineaY = daDbY * 2;
    double fineLineaX = adispositivoX;
    double fineLineaY = livelloPianura - fontDispositivo;
    ticSole = ticSole % 360;
    double rad = ticSole * 2 * pi / 360;

    double xSole = cos(rad);
    double ySole = sin(rad);
    canvas.save();

    var coloreCielo = <Color>[Colors.yellow, Colors.blue];
    var colorePianura = <Color>[Colors.green];
    if (ySole > 0) {
      if (xSole > 0) {
        c1 = darken(c1, 0.004);
        c2 = c1;
        coloreCielo = <Color>[Colors.yellow, c1];
        c11 = darken(c11, 0.003);
        c22 = c11;
        colorePianura = <Color>[c11];
      } else {
        c2 = lighten(c2, 0.004);
        c1 = Colors.blue;
        coloreCielo = <Color>[Colors.yellow, c2];
        c22 = lighten(c22, 0.003);
        c11 = Colors.green;
        colorePianura = <Color>[c22];
      }
    }

    /// ------ CIELO CON SOLE
    Size sizeCielo = Size(size.width, size.height * 2 / 3);
    final Rect cielo = Offset.zero & sizeCielo;

    //final Rect pianura = Offset.zero & sizePianura;
    RadialGradient sole = RadialGradient(
      center: Alignment(xSole, ySole + 0.8),
      radius: 0.2,
      colors: coloreCielo,
      stops: const <double>[0.4, 1.0],
    );
    canvas.drawRect(
      cielo,
      Paint()..shader = sole.createShader(cielo),
    );

    /// ------ DEVICE-DISPOSITIVO
    IconData icon = Costanti.device;
    TextPainter textPainter = TextPainter(textDirection: TextDirection.ltr);
    textPainter.text = TextSpan(
      text: String.fromCharCode(icon.codePoint),
      style: TextStyle(
        //height: fontDispositivo,
        color: Colors.black,
        backgroundColor: Colors.white38,
        fontSize: fontDispositivo,
        fontFamily: icon.fontFamily,
        package:
            icon.fontPackage, // This line is mandatory for external icon packs
      ),
    );
    textPainter.layout();
    textPainter.paint(
        canvas, Offset(adispositivoX, livelloPianura - fontDispositivo));

    /// ------ PIANURA
    ///

    Size sizePianura = Size(size.width, size.height * 1 / 3);
    var paint1 = Paint()
      ..color = colorePianura[0]
      ..strokeWidth = 10;
    canvas.drawRect(Offset(0, livelloPianura) & sizePianura, paint1);

    /// ------ DATABASE PNG
    Paint imgDb = Paint();
    if (image != null) {
      canvas.drawImage(image!, Offset(daDbX, daDbY), imgDb);
    } //greenBrush);

    /// ------ PATH DISPOSITIVO
    String testo = globali.pathDbDispositivo;
    if (SQLHelper.os == 'Android') {
      testo = join(testo, Costanti.nomeDB);
    } else if (SQLHelper.os == 'Web') {
      testo = "Browser web Chromium";
    }
    //int len = testo.
    var textStyle = const TextStyle(
      color: Colors.black,
      fontSize: 15,
    );
    var textSpan = TextSpan(
      text: testo,
      style: textStyle,
    );
    textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );
    var len = textPainter.size;
    var offset = Offset((size.width - len.width) / 2, livelloPianura);
    textPainter.paint(canvas, offset);

    /// ------ PATH DATABASE
    textStyle = const TextStyle(
      color: Colors.black,
      fontSize: 15,
    );
    testo = globali.pathDbOrigine;
    if (SQLHelper.os == 'Android') {
      testo = join(testo, Costanti.nomeDB);
    } else if (SQLHelper.os == 'Web') {
      testo = "FIRESTORE (Google)";
    }
    textSpan = TextSpan(
      text: testo,
      style: textStyle,
    );
    textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );
    offset = Offset(inizioLineaX, daDbY);
    textPainter.paint(canvas, offset);

    /// ------ LINEA DB -> DISPOSITIVO
    var paint2 = Paint()
      ..color = const Color(0xff000000)
      ..strokeWidth = 2;
    canvas.drawLine(Offset(inizioLineaX, inizioLineaY),
        Offset(fineLineaX, fineLineaY), paint2);

    /// ------ ANIMAZIONE PALLINA
    var paint4 = Paint()..color = const Color(0xFFFF9000);
    //..strokeWidth = 10;

    double rapportoXy =
        (fineLineaY - inizioLineaY) / (fineLineaX - inizioLineaX);
    double x = 0;
    double y = 0;
    if (avanti) {
      x = inizioLineaX + 5 * ticPallina.toDouble();
      y = inizioLineaY + rapportoXy * 5 * ticPallina.toDouble();
    } else {
      x = fineLineaX - 5 * ticPallina.toDouble();
      y = fineLineaY - rapportoXy * 5 * ticPallina.toDouble();
    }
    if (x >= fineLineaX) {
      ticPallina = 0;
      avanti = !avanti;
    }
    if (x <= inizioLineaX) {
      ticPallina = 0;
      avanti = !avanti;
    }
    Rect rect = Rect.fromCircle(center: Offset(x, y), radius: 10);
    //Rect rect = Offset(x, y) & const Size(10.0, 10.0);
    canvas.drawOval(rect, paint4);

    /// ------ MOTO ZIZZO
    Paint imgzizzo = Paint();
    if (zizzo != null) {
      double xZizzo = ticZizzo.toDouble() - zizzo!.width.toDouble();
      double yZizzo = livelloPianura;
      canvas.drawImage(zizzo!, Offset(xZizzo, yZizzo), imgzizzo);
      if (xZizzo > size.width * 2) {
        ticZizzo = 0;
      }
    } //greenBrush);

    canvas.restore();
  }

  @override
  bool shouldRepaint(PaginaGrafica oldDelegate) {
    return true;
  }

  Color darken(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  Color lighten(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslLight =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }
}
