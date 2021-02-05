import 'package:flutter/material.dart';

class search extends StatefulWidget {
  @override
  _searchState createState() => _searchState();
}

class _searchState extends State<search> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF1B1B1E),
        appBar: AppBar(
            backgroundColor: Color(0xFFFBFFFE),
            title: TextField(
              style: TextStyle(
                color: Color(0xFF1B1B1E),
              ),
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Color(0xFF1B1B1E)),
                  hintText: "Search",
                  hintStyle: TextStyle(color: Colors.grey)),
            )));
  }
}
