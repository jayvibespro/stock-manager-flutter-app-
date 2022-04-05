import 'package:flutter/material.dart';
import 'package:stocksmanager/view/components/drawer.dart';

class HesabuPage extends StatefulWidget {
  @override
  _HesabuPageState createState() => _HesabuPageState();
}

class _HesabuPageState extends State<HesabuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NewDrawer(),
    );
  }
}
