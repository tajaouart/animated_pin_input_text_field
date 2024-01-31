/*import 'package:flutter/material.dart';

import 'custom_text_editing_controller.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final controller = CustomTextEditingController()
    ..addListener(() {
      debugPrint('+++++hi');
    });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Custom Editable Text'),
        ),
        body: Center(
          child: Container(
            color: Colors.red,
            child: TextField(
              controller: controller,
              onChanged: (text) {
                debugPrint('Text changed: $text');
                // Add your onChanged logic here
              },
            ),
          ),
        ),
      ),
    );
  }
}
*/