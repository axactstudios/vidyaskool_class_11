import 'dart:io';
import 'dart:io' as io;

import 'package:file_encrypter/file_encrypter.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path_provider_ex/path_provider_ex.dart';
import 'package:permissions_plugin/permissions_plugin.dart';
import 'package:progress_dialog/progress_dialog.dart';


class LearnVideos2 extends StatefulWidget {
  String section, subject, day;
  LearnVideos2(this.section, this.subject, this.day);
  @override
  _LearnVideos2State createState() => _LearnVideos2State();
}

class _LearnVideos2State extends State<LearnVideos2> {
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
  }

  String secretkey = '';

  void decryptFile(BuildContext context, String sdCard, String internal,
      String key, String fileName) async {
    // File file = await FilePicker.getFile();
    // String fileName = basename(file.path);
    File fl = File('$sdCard/Content/$fileName');
    await FileEncrypter.decrypt(
        key: key,
        inFilename: fl.path,
        outFileName: '$internal/DecryptedFiles/Test.m4v');

    String videoPath = '$internal/DecryptedFiles/Test.m4v';
//    Navigator.push(
//      context,
//      MaterialPageRoute(
//        builder: (context) => VideoPlayer(
//          videoPath,widget.section
//        ),
//      ),
//    );
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
        child: ListView(
          children: <Widget>[
            Container(
              height: 20,
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
              child: InkWell(
                onTap: () {
                  folder();
                  print(_storageInfo[0].appFilesDir);
                  decryptFile(
                      this.context,
                      _storageInfo[1].rootDir,
                      _storageInfo[0].appFilesDir,
                      "a9tyM1KOm9PBsETIii3BRw==\n",
                      'Physics Ec & F L7.m4v.aes');
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
                    'Physics Electrostatics',
                    style: GoogleFonts.quicksand(
                      fontWeight: FontWeight.w500,
                      fontSize: 40,
                      color: Color(0xFFC5891E),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
              child: InkWell(
                onTap: () {
                  folder();
                  print(_storageInfo[0].appFilesDir);
                  decryptFile(
                      this.context,
                      _storageInfo[1].rootDir,
                      _storageInfo[0].appFilesDir,
                      "FfJfSo5D/hfPt84IIylO4A==\n",
                      'Chemistry Gp&Pie L2.m4v.aes');
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
                    'Chemistry General Principles & Process of Isolation of Elements',
                    style: GoogleFonts.quicksand(
                      fontWeight: FontWeight.w500,
                      fontSize: 40,
                      color: Color(0xFFC5891E),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
              child: InkWell(
                onTap: () {
                  folder();
                  print(_storageInfo[0].appFilesDir);
                  decryptFile(
                      this.context,
                      _storageInfo[1].rootDir,
                      _storageInfo[0].appFilesDir,
                      "79fZ5BYa5H5LKXqxe7It5A==\n",
                      'Maths Vector Algebra - L7.m4v.aes');
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
                    'Maths Vector Algebra',
                    style: GoogleFonts.quicksand(
                      fontWeight: FontWeight.w500,
                      fontSize: 40,
                      color: Color(0xFFC5891E),
//
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
              child: InkWell(
                onTap: () {
                  folder();
                  print(_storageInfo[0].appFilesDir);
                  decryptFile(
                      this.context,
                      _storageInfo[1].rootDir,
                      _storageInfo[0].appFilesDir,
                      "g3sHb/0yKJh2fXgov7dPCQ==\n",
                      'Biology Human Reproduction L4.m4v.aes');
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
                    'Biology Human Reproduction',
                    style: GoogleFonts.quicksand(
                      fontWeight: FontWeight.w500,
                      fontSize: 40,
                      color: Color(0xFFC5891E),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
              child: InkWell(
                onTap: () {
                  folder();
                  print(_storageInfo[0].appFilesDir);
                  decryptFile(
                      this.context,
                      _storageInfo[1].rootDir,
                      _storageInfo[0].appFilesDir,
                      "a9tyM1KOm9PBsETIii3BRw==\n",
                      'Physics Ec & F L7.m4v.aes');
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
                    'Physics Electrostatics',
                    style: GoogleFonts.quicksand(
                      fontWeight: FontWeight.w500,
                      fontSize: 40,
                      color: Color(0xFFC5891E),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
              child: InkWell(
                onTap: () {
                  folder();
                  print(_storageInfo[0].appFilesDir);
                  decryptFile(
                      this.context,
                      _storageInfo[1].rootDir,
                      _storageInfo[0].appFilesDir,
                      "FfJfSo5D/hfPt84IIylO4A==\n",
                      'Chemistry Gp&Pie L2.m4v.aes');
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
                    'Chemistry General Principles & Process of Isolation of Elements',
                    style: GoogleFonts.quicksand(
                      fontWeight: FontWeight.w500,
                      fontSize: 40,
                      color: Color(0xFFC5891E),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
