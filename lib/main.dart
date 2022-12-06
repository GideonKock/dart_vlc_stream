import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:dart_vlc/dart_vlc.dart';

void main() async {
  await DartVLC.initialize(useFlutterNativeView: false);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
// Hier wordt de player aangemaakt
  Player player = Player(id: 1);
  String ipport = '192.168.2.120:55756';
  String username = '';
  String password = '';
  String camid = '19701_196f745a-87e5-4325-ba5b-cda2d12026e7';

  @override
  void initState() {
    super.initState();
    HttpOverrides.global = MyHttpOverrides();

// Zetten van media url, let op in de mail @ = %40

// Overige parameters, quality, audio, cameraId kunnen naar wens worden aangepast

// Voor nu credentials nog in de url, zie vervolgstappen in de mail
    // get(Uri.parse(
    //         'https://promteg%5Cgideon:7071VA!!@127.0.0.1:55756/Acs/Api/ServerConfigurationFacade/GetServerConfiguration'))
    //     .then((value) => print(value.body));
    Media media = Media.network(
      'https://$username:$password@$ipport/Acs/Streaming/Video/Live/mp4/?camera=$camid&quality=high&audio=0',
    );
    player.open(media, autoStart: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Video(
          showControls: false,
          player: player,
          width: 1000,
          height: 1000,
        ),
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
