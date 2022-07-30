import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:plannerapp/src/models/Login_Responce.dart';
import 'package:plannerapp/utils/alertdialogue.dart';

import '../../style/colors.dart';
import '../apis/ApiService .dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Future<String?> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    }
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    String value = _getId().toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/img/bg.jpg'), fit: BoxFit.fill),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Image.asset('assets/img/loginIcon.png'
                        ,width: 160,height: 180,
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Sign In",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.black,
                                  fontSize: 28),
                            ),
                            SizedBox(height: 5,),
                            Text(
                              "Please Sign in to Continue",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                  fontSize: 17),
                            ),

                            SizedBox(
                              height: 30,
                            ),

                            Container(
                              height: 65,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.5),
                                border: Border.all(color: Colors.white),
                                borderRadius: new BorderRadius.only(
                                    topLeft: const Radius.circular(10.0),
                                    bottomLeft: const Radius.circular(10.0),
                                    topRight: const Radius.circular(10.0),
                                    bottomRight: const Radius.circular(10.0)),
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(0, 0),
                                    blurRadius: 2,
                                    spreadRadius: 2,
                                    color: Color(0x79cdcdd0),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Email",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey,
                                          fontSize: 17),
                                    ),
                                    Stack(
                                      children: [
                                        Icon(Icons.email_outlined , size: 17, color: Colors.black,),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(23, 1, 0, 0),
                                          child: TextField(
                                            controller: nameController,
                                            decoration: new InputDecoration.collapsed(
                                              hintText: 'Username',
                                            ),
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500
                                            ),
                                          ),
                                        ),
                                      ],
                                    )

                                  ],
                                ),
                              ),
                            ),

                            SizedBox(height: 20,),

                            Container(
                              height: 65,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.5),
                                border: Border.all(color: Colors.white),
                                borderRadius: new BorderRadius.only(
                                    topLeft: const Radius.circular(10.0),
                                    bottomLeft: const Radius.circular(10.0),
                                    topRight: const Radius.circular(10.0),
                                    bottomRight: const Radius.circular(10.0)),
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(0, 0),
                                    blurRadius: 2,
                                    spreadRadius: 2,
                                    color: Color(0x79cdcdd0),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Password",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey,
                                          fontSize: 17),
                                    ),
                                    Stack(
                                      children: [
                                        Icon(Icons.lock , size: 17, color: Colors.black,),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(23, 1, 0, 0),
                                          child: TextField(
                                            controller: passwordController,
                                            decoration: new InputDecoration.collapsed(
                                              hintText: 'password',
                                            ),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.all(15.0),
                            //   child: Row(
                            //     children: [
                            //       Icon(Icons.password),
                            //       Text("Password", style: TextStyle(
                            //         color: Colors.grey,
                            //         fontSize: 15
                            //       ),)
                            //     ],
                            //   ),
                            // ),

                            SizedBox(height: 40,),
                            Center(
                              child: GestureDetector(
                                onTap: (){
                                  performLogin();
                                },
                                child: Container(
                                  width: 130,
                                  height: 55,
                                  decoration: BoxDecoration(
                                    color: AppColors.greenText,
                                    borderRadius: new BorderRadius.only(
                                        topLeft: const Radius.circular(25.0),
                                        bottomLeft: const Radius.circular(25.0),
                                        topRight: const Radius.circular(25.0),
                                        bottomRight: const Radius.circular(25.0)),

                                  ),
                                  child: Center(
                                    child: Text(
                                      "LOGIN",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 20,),
                    Center(
                      child: Text(
                        "Forgot Password?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontSize: 17),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),
        )
    );
  }

  void performLogin(){
    if(nameController.text.isEmpty){
      AlertDialogue().showAlertDialog(context, "Login Failed", "Please enter correct email .");
    } else if(passwordController.text.isEmpty){
      AlertDialogue().showAlertDialog(context, "Login Failed", "Please enter correct password .");
    } else {
      Map<String, String> body ={
        'email': nameController.text,
        'password': passwordController.text
      };
      ApiService().getUsers(body, context) ;
    }
  }

}