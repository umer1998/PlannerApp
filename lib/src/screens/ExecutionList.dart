import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:plannerapp/src/initialscrrens/HomeScreen.dart';
import 'package:plannerapp/src/models/ChangedPlanRequest.dart';
import 'package:plannerapp/src/models/Execution_List_Responce.dart';
import 'package:plannerapp/src/screens/ChangedPlanFormScreen.dart';
import 'package:plannerapp/src/screens/FormScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../style/colors.dart';
import '../../utils/ApiConstants.dart';
import '../../utils/Prefrences.dart';
import '../../utils/alertdialogue.dart';
import '../models/Configurations.dart';
import '../popups/CreateEventPopUp.dart';


class ExecutionList extends StatefulWidget {
  const ExecutionList({Key? key}) : super(key: key);

  @override
  _ExecutionListState createState() => _ExecutionListState();
}

class _ExecutionListState extends State<ExecutionList> {

  Execution_List_Responce? responce;
  late String  formatteddate;
  Timer? _timer;


  @override
  void initState() {
    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
     formatteddate = formatter.format(now);
     getList();
    // TODO: implement initState

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: new FloatingActionButton(
      //   onPressed: () {
      //     _openPopup(context);
      //   },
      //   backgroundColor: Colors.grey,
      //   child: const Icon(Icons.add),
      // ),
      // floatingActionButtonLocation:
      // FloatingActionButtonLocation.endFloat,



      body: SafeArea(
        child: Column(
          children: [

            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 20, 15, 50),
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
                        "Execution List",
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

            Expanded(
              child: Container(
                decoration: BoxDecoration(

                  image: DecorationImage(
                      image: AssetImage('assets/img/bg.jpg'), fit: BoxFit.fill),
                ),
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: responce == null ? 0 : responce!.data!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(0,0,0,0),
                      child: GestureDetector(
                        onTap: () {
                          showAlertDialog(context, responce!.data![index].eventPurpose!,responce!.data![index].event!, responce!.data![index].plannerEventId!.toString(), responce!.data![index].plan! );
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
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${responce!.data![index].event}",
                                          style: TextStyle(
                                              fontFamily: "bold",
                                              fontSize: 22,
                                              color: Colors.black),
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
                                              "${responce!.data![index].plannedOn}",
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
                                              "${responce!.data![index].eventPurpose}",
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


  getList() async {

    final prefs = await SharedPreferences.getInstance();

    setState(() {

      String json = prefs.getString(PrefrenceConst.executionList)!;
      responce = getExeListResponceFromJson(json);

    });
  }

  showAlertDialog(BuildContext context, String eventPurpose, String event, String event_id, String plan) {


    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        content: OptionAlert(eventPurpose: eventPurpose , event: event, event_id: event_id, plan: plan)

    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class OptionAlert extends StatefulWidget {
  const OptionAlert({Key? key, required this.eventPurpose, required this.event, required this.event_id, required this.plan}) : super(key: key);
  final String eventPurpose;
  final String event;
  final String event_id;
  final String plan;

  @override
  _AlertState createState() => _AlertState();
}

class _AlertState extends State<OptionAlert> {
   String optionselected =  "Changed";
  options _value = options.Changed;

   @override
   void initState() {

     super.initState();
   }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 5, 0),
              child: InkWell(
                onTap: (){
                  Navigator.of(context).pop();
                },
                child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      color: Color(0x759e9e9e),
                      shape: BoxShape.circle
                  ),
                  child: Center(
                      child: Icon(Icons.clear, size: 20, color: Colors.grey,)
                  ),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 30, 0, 20),
          child: Wrap(
            children: [
              Container(

                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(

                ),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    Text("Execute", style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontSize: 26
                    ),),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: <Widget>[
                        SizedBox(
                          height: 40,
                          child: ListTile(
                            title: const Text('Planned',style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                fontSize: 20
                            ),),
                            leading: Radio(
                              value: options.Planned,
                              groupValue: _value,
                              onChanged: ( value) {
                                setState(() {
                                  _value = value as options;
                                  optionselected = "Planned";
                                });
                              },
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 40,
                          child: ListTile(
                            title: const Text('Change', style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                fontSize: 20
                            ),),
                            leading: Radio(
                              value: options.Changed,
                              groupValue: _value,
                              onChanged: (value){
                                setState(() {
                                  _value = value as options;
                                  optionselected = "Change";
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        InkWell(
                          onTap: (){
                            print(_value);
                            if(_value.name == "Planned"){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>  FormScreen(eventPurpose: widget.eventPurpose, event: widget.event, event_id: widget.event_id,)),
                              );
                            } else if(_value.name == "Changed"){
                              setState(() {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) =>    CreateEventPopUp(month: widget.plan, plannerId: widget.event_id,eventPurpose: widget.eventPurpose, event: widget.event,)));


                              });
                            } else {

                            }

                          },
                          child: Container(
                            height: 40,
                            width: 90,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30),
                                    bottomLeft: Radius.circular(30),
                                    bottomRight: Radius.circular(30)),
                                color: AppColors.greenText),
                            child: Center(
                              child: Text(
                                "Continue",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: "semibold",
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}


enum options { Planned, Changed  }

