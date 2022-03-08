import 'dart:io';
import 'package:base/utili/database/invarca_funzioni.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:base/utili/variabili/global.dart' as globali;
import '../../pagine/percorso.dart';
import '../variabili/costanti.dart';
import 'package:path/path.dart';

class SQLHelper {
  static String os = trovaOs();
  static Percorribile? percorribile;
  static late sql.Database myopenDB;
  static bool aperto = false;
  static int primo = 0;
  static String perc = "";

  static Future<String> percorsoDb() async {
    String path = "";
    if (os == 'Android') {
      perc = await sql.getDatabasesPath();
    } else {
      //FRANCO da fare
      path = Costanti.nomeLinuxDB;
    }
    return path;
  }

  static Future<void> db() async {
    String path = Costanti.nomeDB;
    if (os == 'Android') {
      var databasesPath = "boh!";
      await sql.getDatabasesPath().then((value) {
        globali.pathDbDispositivo = value;
        databasesPath = value;
      });

      //debugPrint("dove cercare il db ..." + databasesPath);
      var path = join(databasesPath, Costanti.nomeDB);
      await sql.openDatabase(
        path,
        version: 1,
        onCreate: (sql.Database database, int version) async {
          await createTables(database);
        },
        onOpen: (sql.Database database) {
          myopenDB = database;
        },
      ).whenComplete(() {
        aperto = true;
      });
    } else if (os == 'Linux') {
      path = Costanti.nomeLinuxDB;
      globali.pathDbDispositivo = path;
    } else if (os == 'Windows') {
      path = Costanti.nomeWindowsDB;
      globali.pathDbDispositivo = path;
    }
    await sql.openDatabase(
      path,
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
      onOpen: (sql.Database database) {
        myopenDB = database;
      },
    ).whenComplete(() {
      aperto = true;
    });
  }

  //static late List<Map<String, dynamic>> ret;
  static Future<void> getItems() async {
    List<Map<String, dynamic>> ret = [];
    bool ok = true;
    SQLHelper.db().whenComplete(() async {
      if (!aperto) {
        MyInvarcaFunzioni.listaRecord = ret;
        MyInvarcaFunzioni.isLoading = !ok;
        trattaErrore("ERRORE APERTURA!!!");
      } else {
        ret = await myopenDB.query(Costanti.nomeTAB, orderBy: "id");
        // FRANCO COME SI CONTROLLA ret
        //debugPrint("ELEMENTI: " + ret.length.toString());
        MyInvarcaFunzioni.listaRecord = ret;
        MyInvarcaFunzioni.isLoading = ok;
        //percorribile?.cambiaNumRecordInEvidenza(ret[primo]['id'].toString());
        percorribile?.disegnaPagina();
        myopenDB.close();
      }
    });
  }

  static Future<void> createItem(String title, String? descrption) async {
    List<Map<String, dynamic>> ret = [];
    bool ok = true;
    SQLHelper.db().whenComplete(() async {
      if (!aperto) {
        MyInvarcaFunzioni.isLoading = !ok;
        trattaErrore("ERRORE APERTURA!!!");
      } else {
        final data = {'title': title, 'description': descrption};
        final id = await myopenDB.insert(Costanti.nomeTAB, data,
            conflictAlgorithm: sql.ConflictAlgorithm.replace);
        // FRANCO COME SI CONTROLLA ret
        //debugPrint("NUOVO: " + id.toString());

        ret = await myopenDB.query(Costanti.nomeTAB, orderBy: "id");
        // FRANCO COME SI CONTROLLA ret
        //debugPrint("ELEMENTI: " + ret.length.toString());
        MyInvarcaFunzioni.listaRecord = ret;
        MyInvarcaFunzioni.isLoading = ok;
        percorribile?.cambiaNumRecordInEvidenza(
            id.toString(), false, Costanti.nuovoRecord);
        myopenDB.close();
      }
    });
  }

// Update an item by id
  static Future<void> updateItem(
      int id, String title, String? descrption) async {
    List<Map<String, dynamic>> ret = [];
    bool ok = true;
    SQLHelper.db().whenComplete(() async {
      if (!aperto) {
        trattaErrore("ERRORE APERTURA!!!");
      } else {
        final data = {
          'title': title,
          'description': descrption,
          'createdAt': DateTime.now().toString()
        };
        int quanti = await myopenDB
            .update(Costanti.nomeTAB, data, where: "id = ?", whereArgs: [id]);
        // FRANCO COME SI CONTROLLA quanti
        //debugPrint("VARIA: " + id.toString());

        ret = await myopenDB.query(Costanti.nomeTAB, orderBy: "id");
        // FRANCO COME SI CONTROLLA ret
        //debugPrint("ELEMENTI: " + ret.length.toString());
        MyInvarcaFunzioni.listaRecord = ret;
        MyInvarcaFunzioni.isLoading = ok;
        percorribile?.cambiaNumRecordInEvidenza(
            id.toString(), false, Costanti.variaRecord);
        myopenDB.close();
      }
    });
  }

