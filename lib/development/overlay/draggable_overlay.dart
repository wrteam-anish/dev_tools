import 'package:flutter/material.dart';

class DraggableOverlay extends StatefulWidget {
  final Widget child;
  const DraggableOverlay({super.key, required this.child});

  @override
  State<DraggableOverlay> createState() => _DraggableOverlayState();
}

class _DraggableOverlayState extends State<DraggableOverlay> {
  Offset position = Offset(100, 100);
  late Size screenSize = MediaQuery.of(context).size;
  late Offset topLeft = screenSize.topLeft(Offset(-20, 0));
  late Offset bottomRight = screenSize.bottomRight(Offset.zero);
  Rect? rect;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        rect = Rect.fromPoints(topLeft, bottomRight);
        rect = rect?.deflate(50);
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: position.dy,
      left: position.dx,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Draggable(
            feedback: SizedBox.shrink(),
            onDragUpdate: (details) {
              if (rect?.contains(details.globalPosition) ?? false) {
                position = details.globalPosition;
                setState(() {});
              }
            },
            child: widget.child,
          ),
        ],
      ),
    );
  }
}
