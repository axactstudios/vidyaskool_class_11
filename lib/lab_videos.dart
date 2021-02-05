import 'dart:convert';
import 'dart:io';

import 'package:file_encrypter/file_encrypter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider_ex/path_provider_ex.dart';
import 'package:permissions_plugin/permissions_plugin.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:vidyaskool_class_11/Classes/demo.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vidyaskool_class_11/Classes/password.dart';
import 'package:vidyaskool_class_11/pdf_view.dart';
import 'package:vidyaskool_class_11/video_player.dart';
class LabVideos extends StatefulWidget {
  String section,experiment;List<demo>filteredlist=[];
  LabVideos(this.section,this.experiment,this.filteredlist);
  @override
  _LabVideosState createState() => _LabVideosState();
}

class _LabVideosState extends State<LabVideos> {
  ProgressDialog pr;

  String dest, decrypt;

  void folder() async {
    Directory extDir = await getExternalStorageDirectory();
    // new Directory('/storage/emulated/0/EncryptedFiles')
    //     .create(recursive: true)
    //     .then((Directory dir) {
    //   print("My directory path ${dir.path}");
    //   dest = dir.path;
    //   setState(() {
    //     print('----------------${dir.path} is the destination---------------');
    //   });
    // });
    new Directory(
        '/storage/emulated/0/Android/data/com.axactstudios.coachingapp/files/DecryptedFiles')
        .create(recursive: true)
        .then((Directory dir) {
      print("My directory path ${dir.path}");
      decrypt = dir.path;
      setState(() {
        print('----------------${dir.path} is the destination---------------');
      });
    });
  }

  void request() async {
    Map<Permission, PermissionState> permission =
    await PermissionsPlugin.requestPermissions([
      Permission.WRITE_EXTERNAL_STORAGE,
      Permission.READ_EXTERNAL_STORAGE
    ]);
  }

  TextEditingController pwController = new TextEditingController(text: '');
  TextEditingController decryptController = new TextEditingController(text: '');

  @override
  void initState() {
    folder();
    request();
    initPlatformState();
    getpasswords();
    getvideos();
  }

  String secretkey = '';