  // Delete
  static Future<int> deleteItem(int id) async {
    int ret = -1;
    bool ok = true;
    SQLHelper.db().whenComplete(() async {
      if (!aperto) {
        ret = 0;
        trattaErrore("ERRORE APERTURA!!!");
      } else {
        await myopenDB.delete(Costanti.nomeTAB,
            where: "id = ?", whereArgs: [id]).then((value) {
          ret = value;
          getItems();
        });
      }
    });
    return ret;
  }

  // Ricerca
  static Future<void> searchTitle(String title) async {
    List<Map<String, dynamic>> ret = [];
    bool ok = true;
    SQLHelper.db().whenComplete(() async {
      if (!aperto) {
        MyInvarcaFunzioni.listaRecordRicerca = ret;
        MyInvarcaFunzioni.isLoading = !ok;
        trattaErrore("ERRORE APERTURA!!!");
      } else {
        ret = await myopenDB.rawQuery(' select * from ' +
            Costanti.nomeTAB +
            ' WHERE title = "' +
            title +
            '"');
        // FRANCO COME SI CONTROLLA ret
        //debugPrint("ELEMENTI: " + ret.length.toString());
        MyInvarcaFunzioni.listaRecordRicerca = ret;
        MyInvarcaFunzioni.isLoading = ok;
        //percorribile?.cambiaNumRecordInEvidenza(ret[primo]['id'].toString());
        percorribile?.disegnaPagina();
      }
    });
  }

  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    List<Map<String, dynamic>> ret = [];
    bool ok = true;
    SQLHelper.db().whenComplete(() async {
      if (!aperto) {
        trattaErrore("ERRORE APERTURA!!!");
      } else {
        ret = await myopenDB.query(Costanti.nomeTAB,
            where: "id = ?", whereArgs: [id], limit: 1);
      }
    });
    return ret;
  }

  static String trovaOs() {
    var platformName = '';
    if (kIsWeb) {
      platformName = "Web";
    } else {
      if (Platform.isAndroid) {
        platformName = "Android";
      } else if (Platform.isIOS) {
        platformName = "IOS";
      } else if (Platform.isFuchsia) {
        platformName = "Fuchsia";
      } else if (Platform.isLinux) {
        platformName = "Linux";
      } else if (Platform.isMacOS) {
        platformName = "MacOS";
      } else if (Platform.isWindows) {
        platformName = "Windows";
      }
    }
    return platformName.toString();
  }

  static Future<int?> contaRecord() async {
    /*
    final db = await SQLHelper.db();
    int? num = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM '+Costanti.nomeTAB));

    return num;
     */
    return 1;
  }

  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE items(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        title TEXT,
        description TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }

  static void trattaErrore(String s) {
    debugPrint(s);
  }

  static Future<void> caricaDb() async {
    if (os == "Web") {
      //debugPrint("----------------------------" + "passo");
      await Firebase.initializeApp(
        options: const FirebaseOptions(
            // databaseURL: 'https://react-native-firebase-testing.firebaseio.com',
            apiKey: "AIzaSyBx9tfwxqliws4RCrxkcN0ZHSHnHswSOhg",
            authDomain: "myfp-4f77f.firebaseapp.com",
            projectId: "myfp-4f77f",
            storageBucket: "myfp-4f77f.appspot.com",
            messagingSenderId: "172890330168",
            appId: "1:172890330168:web:249b630961709a59c102cd",
            measurementId: "G-R2J0T19PJ5"),
      ).then((value) async {
        FirebaseAuth _auth = FirebaseAuth.instance;
        try {
          await _auth.signInAnonymously().then((value) {
            //debugPrint("value :--------->" + value.toString());
            var x = _auth.currentUser;
            bool? anonimo = x?.isAnonymous;
            //debugPrint("utente anonimo :--------->" + anonimo.toString());
          });
        } catch (e) {
          debugPrint("errore: " + e.toString());
        }
      });
      return;
    }
    var databasesPath = Costanti.nomeLinuxDB;
    var path = "";
    if (os == "Android") {
      databasesPath = await sql.getDatabasesPath();
      path = join(databasesPath, Costanti.nomeDB);
    }

    globali.pathDbDispositivo = databasesPath.toString();
    //debugPrint("dove cercare il db ..." + databasesPath);
    String pathOrigine = globali.pathDbDispositivo;
    if (os == "Android") {
      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      pathOrigine = "assets/db/";

      var pathSorgente = join(pathOrigine, Costanti.nomeDB);
      //debugPrint("path_sorgente ..." + pathSorgente);
      ByteData data = await rootBundle.load(pathSorgente);
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      //debugPrint("Write DB " + path);
      await File(path).writeAsBytes(bytes, flush: true);
    }
    globali.pathDbOrigine = pathOrigine;
    //debugPrint("RICREATO DB ");
  }
}
