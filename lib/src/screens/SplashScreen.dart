
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/Prefrences.dart';
import '../initialscrrens/HomeScreen.dart';
import '../initialscrrens/LoginScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final SharedPreferences prefs;
  bool isLogin = false;

  @override
  void initState()  {
    getPrefrences();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: checkUserLogin()
      ),
    );
  }
  Widget checkUserLogin(){
    if(isLogin == true){
      return HomeScreen();
    } else {
      return LoginScreen();
    }
  }

  void getPrefrences() async {
    try{
      SharedPreferences pref = await SharedPreferences.getInstance();
      setState(() {
        if(pref.getBool(PrefrenceConst.isLogin) != null && pref.getBool(PrefrenceConst.isLogin) == true){
          isLogin = true;
        } else {
          isLogin = false;
        }
      });

    } catch(e){}
  }
}
