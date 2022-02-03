import 'package:flutter/material.dart';
class MoreDataRoute extends StatelessWidget {
  const MoreDataRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('More Data'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('go home'),
        ),

      ),
    );
  }
}
