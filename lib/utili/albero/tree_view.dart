import 'package:base/utili/variabili/costanti.dart';
import 'package:flutter/material.dart';
import 'tree_node.dart';

class TreeView extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final BuildContext context;
  final bool note;
  final String titleKey;
  final String leadingKey;
  final String expanedKey;
  final String childrenKey;
  final double offsetLeft;

  final Function? titleOnTap;
  final Function? leadingOnTap;
  final Function? trailingOnTap;

  const TreeView(
      {required this.context,
      required this.data,
      required this.note,
      this.titleKey = 'title',
      this.leadingKey = 'leading',
      this.expanedKey = 'expaned',
      this.childrenKey = 'children',
      this.offsetLeft = 10.0,
      this.titleOnTap,
      this.leadingOnTap,
      this.trailingOnTap,
      Key? key})
      : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Column(
      //crossAxisAlignment: CrossAxisAlignment.center,
      children: List.generate(data.length, (int index) {
        final Map<String, dynamic> item = data[index];
        final title = item[titleKey] == null ? null : Text(item[titleKey]);//(note) ? ElevatedButton(onPressed: () {},child:Text(item[titleKey])) : Text(item[titleKey]);
        final leading =
            item[leadingKey] == null ? null : Text(item[leadingKey]);//(note) ? ElevatedButton(onPressed: () {},child:Text(item[leadingKey])) : Text(item[leadingKey]);
        final expaned = item[expanedKey] ?? false;
        final children = item[childrenKey] as List;

        return TreeNode(
          title: title,
          leading: leading,
          expaned: expaned,
          offsetLeft: offsetLeft,
          titleOnTap: titleOnTap,
          leadingOnTap: leadingOnTap,
          trailingOnTap: trailingOnTap,
          children: _geneTreeNodes(children, context),
        );

      }),
    );
  }
  List<TreeNode> _geneTreeNodes(List list, BuildContext context) {
    List treeNodes = <TreeNode>[];

    for (int i = 0; i < list.length; i++) {
      final Map<String, dynamic> item = list[i];
      final title = item[titleKey] == null
          ? null
          : (note && bottone(item[titleKey]as String)) ? ElevatedButton(style:ElevatedButton.styleFrom(
        primary: Costanti.coloreBgTestoBottoneTree,padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),), onPressed: () {titleOnTap!(item[titleKey]);},child:Text(item[titleKey],
          style: TextStyle(
            color: (item[titleKey].toString().startsWith("P") ||
                item[titleKey].toString().startsWith("pagine") ||
                item[titleKey].toString().startsWith("route") ||
                item[titleKey].toString().startsWith("utili") ||
                item[titleKey].toString().startsWith("albero") ||
                item[titleKey].toString().startsWith("database") ||
                item[titleKey].toString().startsWith("solidi") ||
                item[titleKey].toString().startsWith("variabili"))
                ? Colors.amberAccent //Costanti.coloreBgCalamaioPag
                : Costanti.coloreFgTestoBottoneTree,
          ))) : Text(item[titleKey],style: TextStyle(
        color: (item[titleKey].toString().startsWith("DB") ||
            item[titleKey].toString().startsWith("Video") ||
            item[titleKey].toString().startsWith("Info DB") ||
            item[titleKey].toString().startsWith("pagine") ||
            item[titleKey].toString().startsWith("route") ||
            item[titleKey].toString().startsWith("utili") ||
            item[titleKey].toString().startsWith("albero") ||
            item[titleKey].toString().startsWith("database") ||
            item[titleKey].toString().startsWith("solidi") ||
            item[titleKey].toString().startsWith("variabili"))
            ? Costanti.coloreBgCalamaioPag
            : Costanti.coloreBgCalamaioMenu,
      ));
      final leading = item[leadingKey] == null ? null : Text(item[leadingKey]); // (note) ? ElevatedButton(onPressed: () {},child:Text(item[leadingKey])) : Text(item[leadingKey]);
      final expaned = item[expanedKey] ?? false;
      final children = item[childrenKey] as List;

      treeNodes.add(TreeNode(
        title: title,
        leading: leading,
        expaned: expaned,
        offsetLeft: offsetLeft,
        titleOnTap: titleOnTap,
        leadingOnTap: leadingOnTap,
        trailingOnTap: trailingOnTap,
        children: _geneTreeNodes(children, context),
      ));
    }

    return treeNodes as List<TreeNode>;
  }
  bool bottone(String item) {

    var bottoni =
    {'rotta.dart','percorso.dart','scorrimento.dart','funz.dart','invarca_funzioni.dart','visual.dart','sql_helper.dart','solido.dart'};
    bool ret = false;
    if(bottoni.contains(item)) {
      ret=true;
    }
    return ret;
  }
}
