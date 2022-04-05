import 'package:flutter/material.dart';
import 'package:stocksmanager/view/components/drawer.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NewDrawer(),
    );
  }
}
