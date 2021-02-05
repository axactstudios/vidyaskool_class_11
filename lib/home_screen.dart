import 'dart:convert';
import 'dart:io';
import 'dart:io' as io;
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_appavailability/flutter_appavailability.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider_ex/path_provider_ex.dart';
import 'package:permissions_plugin/permissions_plugin.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vidyaskool_class_11/Classes/demo.dart';
import 'package:vidyaskool_class_11/lab_sections.dart';
import 'package:vidyaskool_class_11/learn_sections.dart';
import 'package:vidyaskool_class_11/live.dart';
import 'package:vidyaskool_class_11/search.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void request() async {
    Map<Permission, PermissionState> permission =
    await PermissionsPlugin.requestPermissions([
      Permission.WRITE_EXTERNAL_STORAGE,
      Permission.READ_EXTERNAL_STORAGE
    ]);
    print(permission);
    getFiles();
  }

  @override
  void initState() {
    checkLicense();

    // writeFile();
  }

  String deviceUid;
  void checkLicense() async {
    print('----${DateTime.now().year}');
    await request();
    await initPlatformState();

    String path = await _storageInfo[1].appFilesDir;
    var d=DateTime.now();
    print(d);
    print('---');


    var check=DateTime.parse('2021-07-30');
    var check2=DateTime.parse('2021-08-09');
    var check3=DateTime.parse('2021-01-09');
    print('****');
    print(check2.compareTo(check));
    print('&&&&&');
    print(check3.compareTo(check));

    print(d.compareTo(check));
//    print(('09-08-2021').compareTo('30-07-2021'));
//    print('-----------');
//    print(('09-01-2021').compareTo('30-07-2021'));
    var date=(d.month<10&&d.day<10)?'0${d.day}-0${d.month}-${d.year}':'${d.day}-0${d.month}-${d.year}';
    if(DateTime.now().month>6&&DateTime.now().year>=2022){
      print('Reached');
      var delfile= await File('$path/Data.txt');
      await delfile.delete();
      print('Done');
      var delfol=Directory('$path/data');
      await delfol.delete(recursive:true);
      print('Done');
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => WillPopScope(
            onWillPop: () async => false,
            child: new Dialog(
              child: new Container(
                alignment: FractionalOffset.center,
                height: 80.0,
                padding: const EdgeInsets.all(20.0),
                child: new Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // new CircularProgressIndicator(),
                    new Padding(
                      padding: new EdgeInsets.only(left: 10.0),
                      child: new Text("Your subscription has ended"),
                    ),
                  ],
                ),
              ),
            ),
          ));

    }
    else{
      print(date);
      await _getId();
      await getFiles();
      print(await io.File('$path/video.txt').exists());
      var result = await io.File('$path/video.txt').exists();
      if (result) {
        File file = new File('$path/video.txt');
        String str = await file.readAsString();
        if (str == deviceUid) {
        } else {
          print('Invalid ID');
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (_) => WillPopScope(
                onWillPop: () async => false,
                child: new Dialog(
                  child: new Container(
                    alignment: FractionalOffset.center,
                    height: 80.0,
                    padding: const EdgeInsets.all(20.0),
                    child: new Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // new CircularProgressIndicator(),
                        new Padding(
                          padding: new EdgeInsets.only(left: 10.0),
                          child: new Text("Device not registered"),
                        ),
                      ],
                    ),
                  ),
                ),
              ));
        }
      } else {
        writeFile();
      }
    }

  }

  Future<String> _getId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
    deviceUid = androidDeviceInfo.androidId; // unique ID on Android

    setState(() {
      print('Device uid found');
    });
  }

  void writeFile() async {
    String path = await _storageInfo[1].appFilesDir;
    File file = new File('$path/video.txt');
    print(file);
    await file.writeAsString(deviceUid);
    var str = await file.readAsString();
    print(str);
    print('Called');
  }

  List<Map<String, String>> installedApps;
  Future<void> getApps() async {
    List<Map<String, String>> _installedApps;

    if (Platform.isAndroid) {
      _installedApps = await AppAvailability.getInstalledApps();

      print(
          await AppAvailability.checkAvailability("com.toppertest.pocketguru"));
      // Returns: Map<String, String>{app_name: Chrome, package_name: com.android.chrome, versionCode: null, version_name: 55.0.2883.91}

      print(await AppAvailability.isAppEnabled("com.toppertest.pocketguru"));
      // Returns: true

    }

    setState(() {
      installedApps = _installedApps;
    });
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
      print('--------------------------${_storageInfo[1].appFilesDir}');
    });
  }

  var files;
  Future<File> getFiles() async {
    var root = _storageInfo[1].appFilesDir;
    print(root);
    var file = File('$root/Data.txt');
    files = file;
    print(file);
    readData();
  }

  void logLongString(String s) {
    if (s == null || s.length <= 0) return;
    const int n = 1000;
    int startIndex = 0;
    int endIndex = n;
    while (startIndex < s.length) {
      if (endIndex > s.length) endIndex = s.length;
      print(s.substring(startIndex, endIndex));
      startIndex += n;
      endIndex = startIndex + n;
    }
  }

  List<demo> alllists = [];
  Future<String> readData() async {
    try {
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
      var file = await files;
      String body = await file.readAsString();
      logLongString(body);
      print(body);
      var data = jsonDecode(body);
      for (var u in data["Mapping Pu2-KCET"]) {
        demo Demo = demo(u["Type"], u["Course"], u["Subject"], u["Day"],
            u["Topics"], u["Videos"]);
        alllists.add(Demo);
      }

      print(alllists.length);
    } catch (e) {
      print("----------------------");

      print(e.toString());
    }
  }

  List<demo> filteredlist = [];
  void getlist(String s) {
    setState(() {
      filteredlist = alllists
          .where((d) => d.type.toLowerCase().contains(s.toLowerCase()))
          .toList();
    });
    print(filteredlist.length);
  }

  _launchURL() async {
    const url =
        'http://toppertestplatform.ap-south-1.elasticbeanstalk.com/login';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
//    if (installedApps == null) getApps();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFBFFFE),
        centerTitle: true,
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
//              Align(alignment:Alignment.topLeft,child: InkWell( onTap:(){Navigator.pushReplacement(context,MaterialPageRoute(builder:(context)=>LoginScreen()));}, child: Icon(Icons.arrow_back_ios,color:Colors.black))),
//                 SizedBox(width:MediaQuery.of(context).size.height*0.1),
              Align(
                alignment:Alignment.center,
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
            ],
          ),

        ),

      ),
      backgroundColor: Color(0xFF1B1B1E),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 15),
                        child: InkWell(
                          onTap: () {
//                            checkLicense();
                            getlist('Learn');
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      LearnSections(filteredlist),
                                ));
                          },
                          child: Container(
                            height: double.infinity,
                            decoration: BoxDecoration(
                              color: Color(0xFF1B1B1E),
                              borderRadius:
                              BorderRadius.all(Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFFFBFFFE).withOpacity(0.1),
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  offset: Offset(
                                      0, 0), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(30.0),
                                    child: Image.asset(
                                      'assets/learn.png',
                                    ),
                                  ),
                                  flex: 2,
                                ),
                                Expanded(
                                  child: Text(
                                    'Learn',
                                    style: GoogleFonts.quicksand(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 40,
                                      color: Color(0xFFC5891E),
//
                                    ),
                                  ),
                                  flex: 1,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 15),
                        child: InkWell(
                          onTap: () {
                            Scaffold.of(context).hideCurrentSnackBar();
                            print(
                                installedApps[9]['com.toppertest.pocketguru']);
                            AppAvailability.launchApp(
                                'com.toppertest.pocketguru')
                                .then((_) {
                              print("App toppertest.pocketguru launched!");
                            }).catchError((err) {
                              Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      "App toppertest.pocketguru not found!")));
                              print(err);
                            });
                          },
                          child: Container(
                            height: double.infinity,
                            decoration: BoxDecoration(
                              color: Color(0xFF1B1B1E),
                              borderRadius:
                              BorderRadius.all(Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFFFBFFFE).withOpacity(0.1),
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  offset: Offset(
                                      0, 0), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(30.0),
                                    child: Image.asset(
                                      'assets/exam.png',
                                    ),
                                  ),
                                  flex: 2,
                                ),
                                Expanded(
                                  child: Text(
                                    'Exams',
                                    style: GoogleFonts.quicksand(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 40,
                                      color: Color(0xFFC5891E),
//
                                    ),
                                  ),
                                  flex: 1,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 15),
                        child: InkWell(
                          onTap: () {
                            getlist('Lab');
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      LabSections(filteredlist),
                                ));
                          },
                          child: Container(
                            height: double.infinity,
                            decoration: BoxDecoration(
                              color: Color(0xFF1B1B1E),
                              borderRadius:
                              BorderRadius.all(Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFFFBFFFE).withOpacity(0.1),
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  offset: Offset(
                                      0, 0), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(30.0),
                                    child: Image.asset(
                                      'assets/lab.png',
                                    ),
                                  ),
                                  flex: 2,
                                ),
                                Expanded(
                                  child: Text(
                                    'Lab',
                                    style: GoogleFonts.quicksand(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 40,
                                      color: Color(0xFFC5891E),
//
                                    ),
                                  ),
                                  flex: 1,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 15),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => search()));
                          },
                          child: Container(
                            height: double.infinity,
                            decoration: BoxDecoration(
                              color: Color(0xFF1B1B1E),
                              borderRadius:
                              BorderRadius.all(Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFFFBFFFE).withOpacity(0.1),
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  offset: Offset(
                                      0, 0), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(30.0),
                                    child: Image.asset(
                                      'assets/search.png',
                                    ),
                                  ),
                                  flex: 2,
                                ),
                                Expanded(
                                  child: Text(
                                    'Search',
                                    style: GoogleFonts.quicksand(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 40,
                                      color: Color(0xFFC5891E),
//
                                    ),
                                  ),
                                  flex: 1,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 15),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => live()));
                          },
                          child: Container(
                            height: double.infinity,
                            decoration: BoxDecoration(
                              color: Color(0xFF1B1B1E),
                              borderRadius:
                              BorderRadius.all(Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFFFBFFFE).withOpacity(0.1),
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  offset: Offset(
                                      0, 0), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(30.0),
                                    child: Image.asset(
                                      'assets/video.png',
                                    ),
                                  ),
                                  flex: 2,
                                ),
                                Expanded(
                                  child: Text(
                                    'Live',
                                    style: GoogleFonts.quicksand(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 40,
                                      color: Color(0xFFC5891E),
//
                                    ),
                                  ),
                                  flex: 1,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 15),
                        child: Container(
                          height: double.infinity,
                          decoration: BoxDecoration(
                            color: Color(0xFF1B1B1E),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFFFBFFFE).withOpacity(0.1),
                                spreadRadius: 2,
                                blurRadius: 10,
                                offset:
                                Offset(0, 0), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(30.0),
                                  child: Image.asset(
                                    'assets/info.png',
                                  ),
                                ),
                                flex: 2,
                              ),
                              Expanded(
                                child: Text(
                                  'About',
                                  style: GoogleFonts.quicksand(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 40,
                                    color: Color(0xFFC5891E),
//
                                  ),
                                ),
                                flex: 1,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}