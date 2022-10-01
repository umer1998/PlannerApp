import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../style/colors.dart';
import '../../utils/ApiConstants.dart';
import '../../utils/alertdialogue.dart';
import '../apis/ApiService .dart';
import 'package:http/http.dart' as http;


class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {


  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool otpvisibilty = false;
  String text = "Get OTP";

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
                              "Enter your phone no to get password.",
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
                                  color: Colors.transparent
                              ),
                              child:TextField(

                                controller: nameController,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.email_outlined),
                                  fillColor: AppColors.bgGreen,
                                  focusColor: Colors.grey,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  labelText: 'Email No',
                                  hintText: 'Enter email no',
                                ),
                              ),
                            ),

                            // Container(
                            //   height: 65,
                            //   width: MediaQuery.of(context).size.width,
                            //   decoration: BoxDecoration(
                            //     color: Colors.white.withOpacity(0.5),
                            //     border: Border.all(color: Colors.white),
                            //     borderRadius: new BorderRadius.only(
                            //         topLeft: const Radius.circular(10.0),
                            //         bottomLeft: const Radius.circular(10.0),
                            //         topRight: const Radius.circular(10.0),
                            //         bottomRight: const Radius.circular(10.0)),
                            //     boxShadow: [
                            //       BoxShadow(
                            //         offset: Offset(0, 0),
                            //         blurRadius: 2,
                            //         spreadRadius: 2,
                            //         color: Color(0x79cdcdd0),
                            //       ),
                            //     ],
                            //   ),
                            //   child: Padding(
                            //     padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                            //     child: Column(
                            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //       crossAxisAlignment: CrossAxisAlignment.start,
                            //       children: [
                            //         Text(
                            //           "Email",
                            //           textAlign: TextAlign.center,
                            //           style: TextStyle(
                            //               fontWeight: FontWeight.w500,
                            //               color: Colors.grey,
                            //               fontSize: 17),
                            //         ),
                            //         Stack(
                            //           children: [
                            //             Icon(Icons.email_outlined , size: 17, color: Colors.black,),
                            //             Padding(
                            //               padding: const EdgeInsets.fromLTRB(23, 1, 0, 0),
                            //               child: TextField(
                            //                 controller: nameController,
                            //                 decoration: new InputDecoration.collapsed(
                            //                   hintText: 'Username',
                            //                 ),
                            //                 style: TextStyle(
                            //                   fontWeight: FontWeight.w500
                            //                 ),
                            //               ),
                            //             ),
                            //           ],
                            //         )
                            //
                            //       ],
                            //     ),
                            //   ),
                            // ),

                            SizedBox(height: 20,),

                            Visibility(
                              visible: otpvisibilty,
                              child: Container(
                                height: 65,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    color: Colors.transparent
                                ),
                                child:TextField(
                                  controller: passwordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.lock),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    fillColor: AppColors.bgGreen,
                                    focusColor: Colors.grey,
                                    labelText: 'OTP',
                                    hintText: 'Enter otp',
                                  ),
                                ),
                              ),
                            ),

                            // Container(
                            //   height: 65,
                            //   width: MediaQuery.of(context).size.width,
                            //   decoration: BoxDecoration(
                            //     color: Colors.white.withOpacity(0.5),
                            //     border: Border.all(color: Colors.white),
                            //     borderRadius: new BorderRadius.only(
                            //         topLeft: const Radius.circular(10.0),
                            //         bottomLeft: const Radius.circular(10.0),
                            //         topRight: const Radius.circular(10.0),
                            //         bottomRight: const Radius.circular(10.0)),
                            //     boxShadow: [
                            //       BoxShadow(
                            //         offset: Offset(0, 0),
                            //         blurRadius: 2,
                            //         spreadRadius: 2,
                            //         color: Color(0x79cdcdd0),
                            //       ),
                            //     ],
                            //   ),
                            //   child: Padding(
                            //     padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                            //     child: Column(
                            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //       crossAxisAlignment: CrossAxisAlignment.start,
                            //       children: [
                            //         Text(
                            //           "Password",
                            //           textAlign: TextAlign.center,
                            //           style: TextStyle(
                            //               fontWeight: FontWeight.w500,
                            //               color: Colors.grey,
                            //               fontSize: 17),
                            //         ),
                            //         Stack(
                            //           children: [
                            //             Icon(Icons.lock , size: 17, color: Colors.black,),
                            //             Padding(
                            //               padding: const EdgeInsets.fromLTRB(23, 1, 0, 0),
                            //               child: TextField(
                            //                 controller: passwordController,
                            //                 decoration: new InputDecoration.collapsed(
                            //                   hintText: 'password',
                            //                 ),
                            //                 style: TextStyle(
                            //                     fontWeight: FontWeight.w500
                            //                 ),
                            //               ),
                            //             ),
                            //           ],
                            //         )
                            //       ],
                            //     ),
                            //   ),
                            // ),
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
                                  if(text == "Get OTP"){
                                    performLogin(0);
                                  } else {
                                    performLogin(1);
                                  }

                                },
                                child: Container(
                                  width: 130,
                                  height: 55,
                                  decoration: BoxDecoration(
                                    color: AppColors.greenText,
                                    borderRadius: new BorderRadius.only(
                                        topLeft: const Radius.circular(15.0),
                                        bottomLeft: const Radius.circular(15.0),
                                        topRight: const Radius.circular(15.0),
                                        bottomRight: const Radius.circular(15.0)),

                                  ),
                                  child: Center(
                                    child: Text(
                                      "${text}",
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

                    SizedBox(height: 5,),
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

  void performLogin(int flag){

    if(flag == 0){
      if(nameController.text.isEmpty){
        AlertDialogue().showAlertDialog(context, "Login Failed", "Please enter correct email .");
      }  else {
        Map<String, String> body ={
          'email': nameController.text,
        };
        forgotPassword(body, context);
        // ApiService().login(body, context) ;
      }
    } else {
      if(nameController.text.isEmpty){
        AlertDialogue().showAlertDialog(context, "Login Failed", "Please enter correct email .");
      } else if(passwordController.text.isEmpty || passwordController.text.length < 6){
        AlertDialogue().showAlertDialog(context, "Login Failed", "Please enter correct password .");
      } else {
        Map<String, String> body ={
          'email': nameController.text,
          'password':passwordController.text,
        };
         ApiService().login(body, context) ;
      }
    }

  }



  Future<void> forgotPassword(Map<String, String> body, BuildContext context) async {

    EasyLoading.show(status: 'loading...');
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.forgetPassword);
      var response = await http.post(url, body: body);
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        Responce  responce = responceFromJson(response.body);
        AlertDialogue().showAlertDialog(context, "Alert Dialogue", responce.message!);
        setState(() {
          text = "Login";
          otpvisibilty = true;
        });

      } else {

        AlertDialogue().showAlertDialog(context, "Alert Dialogue", response.body.toString());
      }
    } catch (e) {
      EasyLoading.dismiss();
      String error = e.toString();
      AlertDialogue().showAlertDialog(context, "Alert Dialogue", "$error");

    }
  }

}


Responce responceFromJson(String str) => Responce.fromJson(json.decode(str));

String responceInToJson(Responce user) => json.encode(user.toJson());

class Responce {
  bool? success;
  int? data;
  String? message;

  Responce({this.success, this.data, this.message});

  Responce.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['data'] = this.data;
    data['message'] = this.message;
    return data;
  }
}