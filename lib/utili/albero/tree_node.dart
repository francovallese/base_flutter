import 'package:flutter/material.dart';

class TreeNode extends StatefulWidget {
  final int level;
  final bool expaned;
  final double offsetLeft;
  final List<Widget> children;

  final Widget? title;
  final Widget? leading;
  final Widget? trailing;

  final Function? titleOnTap;
  final Function? leadingOnTap;
  final Function? trailingOnTap;

  const TreeNode({
    this.level = 0,
    this.expaned = false,
    this.offsetLeft = 20.0,
    this.children = const [],
    this.title = const Text('Title'),
    this.leading = const Text(''),

    this.trailing =  const IconButton(
      mouseCursor:  SystemMouseCursors.click,
      icon: Icon(Icons.expand_more),
      iconSize: 32, // 16
      onPressed: null,
      //onPressed: () {
      //  print('x');
        /*
        setState(() {

        });

         */
      //},
    ),
    this.titleOnTap,
    this.leadingOnTap,
    this.trailingOnTap,
  });

  @override
  _TreeNodeState createState() => _TreeNodeState();


}

class _TreeNodeState extends State<TreeNode>
    with SingleTickerProviderStateMixin {
  bool _isExpaned = false;

  late AnimationController _rotationController;
  final Tween<double> _turnsTween = Tween<double>(begin: 0.0, end: -0.5);

  @override
  initState() {
    _isExpaned = widget.expaned;
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final level = widget.level;
    final children = widget.children;
    final offsetLeft = widget.offsetLeft;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[

              const SizedBox(width: 6.0),
              Visibility(
                visible: children.isNotEmpty,
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isExpaned = !_isExpaned;
                        if (_isExpaned) {
                          _rotationController.forward();
                        } else {
                          _rotationController.reverse();
                        }
                        if (widget.trailingOnTap != null &&
                            widget.trailingOnTap is Function) {
                          widget.trailingOnTap!();
                        }
                      });
                    },
                    child: RotationTransition(
                      child: widget.trailing ??
                          IconButton(
                            //RmouseCursor: ,
                            icon: const Icon(Icons.expand_more),
                            iconSize: 32, // 16
                            onPressed: () {},
                          ),
                      turns: _turnsTween.animate(_rotationController),
                    ),
                  ),
                ),
              ),
              //const SizedBox(width: 6.0),
              //Expanded(
              //child:
              GestureDetector(
                onTap: () {
                  if (widget.titleOnTap != null &&
                      widget.titleOnTap is Function) {
                    widget.titleOnTap!();
                  }
                },
                child: widget.title ?? Container(),
              ),
              //),
            ],
          ),
        ),
        Visibility(
          visible: children.isNotEmpty && _isExpaned,
          child: Padding(
            padding: EdgeInsets.only(
              left: level + 1 * offsetLeft,
              right: level + 1 * offsetLeft,
            ),
            child: Column(
              children: widget.children,
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          ),
        ),
      ],
    );
  }
}
