import 'package:flutter/material.dart';
import 'package:untitled3/View/Components/LargeScreen.dart';
import 'package:untitled3/View/Components/smallScreen.dart';

class BranchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            return LargeScreen();
          } else {
            return SmallScreen();
          }
        },
      ),
    );
  }
}