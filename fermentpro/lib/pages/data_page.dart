import 'package:FermentPro/components/frosted_glass.dart';
import 'package:flutter/material.dart';


class DataPage extends StatelessWidget {
  const DataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: const FrostedGlass(theWidth: 200.0,
            theHeight: 200.0,
            theChild: Text('Hello world',
            style: TextStyle(fontSize: 20, color: Colors.white),))

      ),

    );
  }
}


