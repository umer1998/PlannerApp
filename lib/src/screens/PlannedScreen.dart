import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:plannerapp/src/initialscrrens/HomeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../utils/ApiConstants.dart';
import '../../utils/Prefrences.dart';
import '../../utils/alertdialogue.dart';
import '../models/Execution_List_Responce.dart';



class PlannedScreen extends StatefulWidget {
  const PlannedScreen({Key? key}) : super(key: key);

  @override
  _PlannedScreenState createState() => _PlannedScreenState();
}

class _PlannedScreenState extends State<PlannedScreen> {

  late String  formatteddate;
  late Execution_List_Responce responce;
  Timer? _timer;

  @override
  void initState() {
    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });
    getList(context);
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    formatteddate = formatter.format(now);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: Column(
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
                        "Planned List",
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
              height: 8,
              width: MediaQuery.of(context).size.width,
              color: Color(0x759e9e9e),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(

                  image: DecorationImage(
                      image: AssetImage('assets/img/bg.jpg'), fit: BoxFit.fill),
                ),
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: responce.data!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(0,0,0,0),
                      child: GestureDetector(
                        onTap: () {

                        },
                        child: Container(

                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.6),

                          ),
                          child: Wrap(
                            children: [
                              Column(

                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(15, 7, 10, 7),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "${responce.data![index].event}",
                                              style: TextStyle(
                                                  fontFamily: "bold",
                                                  fontSize: 22,
                                                  color: Colors.black),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "Status: ",
                                                  style: TextStyle(
                                                      fontFamily: "semibold",
                                                      fontSize: 17,
                                                      color: Colors.black),
                                                ),
                                                Text(
                                                  "pending",
                                                  style: TextStyle(
                                                      fontFamily: "medium",
                                                      fontSize: 17,
                                                      color: Colors.green),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 6,
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
                                              "${responce.data![index].plannedOn}",
                                              style: TextStyle(
                                                  fontFamily: "semibold",
                                                  fontSize: 14,
                                                  color: Color(0xff909089)),
                                            ),


                                          ],
                                        ),

                                        // Padding(
                                        //   padding:
                                        //   const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                        //   child: Container(
                                        //     height: 0.5,
                                        //     width: MediaQuery.of(context).size.width,
                                        //     color: Colors.grey,
                                        //   ),
                                        // ),
                                        SizedBox(height: 5,),
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
                                            Text(
                                              "${responce.data![index].purposeChild}",
                                              style: TextStyle(
                                                  fontFamily: "regular",
                                                  fontSize: 15,
                                                  color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                    child: Container(
                                      height: 1,
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
          ],
        ),
      ),

    );
  }

  getList(BuildContext context) async {
    EasyLoading.show(status: 'loading...');
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(PrefrenceConst.acessToken)!;
    try {

      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.dayPlanner);
      var response = await http.get(url, headers: {
        "Accept": 'application/json',
        'Authorization': 'Bearer $token'
      });
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        Execution_List_Responce _model = getExeListResponceFromJson(response.body);
        setState(() {
          responce = _model;
        });

      } else {
        EasyLoading.dismiss();
        AlertDialogue().showAlertDialog(context, "Alert Dialogue", response.body.toString());
      }
    } catch (e) {
      EasyLoading.dismiss();
      String error = e.toString();
      AlertDialogue().showAlertDialog(context, "Alert Dialogue", "$error");

    }
  }
}
