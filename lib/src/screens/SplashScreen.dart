
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

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin{
  late final SharedPreferences prefs;
  bool isLogin = false;



  late AnimationController _controller;
  late Animation<double> _animation;


  @override
  void initState()  {
    getPrefrences();
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..forward();
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn)..addStatusListener((status) {
      if(status == AnimationStatus.completed){
        if(isLogin == true){
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }

      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: FadeTransition(
            opacity: _animation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/img/logo.png" , width: 130, height: 150,),
              ],
            ),
          ),
        ),
      ),
    );
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
