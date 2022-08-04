
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:plannerapp/style/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../utils/ApiConstants.dart';
import '../../utils/Prefrences.dart';
import '../../utils/alertdialogue.dart';
import '../initialscrrens/HomeScreen.dart';
import '../models/GetPendingApproval.dart';

class ApproveReject extends StatefulWidget {
  const ApproveReject({Key? key, required this.id, required this.name}) : super(key: key);

  final int id;
  final String name;
  @override
  _ApproveRejectState createState() => _ApproveRejectState();
}

class _ApproveRejectState extends State<ApproveReject> {
  Color selectColor = AppColors.iconGray;
  Color allSelectColor = AppColors.iconGray;
  late GetPendingApproval getPendingApproval;
  bool buttonVisibilty = false;
  bool clickList = false;
  bool selectAll = false;

  List<Color> listColor = [];
  List<bool> listVisibility = [];

  Color bgWhitewithOpacity = Colors.white.withOpacity(0.6);
  Color bgGreenwithOpacity = AppColors.bgGreen.withOpacity(0.2);
  Color finalColor = Colors.white.withOpacity(0.6);

  @override
  void initState() {

    getReportingTeam(context, widget.id);




    super.initState();
  }

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 20, 15, 25),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HomeScreen()),
                              );
                            },
                            child: Icon(
                              Icons.arrow_back_ios_outlined,
                              color: Colors.grey,
                              size: 25.0,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            "${widget.name}",
                            style: TextStyle(
                                fontFamily: "bold",
                                fontSize: 27,
                                color: Colors.black),
                          ),
                        ),
                        Container(
                          height: 20,
                          width: 20,
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 25,
                  width: MediaQuery.of(context).size.width,
                  color: Color(0x759e9e9e),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 3, 15, 3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {

                              // if(selectAll == true){
                              //   for (int i = 0; i < 10; i++) {
                              //     listColor[i] = AppColors.bgGreen.withOpacity(0.2);
                              //     listVisibility[i] = true;
                              //     allSelectColor = AppColors.greenText;
                              //   }
                              // } else {
                              //   for (int i = 0; i < 10; i++) {
                              //     listColor[i] = AppColors.white.withOpacity(0.6);
                              //     listVisibility[i] = false;
                              //     allSelectColor = AppColors.iconGray;
                              //   }
                              // }
                              clickList = true;
                              selectAll = true;
                              buttonVisibilty = true;
                              selectColor = AppColors.iconGray;
                              allSelectColor = AppColors.greenText;
                              for (int i = 0; i < getPendingApproval.data!.length!; i++) {
                                listColor[i] = AppColors.bgGreen.withOpacity(0.2);
                                listVisibility[i] = true;
                              }
                            });
                          },
                          child: Container(
                            height: 25,
                            child: Center(
                              child: Text(
                                "Select All",
                                style: TextStyle(
                                    fontFamily: "semibold",
                                    fontSize: 14,
                                    color: allSelectColor),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              clickList = true;
                              selectAll = false;
                              buttonVisibilty = true;
                              selectColor = AppColors.greenText;
                              allSelectColor = AppColors.iconGray;
                              for (int i = 0; i < getPendingApproval.data!.length!; i++) {
                                listColor[i] = AppColors.white.withOpacity(0.6);
                                listVisibility[i] = false;
                              }
                            });
                          },
                          child: Container(
                            height: 25,
                            child: Center(
                              child: Text(
                                "Select",
                                style: TextStyle(
                                    fontFamily: "semibold",
                                    fontSize: 14,
                                    color: selectColor),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/img/bg.jpg'),
                            fit: BoxFit.fill),
                      ),
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: getPendingApproval.data!.length!,
                        itemBuilder: (context, index) {

                          double bottomMargin = 0;
                          if(index == getPendingApproval.data!.length!){
                            bottomMargin = 100;
                          }

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if(clickList == true){
                                  if(listVisibility[index] == true){
                                    listVisibility[index] = false;
                                  } else {
                                    listVisibility[index] = true;
                                  }
                                  if(listColor[index] == bgWhitewithOpacity){
                                    listColor[index]  = bgGreenwithOpacity;
                                  } else {
                                    listColor[index] = bgWhitewithOpacity;
                                  }
                                }

                              });
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(color: listColor[index]),
                              child: Wrap(
                                children: [
                                  Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(15, 13, 15, bottomMargin),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${getPendingApproval.data![index].event}",
                                                  style: TextStyle(
                                                      fontFamily: "bold",
                                                      fontSize: 20,
                                                      color: Colors.black),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  children: [
                                                    Container(
                                                        height: 15,
                                                        width: 15,
                                                        decoration: BoxDecoration(),
                                                        child: FittedBox(
                                                            child: Icon(
                                                              Icons.calendar_today_outlined,
                                                              color: Colors.grey,
                                                            ),
                                                            fit: BoxFit.fill)),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      "${getPendingApproval.data![index].plannedOn}",
                                                      style: TextStyle(
                                                          fontFamily: "semibold",
                                                          fontSize: 14,
                                                          color: Color(0xff909089)),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  children: [
                                                    Container(
                                                        height: 15,
                                                        width: 15,
                                                        decoration: BoxDecoration(),
                                                        child: FittedBox(
                                                            child: Icon(
                                                              Icons.location_on,
                                                              color: Colors.grey,
                                                            ),
                                                            fit: BoxFit.fill)),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      "${getPendingApproval.data![index].eventPurpose}",
                                                      style: TextStyle(
                                                          fontFamily: "regular",
                                                          fontSize: 14,
                                                          color: Color(0xff909089)),
                                                    ),
                                                  ],
                                                ),
                                              ],

                                            ),
                                            Visibility(
                                              visible: listVisibility[index],
                                              child: Container(
                                                height: 25,
                                                width: 25,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: AssetImage('assets/img/check.png',), fit: BoxFit.fill),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 13,
                                      ),
                                      Container(
                                        height: 1,
                                        width: MediaQuery.of(context).size.width,
                                        color: Color(0xffDCDCDC),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )),
                ),
              ],
            ),
            Positioned.fill(
                child: Align(
              alignment: Alignment.bottomCenter,
              child: Visibility(
                visible: buttonVisibilty,
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  height: 130,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withOpacity(0),
                        Colors.white.withOpacity(0.4),
                        Colors.white.withOpacity(0.7),
                        Colors.white.withOpacity(0.9),
                      ],
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 45,
                        width: 120,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                                bottomLeft: Radius.circular(30),
                                bottomRight: Radius.circular(30)),
                            color: Colors.white,
                            border: Border.all(
                                color: AppColors.greenText, width: 0.7)),
                        child: Center(
                          child: Text(
                            "Reject",
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: "semibold",
                                color: Colors.black),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        height: 45,
                        width: 120,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                                bottomLeft: Radius.circular(30),
                                bottomRight: Radius.circular(30)),
                            color: AppColors.greenText),
                        child: Center(
                          child: Text(
                            "Approve",
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: "semibold",
                                color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }


  getReportingTeam(BuildContext context , int id) async {
    EasyLoading.show(status: 'loading...');
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(PrefrenceConst.acessToken)!;

    var params = {
      'id':id
    };
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.getPendingApproval + "/${id}");
      var response = await http.get(url, headers: {
        "Accept": 'application/json',
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        setState(() {
          getPendingApproval = getPendingAppResponceFromJson(response.body);
          for (int i = 0; i < getPendingApproval.data!.length!; i++) {
            listColor.add(Colors.white.withOpacity(0.6));
            listVisibility.add(false);
          }
          print("Successssss");
        });
      } else {
        EasyLoading.dismiss();
        AlertDialogue().showAlertDialog(
            context, "Alert Dialogue", response.body.toString());
      }
    } catch (e) {
      EasyLoading.dismiss();
      String error = e.toString();
      AlertDialogue().showAlertDialog(context, "Alert Dialogue", "$error");
    }
  }
}


