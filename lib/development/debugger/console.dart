import 'package:dev_tools/development/debugger/stream_list.dart';
import 'package:flutter/material.dart';

ListSync<FlutterErrorDetails> customExceptions =
    ListSync<FlutterErrorDetails>();

class Console extends StatefulWidget {
  const Console({super.key});
  static void use() {
    FlutterError.onError = (FlutterErrorDetails error) {
      customExceptions.addItem(error);
      FlutterError.presentError(error);
    };
  }

  @override
  State<Console> createState() => _ConsoleState();
}

class _ConsoleState extends State<Console> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 32, 32, 32),
      child: ValueListenableBuilder(
          valueListenable: customExceptions.listenable,
          builder: (context, value, child) {
            if (value.isEmpty) {
              return Center(
                  child: Text(
                'No issues found',
                style: TextStyle(color: Colors.white),
              ));
            }
            return ListView.builder(
              shrinkWrap: true,
              itemCount: value.length,
              reverse: true,
              padding: EdgeInsets.all(8),
              itemBuilder: (context, index) {
                FlutterErrorDetails exception = value[index];
                return Text(
                  exception.toString(),
                  style: TextStyle(color: Colors.red),
                );
              },
            );
          }),
    );
  }
}
