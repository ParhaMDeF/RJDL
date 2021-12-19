import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/backend/playlist.dart';
import 'package:untitled2/backend/podcast.dart';
import 'backend/album.dart';
import 'backend/music.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'config.dart';

class Download {
  static void callback(String id, DownloadTaskStatus status, int progress) {}
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Config.permissionStatus = await Permission.storage.request();
  await FlutterDownloader.initialize(debug: false);
  FlutterDownloader.registerCallback(Download.callback);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create:  (BuildContext context) => Music()),
        Provider(create:  (BuildContext context) => Podcast()),
        Provider(create:  (BuildContext context) => Album()),
        Provider(create:  (BuildContext context) => Playlist()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        themeMode: ThemeMode.dark,
        home: MyHomePage(title: 'RJDL'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  var link;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<void> downloadFile(String url, String fileName) async {
    if (Config.permissionStatus == PermissionStatus.granted) {
      String path = '/storage/emulated/0/rjdl';
      bool directoryExist = Directory(path).existsSync();
      if (!directoryExist) {
          Directory(path).create(recursive: true);
      }
      final id = await FlutterDownloader.enqueue(
          url: url,
          savedDir: '/storage/emulated/0/rjdl',
          showNotification: true,
          openFileFromNotification: true,
          fileName: fileName);
    } else {
      print('no permission');
    }
  }

  @override
  Widget build(BuildContext context) {
    var musicData = Provider.of<Album>(context);
    Future<void> _getLink(String link) async {
      await musicData.scrapping(link);
    }

    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(
        title: Center(child: Text(widget.title)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Enter Song Link',
              style: TextStyle(
                  fontSize: 17,
                  color: Colors.white70,
                  fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 35),
              child: TextField(
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: Colors.red.shade400)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: Colors.red.shade400))),
                style: TextStyle(color: Colors.white60, fontSize: 16.5),
                onChanged: (value) {
                  widget.link = value;
                },
              ),
            ),
            MaterialButton(
              minWidth: 150,
              height: 50,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              onPressed: () async {
                await _getLink(widget.link);
                // await downloadFile(
                //     musicData.downloadLink, musicData.fileName + '.mp3');
              },
              color: Colors.red.shade700,
              child: Text(
                'Download',
                style: TextStyle(color: Colors.white, fontSize: 17),
              ),
            )
          ],
        ),
      ),
    );
  }
}
