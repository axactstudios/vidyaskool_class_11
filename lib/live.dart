import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class live extends StatefulWidget {
  @override
  _liveState createState() => _liveState();
}

class _liveState extends State<live> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFFBFFFE),
          title: Center(
            child: Text(
              'VidyaSkool',
              style: GoogleFonts.quicksand(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Color(0xFF1B1B1E),
//              shadows: [
//                Shadow(
//                  blurRadius: 1.0,
//                  color: Color(0xFFFBFFFE).withOpacity(0.5),
//                  offset: Offset(0.0, 0.0),
//                ),
//              ],
              ),
            ),
          ),
        ),
        backgroundColor: Color(0xFF1B1B1E),
        body: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: TextEditingController()
                  ..text =
                      "https://us04web.zoom.us/j/76392577530?pwd=N09UVGYyNTJIMk1BNFRBbVMvbUp2QT09",
                onChanged: (value) {},
                style: TextStyle(
                  color: Color(0xFFC5891E),
                ),
                decoration: InputDecoration(
                    suffixIcon: Icon(
                      Icons.content_copy,
                      color: Color(0xFFFBFFFE),
                    ),
                    prefixIcon: Icon(
                      Icons.computer,
                      color: Color(0xFFFBFFFE),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    filled: true,
                    fillColor: Color(0xFF1B1B1E)),
              ),
              SizedBox(height: height * 0.08),
              TextField(
                enabled: false,
                controller: TextEditingController()..text = "0EiQxW",
                onChanged: (value) {},
                style: TextStyle(
                  color: Color(0xFFC5891E),
                ),
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Color(0xFFFBFFFE),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    filled: true,
                    fillColor: Color(0xFF1B1B1E)),
              ),
              SizedBox(height: height * 0.08),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF1B1B1E),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFFBFFFE).withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: Offset(0, 0), // changes position of shadow
                      ),
                    ],
                  ),
                  height: 0.08 * height,
                  width: 0.80 * width,
                  child: RaisedButton(
                      color: Color(0xFF1B1B1E),
                      elevation: 6.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Text('Go to meeting',
                          style: GoogleFonts.quicksand(
                              color: Color(0xFFC5891E),
                              fontSize: 0.03 * height,
                              fontWeight: FontWeight.bold)),
                      onPressed: () {}),
                ),
              )
            ],
          ),
        ));
  }
}
