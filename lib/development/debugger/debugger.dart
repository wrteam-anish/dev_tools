import 'package:dev_tools/development/debugger/api_logger.dart';
import 'package:dev_tools/development/debugger/console.dart';
import 'package:dev_tools/development/overlay/draggable_overlay.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Debugger {
  static bool isExpanded = false;
  static void init(BuildContext context) {
    if (kDebugMode) {
      WidgetsBinding.instance.addPostFrameCallback(
        (timeStamp) {
          OverlayEntry entry = OverlayEntry(
              builder: (context) => DraggableOverlay(
                      child: GestureDetector(
                    onTap: () async {
                      if (!isExpanded) {
                        isExpanded = true;
                        await showModalBottomSheet(
                          context: context,
                          constraints: BoxConstraints(
                              maxHeight:
                                  MediaQuery.of(context).size.height * 0.7),
                          builder: (context) {
                            return const DebuggerView();
                          },
                        );

                        isExpanded = false;
                      } else {
                        isExpanded = false;
                        Navigator.of(context).pop();
                      }
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.brown.shade900,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.settings, color: Colors.white),
                    ),
                  )));
          Overlay.of(context).insert(entry);
        },
      );
    }
  }
}

class DebuggerView extends StatefulWidget {
  const DebuggerView({
    super.key,
  });

  @override
  State<DebuggerView> createState() => _DebuggerViewState();
}

class _DebuggerViewState extends State<DebuggerView> {
  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(tabs: [Tab(text: 'APIs'), Tab(text: 'Console')]),
            Expanded(
              child: TabBarView(children: [ApiLogger(), const Console()]),
            )
          ],
        ));
  }
}