  void decryptFile(BuildContext context, String sdCard, String internal,
      String key, String fileName) async {
    print(key);
    print(fileName);
    // File file = await FilePicker.getFile();
    // String fileName = basename(file.path);
    File fl = File('$sdCard/Content/$fileName');
    final ProgressDialog pr = await ProgressDialog(context);
    pr.style(
        message:(fileName.contains(".pdf"))? 'Pdf will be displayed shortly, please wait..':'Video will be shortly played,please wait..',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: GFLoader(
          type: GFLoaderType.ios,
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));

    await pr.show();
    await FileEncrypter.decrypt(
        key: key,
        inFilename: fl.path,
        outFileName: '$internal/DecryptedFiles/Test.m4v');

    String videoPath = '$internal/DecryptedFiles/Test.m4v';
    await pr.hide();
    if(!fileName.contains(".pdf")){
      getFiles(fileName);
    }
    if(fileName.contains(".pdf")){
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PdfView(
              videoPath
          ),
        ),
      );
    }
    else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              VideoPlayer(
                  videoPath
              ),
        ),
      );
    }
    // Alert(
    //   context: context,
    //   type: AlertType.success,
    //   title: "Decryption Successful!",
    //   desc:
    //       "The file was decrypted successfully.\nPress the button below to play the video.",
    //   buttons: [
    //     DialogButton(
    //       child: Text(
    //         "PLAY VIDEO",
    //         style: TextStyle(color: Colors.white, fontSize: 20),
    //       ),
    //       onPressed: () {
    //
    //       },
    //       color: Color.fromRGBO(0, 179, 134, 1.0),
    //     ),
    //   ],
    // ).show();
  }

  List<StorageInfo> _storageInfo = [];
  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    List<StorageInfo> storageInfo;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      storageInfo = await PathProviderEx.getStorageInfo();
    } on PlatformException {}

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _storageInfo = storageInfo;
      print('--------------------------${_storageInfo[1].rootDir}');
    });
  }
  List<dynamic> allpasswords2=[];List<passwords> allpasswords=[];
  Future<String> getpasswords() async {
    try {
      var data = await DefaultAssetBundle.of(context)
          .loadString("assets/password.json");
      // logLongString(data);
      var body = jsonDecode(data);
      // logLongString(body['Passwords'].toString());
      Map map = body["Passwords"];
      // logLongString(map.toString());
      map.forEach((k, v) {
        allpasswords.add(passwords(v['Name'], v['Password']));
        print(allpasswords.length);
        // print(map2);
      });
    } catch (e) {
      print("--------------------------");
      print(e.toString());
    }
  }
  var files;var file2;
  Future<File> getFiles(String video)async{

    var root =  _storageInfo[1].rootDir;
    print(root);
    var  file=File('$root/Android/data/Data.txt');
    file2=File('$root/Android/data/Data2.txt');
    files=file;
    print(file);
    print(file2);
    readData(video);
  }
  List<demo> alllists=[];var file;
  Future<String> readData(String video) async{
    try{

//      var file =await files;
//      print(file);
//      var bytes = File.fromUri(Uri.parse(file)).readAsBytesSync();
//      print(bytes);
//      var decoder = SpreadsheetDecoder.decodeBytes(bytes);
//      var table = decoder.tables['Sheet1'];
//      var values = table.rows[0];
//      print(values);
//      var fileContent = file.readAsBytesSync();
//      var fileContentBase64 = base64.decode(fileContent);
//      print(fileContentBase64);
      file =await files;
      String body =await file.readAsString();
//      logLongString(body);
      print(body);
      var data = jsonDecode(body);
      for(var u in data["New mapping"]){
        if(u["Videos"]==video&&u["Course"]==widget.section){
          Map <String,dynamic>map={
            "Type":u["Type"],
            "Course":u["Course"],
            "Day":u["Day"],
            "Topics":u["Topics"],
            "Videos":u["Videos"],
            "videoWatched":"true",
            "examTaken":u["examTaken"]

          };
          var data=jsonEncode(map);
          file2.writeAsString(data,mode:FileMode.append);
        }


//        file.writeAsString(data,mode:FileMode.append);
        demo Demo =demo(u["Type"],u["Course"],u["Subject"],u["Day"],u["Topics"],u["Videos"]);

        alllists.add(Demo);


      }


      print(alllists.length);
    } catch(e){
      print("----------------------");

      print(e.toString());
    }
  }
  void compare(String videoname) {
    print(videoname);
    for (int i = 0; i < allpasswords.length; i++) {

      if (allpasswords[i].name + ".aes" == videoname) {
        print(allpasswords[i].name);
        print(videoname);
        print(allpasswords[i].name);
        print(allpasswords[i].password);
        decryptFile(
          this.context,
          _storageInfo[1].rootDir,
          _storageInfo[0].appFilesDir,
          allpasswords[i].password,
          allpasswords[i].name+".aes",
        );
      }
    }
  }
  List<videos> allvideos=[];
  void getvideos(){
    print(widget.filteredlist.length);
    for(var d in widget.filteredlist) {
      if(d.course==widget.section  && d.day==widget.experiment){
        videos video =videos(d.topics,d.videos);
        allvideos.add(video);


      }
    }
    print(allvideos.length);
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
            itemCount:allvideos.length,
            itemBuilder: (context,index){
              var item =allvideos[index];
              return Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
                child: InkWell(
                  onTap: () {
                    folder();
                    print(_storageInfo[0].appFilesDir);
                    var root =  _storageInfo[1].rootDir;
//                  decryptFile(
//                      this.context,
//                      _storageInfo[1].rootDir,
//                      _storageInfo[0].appFilesDir,
//                      null,
//                      "Chemistry Pu2 Exp-2 Ammonium Bromide.mp4" );
                    compare(item.video);
//                  Navigator.push(
//                    context,
//                    MaterialPageRoute(
//                      builder: (context) => VideoPlayer(
//                        '$root/Content/Chemistry Pu2 Exp-2 Ammonium Bromide.mp4' ,
//                      ),
//                    ),
//                  );
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
                      item.topic,
                      style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.w500,
                        fontSize: 40,
                        color: Color(0xFFC5891E),
                      ),
                      textAlign: TextAlign.center,
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
//                  folder();
//                  print(_storageInfo[0].appFilesDir);
//                  decryptFile(
//                      this.context,
//                      _storageInfo[1].rootDir,
//                      _storageInfo[0].appFilesDir,
//                      "+s5kk+DXUPQH6VUFFMk/yQ==\n",
//                      'Physics Pu2 Exp-16 Semiconductor L2.m4v.aes');
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
//                    'Physics Pu2 Exp-16 Semiconductor L2 - Explanation',
//                    style: GoogleFonts.quicksand(
//                      fontWeight: FontWeight.w500,
//                      fontSize: 40,
//                      color: Color(0xFFC5891E),
//                    ),
//                    textAlign: TextAlign.center,
//                  ),
//                ),
//              ),
//            ),
//            Padding(
//              padding:
//                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
//              child: InkWell(
//                onTap: () {
//                  folder();
//                  print(_storageInfo[0].appFilesDir);
//                  decryptFile(
//                      this.context,
//                      _storageInfo[1].rootDir,
//                      _storageInfo[0].appFilesDir,
//                      "BpFwRVeu/hibEkt1XpP5kQ==\n",
//                      'Physics Pu2 Exp-16 Semiconductor L3.m4v.aes');
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
//                    'Physics Pu2 Exp-16 Semiconductor L3 - Experiment',
//                    style: GoogleFonts.quicksand(
//                      fontWeight: FontWeight.w500,
//                      fontSize: 40,
//                      color: Color(0xFFC5891E),
////
//                    ),
//                    textAlign: TextAlign.center,
//                  ),
//                ),
//              ),
//            ),
//            Padding(
//              padding:
//                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
//              child: InkWell(
//                onTap: () {
//                  folder();
//                  print(_storageInfo[0].appFilesDir);
//                  decryptFile(
//                      this.context,
//                      _storageInfo[1].rootDir,
//                      _storageInfo[0].appFilesDir,
//                      "kXEhccdWOQPHSRy4RFUybA==\n",
//                      'Chemistry Pu1 Exp-1 Acid-Base Titration L1.m4v.aes');
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
//                    'Chemistry Pu1 Exp-1 Acid-Base Titration L1 - Explanation',
//                    style: GoogleFonts.quicksand(
//                      fontWeight: FontWeight.w500,
//                      fontSize: 40,
//                      color: Color(0xFFC5891E),
//                    ),
//                    textAlign: TextAlign.center,
//                  ),
//                ),
//              ),
//            ),
//            Padding(
//              padding:
//                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
//              child: InkWell(
//                onTap: () {
//                  folder();
//                  print(_storageInfo[0].appFilesDir);
//                  decryptFile(
//                      this.context,
//                      _storageInfo[1].rootDir,
//                      _storageInfo[0].appFilesDir,
//                      "GuKRfLThJvsvcmnyCZ4lzQ==\n",
//                      'Chemistry Pu1 Exp-1 Acid-Base Titration L2.m4v.aes');
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
//                    'Chemistry Pu1 Exp-1 Acid-Base Titration L2 - Explanation',
//                    style: GoogleFonts.quicksand(
//                      fontWeight: FontWeight.w500,
//                      fontSize: 40,
//                      color: Color(0xFFC5891E),
//                    ),
//                    textAlign: TextAlign.center,
//                  ),
//                ),
//              ),
//            ),
//            Padding(
//              padding:
//                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
//              child: InkWell(
//                onTap: () {
//                  folder();
//                  print(_storageInfo[0].appFilesDir);
//                  decryptFile(
//                      this.context,
//                      _storageInfo[1].rootDir,
//                      _storageInfo[0].appFilesDir,
//                      "Q7Lk8Phv9ifdonstdM/jBA==\n",
//                      'Chemistry Pu1 Exp-1 Acid-Base Titration L3.m4v.aes');
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
//                    'Chemistry Pu1 Exp-1 Acid-Base Titration L3 - Explanation',
//                    style: GoogleFonts.quicksand(
//                      fontWeight: FontWeight.w500,
//                      fontSize: 40,
//                      color: Color(0xFFC5891E),
//                    ),
//                    textAlign: TextAlign.center,
//                  ),
//                ),
//              ),
//            ),

        ),
      ),
    );
  }
}
class videos {
  final String topic;
  final String video;

  videos(this.topic, this.video);
}