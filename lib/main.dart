import 'package:flutter/material.dart';
import 'package:plannerapp/src/initialscrrens/HomeScreen.dart';
import 'package:plannerapp/src/leaves/LeavesScreen.dart';
import 'package:plannerapp/src/screens/ApprovalList.dart';
import 'package:plannerapp/src/screens/ExecutionList.dart';
import 'package:plannerapp/src/screens/FromScreen.dart';
import 'package:plannerapp/src/screens/SplashScreen.dart';

import 'package:plannerapp/utils/Prefrences.dart';


void main()  {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: Colors.white,
      ),
      home: Home(),
    );
  }
}


class Home extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SplashScreen()
        ],
      ),

    );
  }

}


