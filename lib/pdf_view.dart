import 'dart:io';

import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PdfView extends StatefulWidget {
  String filename;
  PdfView(this.filename);
  @override
  _PdfViewState createState() => _PdfViewState();
}

class _PdfViewState extends State<PdfView> {

  bool _isloading=true;
  PDFDocument doc;
  void loadDocument( ) async {

    print("--");
    File file  = File(widget.filename);
    doc = await PDFDocument.fromFile(file);
    setState(() => _isloading = false);
  }
  @override
  void initState() {
    loadDocument();
    super.initState();
  }
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        backgroundColor: Color(0xFFFBFFFE),
        title: Center(
          child: Text(
            'VidyaSkool',
            style: GoogleFonts.quicksand(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              color: Color(0xFF1B1B1E),

            ),
          ),
        ),
      ),
      backgroundColor: Color(0xFF1B1B1E),
      body: (_isloading)
          ? Center(child: CircularProgressIndicator())
          : Center(
        child: Container(
          height:MediaQuery.of(context).size.height*0.8,
          width:MediaQuery.of(context).size.width,
          child: PDFViewer(
            document: doc,
            zoomSteps: 1,

            lazyLoad: false,

            scrollDirection: Axis.vertical,

//
//                  navigationBuilder:
//                        (context, page, totalPages, jumpToPage, animateToPage) {
//                      return ButtonBar(
//                        alignment: MainAxisAlignment.spaceEvenly,
//                        children: <Widget>[
//                          IconButton(
//                            icon: Icon(Icons.first_page),
//                            onPressed: () {
//                              jumpToPage((page: 0));
//                            },
//                          ),
//                          IconButton(
//                            icon: Icon(Icons.arrow_back),
//                            onPressed: () {
//                              animateToPage(page: page - 2);
//                            },
//                          ),
//                          IconButton(
//                            icon: Icon(Icons.arrow_forward),
//                            onPressed: () {
//                              animateToPage(page: page);
//                            },
//                          ),
//                          IconButton(
//                            icon: Icon(Icons.last_page),
//                            onPressed: () {
//                              jumpToPage(page: totalPages - 1);
//                            },
//                          ),
//                        ],
//                      );

          ),
        ),
      ),

    );
  }
}
