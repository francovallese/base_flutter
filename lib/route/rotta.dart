import 'package:flutter/material.dart';
import '../pagine/pagina1.dart';
import '../pagine/pagina2.dart';
import '../pagine/pagina2_1.dart';
import '../pagine/pagina3.dart';
import '../pagine/pagina4.dart';

class RottaPagine {
  static Route<dynamic>? generateRoute(RouteSettings settings)
  {
    //debugPrint("--SETTING-------->: " + settings.name!);
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const Page1());
      case '/page2':
        return MaterialPageRoute(builder: (_) => const Page2());
      case '/page2/page2_1':
        return MaterialPageRoute(builder: (_) => const Page2sub1());
      case '/page3':
        return MaterialPageRoute(builder: (_) => const Page3());
      case '/page4':
        return MaterialPageRoute(builder: (_) => const Page4());
    }
    return null;
  }
}