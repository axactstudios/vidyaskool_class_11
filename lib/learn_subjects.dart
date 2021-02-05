import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Classes/demo.dart';
import 'learn_days.dart';

class LearnSubjects extends StatefulWidget {
  String section;List<demo>filteredlists=[];
  LearnSubjects(this.section,this.filteredlists);
  @override
  _LearnSubjectsState createState() => _LearnSubjectsState();
}

class _LearnSubjectsState extends State<LearnSubjects> {

  List<String> allsubjects=[];
  void getsubjects(){
    print(widget.filteredlists.length);
    for(var d in widget.filteredlists) {
      if(d.course==widget.section){
        if (!allsubjects.contains(d.subject)) {
          allsubjects.add(d.subject);
        }
      }
    }
    print(allsubjects.length);
  }
  @override
  void initState() {
    getsubjects();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    print(widget.section);
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
            ),
          ),
        ),
        actions: <Widget>[
          Icon(
            Icons.close,
            size: 45,
            color: Color(0xFFFBFFFE),
          )
        ],
      ),
      body: Container(
          color: Color(0xFF1B1B1E),
          child:ListView.builder(
            itemCount:allsubjects.length,
            itemBuilder: (context,index){
              var item =allsubjects[index];
              return  Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
                child: InkWell(
                  onTap: () {
//                  Navigator.push(
//                      context,
//                      MaterialPageRoute(
//                        builder: (context) =>
////                            LearnDays(widget.section, item,widget.filteredlists),
//                      ));
                  },
                  child: Container(
                    height: 100,
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
                    alignment: Alignment.center,
                    child: Text(
                      item,
                      style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.w500,
                        fontSize: 40,
                        color: Color(0xFFC5891E),

                      ),
                    ),
                  ),
                ),
              );
            },
          )
//        child: ListView(
//          children: <Widget>[
//            Container(
//              height: 20,
//            ),
//            Padding(
//              padding:
//                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
//              child: InkWell(
//                onTap: () {
//                  Navigator.push(
//                      context,
//                      MaterialPageRoute(
//                        builder: (context) =>
//                            LearnDays(widget.section, 'Physics'),
//                      ));
//                },
//                child: Container(
//                  height: 100,
//                  decoration: BoxDecoration(
//                    color: Color(0xFF1B1B1E),
//                    borderRadius: BorderRadius.all(Radius.circular(10)),
//                    boxShadow: [
//                      BoxShadow(
//                        color: Color(0xFFFBFFFE).withOpacity(0.1),
//                        spreadRadius: 2,
//                        blurRadius: 10,
//                        offset: Offset(0, 0), // changes position of shadow
//                      ),
//                    ],
//                  ),
//                  alignment: Alignment.center,
//                  child: Text(
//                    'Physics',
//                    style: GoogleFonts.quicksand(
//                      fontWeight: FontWeight.w500,
//                      fontSize: 40,
//                      color: Color(0xFFC5891E),
////
//                    ),
//                  ),
//                ),
//              ),
//            ),
//            Padding(
//              padding:
//                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
//              child: InkWell(
//                onTap: () {
//                  Navigator.push(
//                      context,
//                      MaterialPageRoute(
//                        builder: (context) =>
//                            LearnDays(widget.section, 'Physics'),
//                      ));
//                },
//                child: Container(
//                  height: 100,
//                  decoration: BoxDecoration(
//                    color: Color(0xFF1B1B1E),
//                    borderRadius: BorderRadius.all(Radius.circular(10)),
//                    boxShadow: [
//                      BoxShadow(
//                        color: Color(0xFFFBFFFE).withOpacity(0.1),
//                        spreadRadius: 2,
//                        blurRadius: 10,
//                        offset: Offset(0, 0), // changes position of shadow
//                      ),
//                    ],
//                  ),
//                  alignment: Alignment.center,
//                  child: Text(
//                    'Chemistry',
//                    style: GoogleFonts.quicksand(
//                      fontWeight: FontWeight.w500,
//                      fontSize: 40,
//                      color: Color(0xFFC5891E),
////
//                    ),
//                  ),
//                ),
//              ),
//            ),
//            widget.section != 'NEET' &&
//                    widget.section != 'PUC I Board' &&
//                    widget.section != 'PUC II Board'
//                ? Padding(
//                    padding: const EdgeInsets.symmetric(
//                        horizontal: 15.0, vertical: 15),
//                    child: InkWell(
//                      onTap: () {
//                        Navigator.push(
//                            context,
//                            MaterialPageRoute(
//                              builder: (context) =>
//                                  LearnDays(widget.section, 'Maths'),
//                            ));
//                      },
//                      child: Container(
//                        height: 100,
//                        decoration: BoxDecoration(
//                          color: Color(0xFF1B1B1E),
//                          borderRadius: BorderRadius.all(Radius.circular(10)),
//                          boxShadow: [
//                            BoxShadow(
//                              color: Color(0xFFFBFFFE).withOpacity(0.1),
//                              spreadRadius: 2,
//                              blurRadius: 10,
//                              offset:
//                                  Offset(0, 0), // changes position of shadow
//                            ),
//                          ],
//                        ),
//                        alignment: Alignment.center,
//                        child: Text(
//                          'Mathematics',
//                          style: GoogleFonts.quicksand(
//                            fontWeight: FontWeight.w500,
//                            fontSize: 40,
//                            color: Color(0xFFC5891E),
////
//                          ),
//                        ),
//                      ),
//                    ),
//                  )
//                : Container(),
//            widget.section != 'JEE'
//                ? Padding(
//                    padding: const EdgeInsets.symmetric(
//                        horizontal: 15.0, vertical: 15),
//                    child: InkWell(
//                      onTap: () {
//                        Navigator.push(
//                            context,
//                            MaterialPageRoute(
//                              builder: (context) =>
//                                  LearnDays(widget.section, 'Physics'),
//                            ));
//                      },
//                      child: Container(
//                        height: 100,
//                        decoration: BoxDecoration(
//                          color: Color(0xFF1B1B1E),
//                          borderRadius: BorderRadius.all(Radius.circular(10)),
//                          boxShadow: [
//                            BoxShadow(
//                              color: Color(0xFFFBFFFE).withOpacity(0.1),
//                              spreadRadius: 2,
//                              blurRadius: 10,
//                              offset:
//                                  Offset(0, 0), // changes position of shadow
//                            ),
//                          ],
//                        ),
//                        alignment: Alignment.center,
//                        child: Text(
//                          'Biology',
//                          style: GoogleFonts.quicksand(
//                            fontWeight: FontWeight.w500,
//                            fontSize: 40,
//                            color: Color(0xFFC5891E),
////
//                          ),
//                        ),
//                      ),
//                    ),
//                  )
//                : Container(),
//          ],
//        ),
      ),
    );
  }
}
