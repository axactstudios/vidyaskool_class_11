import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vidyaskool_class_11/Classes/demo.dart';
import 'package:vidyaskool_class_11/lab_experiments.dart';

class LabSections extends StatefulWidget {
  List<demo> filteredlist=[];
  LabSections(this.filteredlist);
  @override
  _LabSectionsState createState() => _LabSectionsState();
}

class _LabSectionsState extends State<LabSections> {
  List<String> allcourses=[];
  void getcourse(){
    print(widget.filteredlist.length);
    for(var d in widget.filteredlist){
      if(!allcourses.contains(d.course)){
        allcourses.add(d.course);
      }
    }

    print(allcourses.length);
  }
  @override
  void initState() {
    getcourse();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
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
        child: ListView.builder(
            itemCount:allcourses.length,
            itemBuilder: (context,index){
              var item =allcourses[index];
              return
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LabExperiments(item,widget.filteredlist),
                          ));
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
//
                        ),
                      ),
                    ),
                  ),
                );
            }

//            Padding(
//              padding:
//                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
//              child: InkWell(
//                onTap: () {
//                  Navigator.push(
//                      context,
//                      MaterialPageRoute(
//                        builder: (context) => LabSubjects(),
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
//                    'PUC II Board',
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

        ),
      ),
    );
  }
}
