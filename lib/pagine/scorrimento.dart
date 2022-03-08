import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

abstract class Scorribile {
  ItemScrollController getItemScrollController();
  ItemPositionsListener getItemPositionsListener();
  void mostraFine(int index);
}