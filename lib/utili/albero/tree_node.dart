import 'package:flutter/material.dart';

class TreeNode extends StatefulWidget {
  final String riga;
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

  const TreeNode({Key? key,

    this.level = 0,
    this.expaned = true,
    this.offsetLeft = 20.0,
    this.children = const [],
    this.title = const Text('Title'),
    this.riga = "",
    this.leading = const Text(''),

    this.trailing =  const IconButton(
      mouseCursor:  SystemMouseCursors.click,
      icon: Icon(Icons.arrow_downward),
      iconSize: 12, // 16
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
  }) : super(key: key);

  @override
  _TreeNodeState createState() => _TreeNodeState();


}

class _TreeNodeState extends State<TreeNode>
    with SingleTickerProviderStateMixin {
  bool _isExpaned = true;

  late AnimationController _rotationController;
  final Tween<double> _turnsTween = Tween<double>(begin: 0.0, end: -0.25);

  @override
  initState() {
    _isExpaned = widget.expaned;
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
        //value: 0.5,
        //lowerBound: 0.0,
        //upperBound: 0.5
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

              //const SizedBox(width: 6.0),
              Visibility(
                visible: children.isNotEmpty,
                child: Container(
                  height: 24,
                  color:Colors.transparent,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isExpaned = !_isExpaned;
                        if (_isExpaned) {
                          _rotationController.reverse();
                        } else {
                          _rotationController.forward();
                        }
                        if (widget.trailingOnTap != null &&
                            widget.trailingOnTap is Function) {
                          widget.trailingOnTap!();
                        }
                      });
                    },
                    child: RotationTransition(
                      alignment: Alignment.center,
                      child: widget.trailing ??
                          IconButton(
                            alignment: Alignment.center,
                            //RmouseCursor: ,
                            icon: const Icon(Icons.arrow_downward),
                            iconSize: 12, // 16
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

                    var xx = widget.title as Text;

                    String s = xx.data!;
                    widget.titleOnTap!(s);
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
            child: Container(
                color:Colors.transparent,
                child:Column(
              children: widget.children,
              crossAxisAlignment: CrossAxisAlignment.start,
            )),
          ),
        ),
      ],
    );
  }
}
