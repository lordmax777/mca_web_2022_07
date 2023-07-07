import 'package:flutter/material.dart';

class RootView extends StatelessWidget {
  const RootView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RefreshProgressIndicator(),
      ),
    );
  }
}
