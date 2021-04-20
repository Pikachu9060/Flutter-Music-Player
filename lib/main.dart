import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/Model/Music.dart';
import 'package:flutter_app/Screens/HomePage.dart';
import 'package:flutter_app/Screens/MusicScreen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Music(),
          child: HomePage(),
        ),
        ChangeNotifierProvider(
          create: (context) => Music(),
          child: MusicScreen(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomePage(),
      ),
    );
  }
}
