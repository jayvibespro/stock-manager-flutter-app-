import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Padding(
            padding: EdgeInsets.only(left: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search...",
                fillColor: Colors.white,
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        actions: [
          GestureDetector(
            child: const Icon(Icons.cancel),
            onTap: () {
//              Navigator.pop(context);
            },
          ),
          const SizedBox(
            width: 20,
          )
        ],
      ),
      body: const Center(
        child: Text(
          'No item loaded...',
          style: TextStyle(color: Colors.black54),
        ),
      ),
    );
  }
}
