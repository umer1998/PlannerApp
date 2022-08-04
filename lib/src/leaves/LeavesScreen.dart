import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:plannerapp/src/models/Leaves_Response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../utils/ApiConstants.dart';
import '../../utils/Prefrences.dart';
import '../../utils/alertdialogue.dart';
import '../initialscrrens/HomeScreen.dart';

class LeavesScreen extends StatefulWidget {
  const LeavesScreen({Key? key}) : super(key: key);

  @override
  _LeavesScreenState createState() => _LeavesScreenState();
}

class _LeavesScreenState extends State<LeavesScreen> with SingleTickerProviderStateMixin {

  late TabController _controller;
  int _selectedIndex = 0;
  Timer? _timer;

  late Leaves_Response leaves_response ;

  List<Data> pendingList= [];
  List<Data> approvedList= [];
  List<Data> rejectedList= [];


  @override
  void initState() {
    super.initState();
    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });
    _controller = TabController(length: 3, vsync: this);
    getLeavesResponse();
   // /
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [

                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: DefaultTabController(
                    length: 3,
                    child:Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 20, 15, 25),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: GestureDetector(
                                  onTap: (){
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => const HomeScreen()),
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
                                  "Leaves",
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
                        Container(
                          height: 1,
                          width: MediaQuery.of(context).size.width,
                          color: Color(0x759e9e9e),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                          child: TabBar(
                            controller: _controller,
                            indicatorColor: Color(0xff96C949),
                            tabs: [
                              Container(height: 40 , child: Column( mainAxisAlignment: MainAxisAlignment.center,children: [
                                Text("Pending" ,textAlign: TextAlign.center, style: TextStyle(

                                ),),
                              ],),),

                              Container(height: 40 , child: Column( mainAxisAlignment: MainAxisAlignment.center,children: [
                                Text("Approved", textAlign: TextAlign.center, style: TextStyle(

                                ),),
                              ],),),

                              Container(height: 40, child: Column( mainAxisAlignment: MainAxisAlignment.center,children: [
                                Text("Rejected", textAlign: TextAlign.center,style: TextStyle(

                                ),),
                              ],),)
                            ],
                            labelColor: Colors.black,
                            unselectedLabelColor: Colors.grey,
                          ),
                        ),
                      ],
                    ),


                  ),


                ),
                Container(
                  height: 8,
                  width: MediaQuery.of(context).size.width,
                  color: Color(0xffDCDCDC),
                ),
                Expanded(child: TabBarView(
                  controller: _controller,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Container(
                          decoration: BoxDecoration(

                            image: DecorationImage(
                                image: AssetImage('assets/img/bg.jpg'), fit: BoxFit.fill),
                          ),
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: pendingList.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: GestureDetector(
                                  onTap: () {
                                  },
                                  child: Container(

                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.4),
                                    ),
                                    child: Wrap(
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(20, 7, 20, 0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${pendingList[index].event}",
                                                    style: TextStyle(
                                                        fontFamily: "bold",
                                                        fontSize: 22,
                                                        color: Colors.black),
                                                  ),

                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 6,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                              child: Row(
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
                                                    "${DateFormat.yMMMMd().format(DateTime.parse(pendingList[index].plannedOn!))}",
                                                    style: TextStyle(
                                                        fontFamily: "semibold",
                                                        fontSize: 14,
                                                        color: Color(0xff909089)),
                                                  ),


                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                              const EdgeInsets.fromLTRB(0, 10, 0, 7),
                                              child: Container(
                                                height: 0.5,
                                                width: MediaQuery.of(context).size.width,
                                                color: Color(0xffDCDCDC),
                                              ),
                                            ),

                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Container(
                          decoration: BoxDecoration(

                            image: DecorationImage(
                                image: AssetImage('assets/img/bg.jpg'), fit: BoxFit.fill),
                          ),
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: approvedList.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: GestureDetector(
                                  onTap: () {
                                  },
                                  child: Container(

                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.4),
                                    ),
                                    child: Wrap(
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(20, 7, 20, 0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${approvedList[index].event}",
                                                    style: TextStyle(
                                                        fontFamily: "bold",
                                                        fontSize: 22,
                                                        color: Colors.black),
                                                  ),

                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 6,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                              child: Row(
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
                                                    "${DateFormat.yMMMMd().format(DateTime.parse(approvedList[index].plannedOn!))}",
                                                    style: TextStyle(
                                                        fontFamily: "semibold",
                                                        fontSize: 14,
                                                        color: Color(0xff909089)),
                                                  ),


                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                              const EdgeInsets.fromLTRB(0, 10, 0, 7),
                                              child: Container(
                                                height: 0.5,
                                                width: MediaQuery.of(context).size.width,
                                                color: Color(0xffDCDCDC),
                                              ),
                                            ),

                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Container(
                          decoration: BoxDecoration(

                            image: DecorationImage(
                                image: AssetImage('assets/img/bg.jpg'), fit: BoxFit.fill),
                          ),
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: rejectedList.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: GestureDetector(
                                  onTap: () {
                                  },
                                  child: Container(

                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.4),
                                    ),
                                    child: Wrap(
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(20, 7, 20, 0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${rejectedList[index].event}",
                                                    style: TextStyle(
                                                        fontFamily: "bold",
                                                        fontSize: 22,
                                                        color: Colors.black),
                                                  ),

                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 6,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                              child: Row(
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
                                                    "${DateFormat.yMMMMd().format(DateTime.parse(rejectedList[index].plannedOn!))}",
                                                    style: TextStyle(
                                                        fontFamily: "semibold",
                                                        fontSize: 14,
                                                        color: Color(0xff909089)),
                                                  ),


                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                              const EdgeInsets.fromLTRB(0, 10, 0, 7),
                                              child: Container(
                                                height: 0.5,
                                                width: MediaQuery.of(context).size.width,
                                                color: Color(0xffDCDCDC),
                                              ),
                                            ),

                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),)
              ],
            ),
          ),
        ),
      ),
    );
  }


  getLeavesResponse() async {
    EasyLoading.show(status: 'loading...');
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(PrefrenceConst.acessToken)!;
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.getLeaves);
      var response = await http.get(url, headers: {
        "Accept": 'application/json',
        'Authorization': 'Bearer $token'
      });
      if (response.statusCode == 200) {
        EasyLoading.dismiss();

          leaves_response = getleavesResponceFromJson(response.body);
        setState(() {
          for(int i = 0; i< leaves_response.data!.length; i++){
            if(leaves_response.data![i].eventStatus == "pending"){
              pendingList.add(leaves_response.data![i]);
            } else if(leaves_response.data![i].eventStatus == "approved"){
              approvedList.add(leaves_response.data![i]);
            } else if(leaves_response.data![i].eventStatus == "rejected"){
              rejectedList.add(leaves_response.data![i]);
            }
          }

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


