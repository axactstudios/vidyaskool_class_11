import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:expandable/expandable.dart';
import 'package:file_encrypter/file_encrypter.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider_ex/path_provider_ex.dart';
import 'package:permissions_plugin/permissions_plugin.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:vidyaskool_class_11/Classes/demo.dart';
import 'package:vidyaskool_class_11/Classes/password.dart';
import 'package:vidyaskool_class_11/pdf_view.dart';
import 'package:vidyaskool_class_11/video_player.dart';

class LabExperiments extends StatefulWidget {
  String section;
  List<demo> filteredlist = [];
  LabExperiments(this.section, this.filteredlist);
  @override
  _LabExperimentsState createState() => _LabExperimentsState();
}

class _LabExperimentsState extends State<LabExperiments> {
  ProgressDialog pr;

  String dest, decrypt;List<String>finaldays=[];

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
//      print('--------------------------${_storageInfo[1].rootDir}');
    });
  }

  void folder() async {
    Directory extDir = await getExternalStorageDirectory();
    // new Directory('/storage/emulated/0/EncryptedFiles')
    //     .create(recursive: true)
    //     .then((Directory dir) {
//    //   print("My directory path ${dir.path}");
    //   dest = dir.path;
    //   setState(() {
//    //     print('----------------${dir.path} is the destination---------------');
    //   });
    // });
    new Directory(
        '/storage/emulated/0/Android/data/com.axactstudios.coachingapp/files/DecryptedFiles')
        .create(recursive: true)
        .then((Directory dir) {
//      print("My directory path ${dir.path}");
      decrypt = dir.path;
      setState(() {
//        print('----------------${dir.path} is the destination---------------');
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

  bool color;
  List<Widget> widgets = [];

  List<String> alldays = [];
  List<Expandable> expandable = [];
  List allvideos = [];
  int flag = 0;
  List<videos> allvideos2 = [];
  void getdays() async {
    for (var d in widget.filteredlist) {
      if (d.course == widget.section) {
        {
          if (!alldays.contains(d.day)) {
            alldays.add(d.day);
          }
          setState(() {
            print('------------------');
            alldays.sort((a,b)=>a.compareTo(b));
            print('Sorted');
          });
        }
      }

    }



    for (int i = 0; i < alldays.length; i++) {
      List allvideosTemp = [];
      await allvideosTemp.clear();

      print('--------------');
      for (var d in widget.filteredlist) {
        if (d.course == widget.section && alldays[i] == d.day) {
          videos video = videos(d.topics, d.videos);

          await allvideosTemp.add(video);
        }
      }

      await allvideos.add(allvideosTemp);
      print('added in allvideos ${allvideos[i].length}');
      await print(allvideos.length);

      setState(() {
//        print(widgets.length.toString());
      });
    }
    for (int i = 0; i < allvideos.length; i++) {
      print('=======${allvideos[i].length}');
    }
    await loadWidgets();
  }

  void loadWidgets() async {
    print('Load widgets');
    for (int i = 0; i < alldays.length; i++) {
//      print('Length-${allvideos[i].length}');
      await widgets.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: ExpandablePanel(
            hasIcon: true,
            iconColor: Color(0xFFC5891E),
//          trailing: Icon(Icons.keyboard_arrow_down),
            header: Text(
              widget.section + " " + alldays[i],
              style: GoogleFonts.quicksand(
                fontWeight: FontWeight.w500,
                fontSize: 30,
                color: Color(0xFFC5891E),
              ),
            ),
            expanded: SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                      itemCount: allvideos[i].length,
                      physics:ClampingScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        print(allvideos[i][index].topic +
                            allvideos[i].length.toString() +
                            alldays[i].toString());
                        return InkWell(
                          onTap: () {
                            setState(() {
//                              color = !color;
                            });

                            getFile(allvideos[i][index].video);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                width: MediaQuery.of(context).size.width,
                                color: color
                                    ? Colors.transparent
                                    : Color(0xFFC5891E),
                                child: Text(
                                  '${allvideos[i][index].topic}',
                                  style: GoogleFonts.quicksand(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20,
                                      color: Color(0xFFFBFFFE)),
                                )),
                          ),
                        );
                      })),
            )),
      ));
    }
  }

  List<passwords> allpasswords = [];
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
////        print(allpasswords.length);
//        // print(map2);
      });
    } catch (e) {
//      print("--------------------------");
//      print(e.toString());
    }
  }

  void compare(String videoname) {
//    print(videoname);
    for (int i = 0; i < allpasswords.length; i++) {
      if (allpasswords[i].name + ".aes" == videoname) {
//        print(allpasswords[i].name);
//        print(videoname);
//        print(allpasswords[i].name);
//        print(allpasswords[i].password);
        decryptFile(
          this.context,
          _storageInfo[1].rootDir,
          _storageInfo[0].appFilesDir,
          allpasswords[i].password,
          allpasswords[i].name + ".aes",
        );
      }
    }
  }

  String secretkey = '';

  void decryptFile(BuildContext context, String sdCard, String internal,
      String key, String fileName) async {
    // File file = await FilePicker.getFile();
    // String fileName = basename(file.path);
//    print(key);
    File fl = File('$sdCard/Content/$fileName');

    final ProgressDialog pr = await ProgressDialog(context);
    pr.style(
        message: (fileName.contains(".pdf"))
            ? 'Pdf will be displayed shortly, please wait..'
            : 'Video will be shortly played,please wait..',
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
    if (!fileName.contains(".pdf")) {
      getFiles(fileName);
    }

    if (fileName.contains(".pdf")) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PdfView(videoPath),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VideoPlayer(videoPath),
        ),
      );
    }
  }

  var files;
  var file2;
  Future<File> getFiles(String video) async {
    var root = _storageInfo[1].rootDir;
    var root2=_storageInfo[1].appFilesDir;
//    print(root);
    var file = File('$root2/Data.txt');
    file2 = File('$root/Android/data/Data2.txt');
    files = file;
//    print(file);
//    print(file2);
    readData(video);
  }

  List<demo> alllists = [];
  var file;
  Future<String> readData(String video) async {
    try {
//      var file =await files;
////      print(file);
//      var bytes = File.fromUri(Uri.parse(file)).readAsBytesSync();
////      print(bytes);
//      var decoder = SpreadsheetDecoder.decodeBytes(bytes);
//      var table = decoder.tables['Sheet1'];
//      var values = table.rows[0];
////      print(values);
//      var fileContent = file.readAsBytesSync();
//      var fileContentBase64 = base64.decode(fileContent);
////      print(fileContentBase64);
      file = await files;
      String body = await file.readAsString();
//      logLongString(body);
//      print(body);
      var data = jsonDecode(body);
      for (var u in data["Mapping Pu2-KCET"]) {
        if (u["Videos"] == video && u["Course"] == widget.section) {
          Map<String, dynamic> map = {
            "Type": u["Type"],
            "Course": u["Course"],
            "Day": u["Day"],
            "Topics": u["Topics"],
            "Videos": u["Videos"],

          };
          var data = jsonEncode(map);
          file2.writeAsString(data, mode: FileMode.append);
        }

//        file.writeAsString(data,mode:FileMode.append);
        demo Demo = demo(u["Type"], u["Course"], u["Subject"], u["Day"],
            u["Topics"], u["Videos"]);

        alllists.add(Demo);
      }

//      print(alllists.length);
    } catch (e) {
//      print("----------------------");

//      print(e.toString());
    }
  }
  Future<File> saveMediaAsBytes(String fileName,
      Uint8List fileContent) async {
    String path = await _storageInfo[0].rootDir;
//    print('----------------------${_storageInfo[1].rootDir}');
    Directory dataDir = new Directory(
        '$path/Android/data/com.axactstudios.coachingapp');
    if (await dataDir.exists()) {
      File file = new File(
          '$path/Android/data/com.axactstudios.coachingapp/$fileName');
      return file.writeAsBytes(fileContent);
    }
    await dataDir.create();
    File file = new File(
        '$path/Android/data/com.axactstudios.coachingapp/$fileName');
    return file.writeAsBytes(fileContent);
  }
  var file11;
  void getFile(String filename) async {
    var root = _storageInfo[1].appFilesDir;
//    print(root);
    print(filename);
    file11 = File('$root/data/$filename');
    final ProgressDialog pr = await ProgressDialog(context);
    pr.style(
        message: (filename.contains(".pdf"))
            ? 'Pdf will be displayed shortly, please wait..'
            : 'Video will be shortly played,please wait..',
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

    Uint8List contentSavedFile = await file11.readAsBytes();
    file11 = null;
//for(int i=0;i<10;i++)
//    print('********************************* ');
    for (int i = 0; i < 3; i++) {
      await setState(() {
//     print('*******');
//        reversedfile[i]=contentSavedFile[4-i];

        var temp = contentSavedFile[i];
        contentSavedFile[i] = contentSavedFile[4 - i];
        contentSavedFile[4 - i] = temp;
//     print('Biee $i');
//       print(temp.toString());
//        print(temp);
      });
    }
    print('break');
//    for(int i=5;i<contentSavedFile.length;i++){
////      print('Biee $i');
//      reversedfile[i]=  contentSavedFile[i];
//
//    }

//    print('decoding completed');
//    print(
//        'decoding completed ${DateTime.now().minute}:${DateTime.now().second}');
//var file12= await File.fromRawPath(reversedfile);
//    for (int i = 0; i < 10; i++)
//      print('*********************************  ${contentSavedFile[i]}');

//    await createAudioFile('decodedFile', contentSavedFile).then((value) => print(
//        'writing done completed ${DateTime.now().minute}:${DateTime.now().second}'));

//    print('decoded file created');

    File vf = await saveMediaAsBytes(filename, contentSavedFile);
    await pr.hide();
    print('passing');
    if (!filename.contains(".pdf")) {
      getFiles(filename);
    }

    if (filename.contains(".pdf")) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              PdfView('${_storageInfo[0]
                  .rootDir}/Android/data/com.axactstudios.coachingapp/$filename'),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              VideoPlayer('${_storageInfo[0]
                  .rootDir}/Android/data/com.axactstudios.coachingapp/$filename'),
        ),
      );
    }

  }

  @override
  void initState() {
    color = true;
    flag = 0;
    getdays();
    folder();
    request();
    initPlatformState();
    getpasswords();
    super.initState();
  }

  List<String> allexperiments = [];
  void getexperiments() {
    print(widget.filteredlist.length);
    for (var d in widget.filteredlist) {
      if (d.course == widget.section) {
        if (!allexperiments.contains(d.day)) {
          allexperiments.add(d.day);
        }
      }
    }

    print(allexperiments.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1B1B1E),
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
      body: Column(
        children: <Widget>[
          SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: ListView(
                shrinkWrap: true,
                children: (widgets.length != 0)
                    ? widgets
                    : [CircularProgressIndicator()],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class videos {
  final String topic;
  final String video;
  videos(this.topic, this.video);
}
