import 'package:base/utili/variabili/costanti.dart';
import 'package:flutter/material.dart';
import 'tree_node.dart';

class TreeView extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  final String titleKey;
  final String leadingKey;
  final String expanedKey;
  final String childrenKey;
  final double offsetLeft;

  final Function? titleOnTap;
  final Function? leadingOnTap;
  final Function? trailingOnTap;

  const TreeView({
    required this.data,
    this.titleKey = 'title',
    this.leadingKey = 'leading',
    this.expanedKey = 'expaned',
    this.childrenKey = 'children',
    this.offsetLeft = 20.0,
    this.titleOnTap,
    this.leadingOnTap,
    this.trailingOnTap,
    Key? key
  }): super(key: key);

  List<TreeNode> _geneTreeNodes(List list) {
    List treeNodes = <TreeNode>[];

    for (int i = 0; i < list.length; i++) {
      final Map<String, dynamic> item = list[i];
      final title = item[titleKey] == null
          ? null
          : Text(item[titleKey],
              style: TextStyle(
                color: (item[titleKey].toString().startsWith("P") ||
                        item[titleKey].toString().startsWith("pagine") ||
                        item[titleKey].toString().startsWith("route") ||
                        item[titleKey].toString().startsWith("utili") ||
                        item[titleKey].toString().startsWith("albero") ||
                        item[titleKey].toString().startsWith("database") ||
                        item[titleKey].toString().startsWith("variabili"))
                    ? Costanti.coloreBgCalamaioPag
                    : Costanti.coloreBgCalamaioMenu,
              ));
      final leading = item[leadingKey] == null ? null : Text(item[leadingKey]);
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
        children: _geneTreeNodes(children),
      ));
    }

    return treeNodes as List<TreeNode>;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(data.length, (int index) {
        final Map<String, dynamic> item = data[index];
        final title = item[titleKey] == null ? null : Text(item[titleKey]);
        final leading =
            item[leadingKey] == null ? null : Text(item[leadingKey]);
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
          children: _geneTreeNodes(children),
        );
      }),
    );
  }
}
