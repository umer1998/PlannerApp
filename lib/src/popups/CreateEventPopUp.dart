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

class CreateEventPopUp extends StatefulWidget {
  const CreateEventPopUp({Key? key,  required this.month, required this.plannerId, required this.eventPurpose, required this.event})
      : super(key: key);


  final String month;
  final String plannerId;
  final String eventPurpose;
  final String event;


  @override
  _MyDialogueContentState createState() => _MyDialogueContentState();
}

class _MyDialogueContentState extends State<CreateEventPopUp> {
  List<DropdownMenuItem<String>> _eventTypes = [];
  List<DropdownMenuItem<String>> _eventPurpose = [];
  late List<FeedbackQuestionnaire> questionnaire =[];

  List<DropdownMenuItem<String>> _region = [];
  List<DropdownMenuItem<String>> _area = [];
  List<DropdownMenuItem<String>> _branch = [];

  List<DropdownMenuItem<String>> _meetingPlace = [];
  late TextEditingController _controller1 = TextEditingController(text: DateTime.now().toString());

  SharedPreferences? pref;
  late String eventTypevalue = "0";
  late String eventPurposevalue = "0";
  String regionvalue = "0";

  String areavalue = "0";
  String branchvalue = "-1";

  String meetingPlace = "0";

  int typeid = 0;
  int purposeid = 0;

  bool isVisible = false;
  bool isLocationVisible = false;

  List<Events> events = [];
  List<Purposes> purposes = [];

  List<Network> network = [];

  List<Areas> areaslist = [];
  String _valueChanged1 = DateFormat('yyyy-MM-dd').format(DateTime.now());


  List<MeetingPlaces> meetingPlaces = [];


  @override
  void initState() {
    getPrefrences();

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Center(
        child:  Wrap(
          children: [
            AlertDialog(
                content: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 5,
                      ),





                      DateTimePicker(
                        type: DateTimePickerType.date,
                        dateMask: 'yyyy-MM-dd',
                        controller: _controller1,
                        //initialValue: _initialValue,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(DateTime.now().year, DateTime.now().month, 1, 0),
                        lastDate: DateTime(DateTime.now().year, DateTime.now().month + 2, 0, 0),
                        icon: Icon(Icons.event),
                        dateLabelText: 'Date',
                        timeLabelText: "Hour",
                        //use24HourFormat: false,
                        //locale: Locale('pt', 'BR'),
                        selectableDayPredicate: (date) {
                          if (date.weekday == 7) {
                            return false;
                          }
                          return true;
                        },
                        onChanged: (val) => setState(() => _valueChanged1 = val),

                        onSaved: (val) => setState(() => _valueChanged1 = val ?? ''),
                      ),


                      SizedBox(
                        height: 7,
                      ),

                      Text(
                        "Event",
                        style: TextStyle(color: Colors.green),
                      ),
                      DropdownButton<String>(
                          isExpanded: true,
                          // Initial Value
                          hint: Text(widget.event ?? "Select Type"),

                          // Down Arrow Icon
                          icon: const Icon(Icons.keyboard_arrow_down),
                          // Array list of items
                          items: _eventTypes,
                          value: eventTypevalue,
                          // After selecting the desired option,it will
                          // change button value to selected value
                          onChanged: (String? newValue) async {
                            eventTypevalue = newValue!;

                            if (newValue == "leave") {
                              isVisible = false;
                              isLocationVisible = false;
                            } else if(newValue == "field_visit") {
                              isVisible = true;
                              isLocationVisible = false;
                            }
                            else{
                              isVisible = false;
                              isLocationVisible = true;
                            }
                            final int index = events.indexWhere(
                                    (element) => element.eventNameCode == newValue!);

                            List<DropdownMenuItem<String>> eventPurpose = [];
                            for (int i = 0; i < events[index].purposes!.length; i++) {
                              eventPurpose.add(DropdownMenuItem(
                                  child: Text(events[index].purposes![i].purposeName!),
                                  value: events[index].purposes![i].purposeCode!.toString()));
                            }

                            setState(() {
                              _eventPurpose = eventPurpose;
                            });
                          }),
                      SizedBox(
                        height: 7,
                      ),
                      Text(
                        "Purpose",
                        style: TextStyle(color: Colors.green),
                      ),
                      DropdownButton<String>(
                        isExpanded: true,
                        // Initial Value
                        hint: Text(widget.eventPurpose ?? "Select Purpose"),

                        // Down Arrow Icon
                        icon: const Icon(Icons.keyboard_arrow_down),
                        value: eventPurposevalue,
                        // Array list of items
                        items: _eventPurpose,
                        // After selecting the desired option,it will
                        // change button value to selected value
                        onChanged: (String? newValue) {
                          setState(() {
                            eventPurposevalue = newValue!;
                          });
                        },
                      ),
                      SizedBox(
                        height: 7,
                      ),


                      Visibility(
                        visible: isLocationVisible,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 7,
                            ),
                            Text(
                              "Location",
                              style: TextStyle(color: Colors.green),
                            ),
                            DropdownButton<String>(
                              isExpanded: true,
                              // Initial Value
                              hint: Text("Select Location"),

                              // Down Arrow Icon
                              icon: const Icon(Icons.keyboard_arrow_down),
                              value: branchvalue,
                              // Array list of items
                              items: _meetingPlace,
                              // After selecting the desired option,it will
                              // change button value to selected value
                              onChanged: (String? newValue) {
                                setState(() {
                                  branchvalue = newValue!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),

                      Visibility(
                        visible: isVisible,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 7,
                            ),
                            Text(
                              "Region",
                              style: TextStyle(color: Colors.green),
                            ),
                            DropdownButton<String>(
                              isExpanded: true,
                              // Initial Value

                              value: regionvalue,

                              // Down Arrow Icon
                              icon: const Icon(Icons.keyboard_arrow_down),

                              hint: Text("Select Region"),
                              // value: regionvalue,
                              // Array list of items
                              items: _region,
                              // After selecting the desired option,it will
                              // change button value to selected value
                              onChanged: (String? newValue) => setState(() {
                                regionvalue = newValue!;
                                final int index = network.indexWhere(
                                        (element) => element.code.toString() == newValue);
                                List<DropdownMenuItem<String>> eventPurpose = [];
                                for (int i = 0; i < network[index].areas!.length; i++) {
                                  eventPurpose.add(DropdownMenuItem(
                                      child: Text(network[index].areas![i].name!),
                                      value: network[index].areas![i].code!.toString()));
                                  areaslist.add(network![index].areas![i]);
                                }

                                setState(() {
                                  _area = eventPurpose;
                                });
                              }),
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            Text(
                              "Area",
                              style: TextStyle(color: Colors.green),
                            ),
                            DropdownButton<String>(
                                isExpanded: true,
                                // Initial Value

                                // Down Arrow Icon
                                icon: const Icon(Icons.keyboard_arrow_down),
                                hint: Text("Select Area"),
                                // value: areavalue,
                                value: areavalue,
                                // Array list of items
                                items: _area,
                                // After selecting the desired option,it will
                                // change button value to selected value
                                onChanged: (String? newValue) => setState(
                                      () {
                                    areavalue = newValue!;

                                    final int index = areaslist.indexWhere(
                                            (element) => element.code.toString() == newValue);
                                    List<DropdownMenuItem<String>> eventPurpose = [];
                                    for (int i = 0;
                                    i < areaslist[index].branches!.length;
                                    i++) {
                                      eventPurpose.add(DropdownMenuItem(
                                          child:
                                          Text(areaslist[index].branches![i].name!),
                                          value: areaslist[index]
                                              .branches![i]
                                              .code));
                                      branchvalue = "0";
                                    }

                                    setState(() {
                                      _branch = eventPurpose;
                                    });
                                  },
                                )),
                            SizedBox(
                              height: 7,
                            ),
                            Text(
                              "Branch",
                              style: TextStyle(color: Colors.green),
                            ),
                            DropdownButton<String>(
                              isExpanded: true,
                              // Initial Value
                              hint: Text("Select Branch"),
                              // value: branchvalue,
                              value: branchvalue,

                              // Down Arrow Icon
                              icon: const Icon(Icons.keyboard_arrow_down),

                              // Array list of items
                              items: _branch,
                              // After selecting the desired option,it will
                              // change button value to selected value
                              onChanged: (String? newValue) {
                                setState(() {
                                  branchvalue = newValue!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Center(
                        child: ElevatedButton(
                          onPressed: () async{
                            final prefs = await SharedPreferences.getInstance();


                            if (eventTypevalue == "field_visit") {
                              if (eventPurposevalue == "0" || eventTypevalue == "0" ||
                                  regionvalue == "0" || areavalue == "0"
                                  || branchvalue == "0") {
                                AlertDialogue().showAlertDialog(
                                    context, "Alert Dialogue",
                                    "Please select all values");
                              } else {
                                NewEvent newEvent = NewEvent();
                                newEvent.plannedOn = DateFormat('yyyy-MM-dd').format(
                                    DateTime.parse(_valueChanged1));
                                newEvent.plan = widget.month;
                                newEvent.eventId = eventTypevalue.toString();
                                newEvent.purposeId = eventPurposevalue.toString();
                                newEvent.purposeChildId = branchvalue.toString();

                                if (eventTypevalue.toString() == "leave" ||
                                    eventTypevalue.toString() == "Leave") {
                                  ChangedPlanRequest changePlanRequest = ChangedPlanRequest();

                                  ChangedPlan changePlan = ChangedPlan();

                                  changePlan.newEvent = newEvent;
                                  changePlan.plannerEventId =
                                      int.parse(widget.plannerId);
                                  List<Feedbackschange> list = [];
                                  changePlan.feedbacks = list;

                                  List<ChangedPlan> listt = [];
                                  listt.add(changePlan);

                                  changePlanRequest.changedPlan = listt;
                                  var connectivityResult = await (Connectivity()
                                      .checkConnectivity());
                                  if (connectivityResult ==
                                      ConnectivityResult.mobile ||
                                      connectivityResult == ConnectivityResult.wifi) {
                                    submittForm(context, changePlanRequest.toJson());
                                  } else {
                                    ChangedPlanRequest request = ChangedPlanRequest();
                                    if (prefs!.get(
                                        PrefrenceConst.replaceEventPlusFeedback)! !=
                                        "") {
                                      request = changeplanResponceFromJson(
                                          prefs.getString(PrefrenceConst
                                              .replaceEventPlusFeedback)!);
                                      List<ChangedPlan> changeList = [];
                                      changeList = request.changedPlan!;
                                      changeList.add(changePlan);
                                      request.changedPlan = changeList;
                                    } else {
                                      List<ChangedPlan> changeList = [];
                                      changeList.add(changePlan);
                                      request.changedPlan = changeList;
                                    }
                                    String jsonn = prefs.getString(PrefrenceConst.executionList)!;
                                    Execution_List_Responce? responce = getExeListResponceFromJson(jsonn);
                                    List<Data> liist = [];
                                    for(int i =0 ; i< responce.data!.length; i++){
                                      if(responce.data![i].plannerEventId.toString() == widget.plannerId){

                                      } else{
                                        liist.add(responce.data![i]);
                                      }
                                    }
                                    Execution_List_Responce changedResponce = new Execution_List_Responce();
                                    changedResponce.data = liist;

                                    //   final int index = responce.data!.indexWhere(
                                    //           (element) => element.plannerEventId == widget.event_id);
                                    // Data data1 = responce.data!.removeAt(index);
                                    //   Execution_List_Responce? responce1 = new Execution_List_Responce();
                                    //   responce1.data =data1;
                                    //   print (responce.toString());
                                    prefs.setString(PrefrenceConst.executionList, getExeListResponceInToJson(changedResponce));
                                    prefs.setString(
                                        PrefrenceConst.replaceEventPlusFeedback,
                                        changeplanResponceInToJson(request));
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => HomeScreen()));
                                  }
                                } else {
                                  setData(newEvent, widget.plannerId);
                                }
                              }
                            }
                            else if (eventTypevalue == "meeting") {
                              if (eventPurposevalue == "0" || eventTypevalue == "0" ||
                                  branchvalue == "0") {
                                AlertDialogue().showAlertDialog(
                                    context, "Alert Dialogue",
                                    "Please select all values");
                              } else {
                                NewEvent newEvent = NewEvent();
                                newEvent.plannedOn = DateFormat('yyyy-MM-dd').format(
                                    DateTime.parse(_valueChanged1));
                                newEvent.plan = widget.month;
                                newEvent.eventId = eventTypevalue.toString();
                                newEvent.purposeId = eventPurposevalue.toString();
                                newEvent.purposeChildId = branchvalue.toString();

                                if (eventTypevalue.toString() == "leave" ||
                                    eventTypevalue.toString() == "Leave") {
                                  ChangedPlanRequest changePlanRequest = ChangedPlanRequest();

                                  ChangedPlan changePlan = ChangedPlan();

                                  changePlan.newEvent = newEvent;
                                  changePlan.plannerEventId =
                                      int.parse(widget.plannerId);
                                  List<Feedbackschange> list = [];
                                  changePlan.feedbacks = list;

                                  List<ChangedPlan> listt = [];
                                  listt.add(changePlan);

                                  changePlanRequest.changedPlan = listt;
                                  var connectivityResult = await (Connectivity()
                                      .checkConnectivity());
                                  if (connectivityResult ==
                                      ConnectivityResult.mobile ||
                                      connectivityResult == ConnectivityResult.wifi) {
                                    submittForm(context, changePlanRequest.toJson());
                                  } else {
                                    ChangedPlanRequest request = ChangedPlanRequest();
                                    if (prefs!.get(
                                        PrefrenceConst.replaceEventPlusFeedback)! !=
                                        "") {
                                      request =
                                          changeplanResponceFromJson(prefs.getString(
                                              PrefrenceConst
                                                  .replaceEventPlusFeedback)!);
                                      List<ChangedPlan> changeList = [];
                                      changeList = request.changedPlan!;
                                      changeList.add(changePlan);
                                      request.changedPlan = changeList;
                                    } else {
                                      List<ChangedPlan> changeList = [];
                                      changeList.add(changePlan);
                                      request.changedPlan = changeList;
                                    }
                                    String jsonn = prefs.getString(PrefrenceConst.executionList)!;
                                    Execution_List_Responce? responce = getExeListResponceFromJson(jsonn);
                                    List<Data> liist = [];
                                    for(int i =0 ; i< responce.data!.length; i++){
                                      if(responce.data![i].plannerEventId.toString() == widget.plannerId){

                                      } else{
                                        liist.add(responce.data![i]);
                                      }
                                    }
                                    Execution_List_Responce changedResponce = new Execution_List_Responce();
                                    changedResponce.data = liist;

                                    //   final int index = responce.data!.indexWhere(
                                    //           (element) => element.plannerEventId == widget.event_id);
                                    // Data data1 = responce.data!.removeAt(index);
                                    //   Execution_List_Responce? responce1 = new Execution_List_Responce();
                                    //   responce1.data =data1;
                                    //   print (responce.toString());
                                    prefs.setString(PrefrenceConst.executionList, getExeListResponceInToJson(changedResponce));
                                    prefs.setString(
                                        PrefrenceConst.replaceEventPlusFeedback,
                                        changeplanResponceInToJson(request));
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => HomeScreen()));
                                  }
                                } else {
                                  setData(newEvent, widget.plannerId);
                                }
                              }
                            } else if(eventTypevalue.toString() == "leave" ||
                                eventTypevalue.toString() == "Leave"){
                              NewEvent newEvent = NewEvent();
                              newEvent.plannedOn = DateFormat('yyyy-MM-dd').format(
                                  DateTime.parse(_valueChanged1));
                              newEvent.plan = widget.month;
                              newEvent.eventId = eventTypevalue.toString();
                              newEvent.purposeId = eventPurposevalue.toString();
                              newEvent.purposeChildId = branchvalue.toString();
                              ChangedPlanRequest changePlanRequest = ChangedPlanRequest();

                              ChangedPlan changePlan = ChangedPlan();

                              changePlan.newEvent = newEvent;
                              changePlan.plannerEventId =
                                  int.parse(widget.plannerId);
                              List<Feedbackschange> list = [];
                              changePlan.feedbacks = list;

                              List<ChangedPlan> listt = [];
                              listt.add(changePlan);

                              changePlanRequest.changedPlan = listt;
                              var connectivityResult = await (Connectivity()
                                  .checkConnectivity());
                              if (connectivityResult ==
                                  ConnectivityResult.mobile ||
                                  connectivityResult == ConnectivityResult.wifi) {
                                submittForm(context, changePlanRequest.toJson());
                              } else {
                                ChangedPlanRequest request = ChangedPlanRequest();
                                if (prefs!.get(
                                    PrefrenceConst.replaceEventPlusFeedback)! !=
                                    "") {
                                  request =
                                      changeplanResponceFromJson(prefs.getString(
                                          PrefrenceConst
                                              .replaceEventPlusFeedback)!);
                                  List<ChangedPlan> changeList = [];
                                  changeList = request.changedPlan!;
                                  changeList.add(changePlan);
                                  request.changedPlan = changeList;
                                } else {
                                  List<ChangedPlan> changeList = [];
                                  changeList.add(changePlan);
                                  request.changedPlan = changeList;
                                }
                                String jsonn = prefs.getString(PrefrenceConst.executionList)!;
                                Execution_List_Responce? responce = getExeListResponceFromJson(jsonn);
                                List<Data> liist = [];
                                for(int i =0 ; i< responce.data!.length; i++){
                                  if(responce.data![i].plannerEventId.toString() == widget.plannerId){

                                  } else{
                                    liist.add(responce.data![i]);
                                  }
                                }
                                Execution_List_Responce changedResponce = new Execution_List_Responce();
                                changedResponce.data = liist;

                                //   final int index = responce.data!.indexWhere(
                                //           (element) => element.plannerEventId == widget.event_id);
                                // Data data1 = responce.data!.removeAt(index);
                                //   Execution_List_Responce? responce1 = new Execution_List_Responce();
                                //   responce1.data =data1;
                                //   print (responce.toString());
                                prefs.setString(PrefrenceConst.executionList, getExeListResponceInToJson(changedResponce));
                                prefs.setString(
                                    PrefrenceConst.replaceEventPlusFeedback,
                                    changeplanResponceInToJson(request));
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomeScreen()));
                              }
                            }
                            else {
                              if (eventPurposevalue == "0" || eventTypevalue == "0") {
                                AlertDialogue().showAlertDialog(
                                    context, "Alert Dialogue",
                                    "Please select all values");
                              }
                              else {
                                NewEvent newEvent = NewEvent();
                                newEvent.plannedOn = DateFormat('yyyy-MM-dd').format(
                                    DateTime.parse(_valueChanged1));
                                newEvent.plan = widget.month;
                                newEvent.eventId = eventTypevalue.toString();
                                newEvent.purposeId = eventPurposevalue.toString();
                                newEvent.purposeChildId = branchvalue.toString();

                                if (eventTypevalue.toString() == "leave" ||
                                    eventTypevalue.toString() == "Leave") {
                                  ChangedPlanRequest changePlanRequest = ChangedPlanRequest();

                                  ChangedPlan changePlan = ChangedPlan();

                                  changePlan.newEvent = newEvent;
                                  changePlan.plannerEventId =
                                      int.parse(widget.plannerId);
                                  List<Feedbackschange> list = [];
                                  changePlan.feedbacks = list;

                                  List<ChangedPlan> listt = [];
                                  listt.add(changePlan);

                                  changePlanRequest.changedPlan = listt;
                                  var connectivityResult = await (Connectivity()
                                      .checkConnectivity());
                                  if (connectivityResult ==
                                      ConnectivityResult.mobile ||
                                      connectivityResult == ConnectivityResult.wifi) {
                                    submittForm(context, changePlanRequest.toJson());
                                  } else {
                                    ChangedPlanRequest request = ChangedPlanRequest();
                                    if (prefs!.get(
                                        PrefrenceConst.replaceEventPlusFeedback)! !=
                                        "") {
                                      request =
                                          changeplanResponceFromJson(prefs.getString(
                                              PrefrenceConst
                                                  .replaceEventPlusFeedback)!);
                                      List<ChangedPlan> changeList = [];
                                      changeList = request.changedPlan!;
                                      changeList.add(changePlan);
                                      request.changedPlan = changeList;
                                    } else {
                                      List<ChangedPlan> changeList = [];
                                      changeList.add(changePlan);
                                      request.changedPlan = changeList;
                                    }
                                    prefs.setString(
                                        PrefrenceConst.replaceEventPlusFeedback,
                                        changeplanResponceInToJson(request));
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => HomeScreen()));
                                  }
                                } else {
                                  setData(newEvent, widget.plannerId);
                                }
                              }
                            }
                          },




                          style: ElevatedButton.styleFrom(
                            onSurface: AppColors.bgGreen,
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0),
                            ),
                          ),
                          child: Container(
                            width: 130,
                            height: 55,
                            decoration: BoxDecoration(
                              borderRadius: new BorderRadius.only(
                                  topLeft: const Radius.circular(25.0),
                                  bottomLeft: const Radius.circular(25.0),
                                  topRight: const Radius.circular(25.0),
                                  bottomRight: const Radius.circular(25.0)),
                            ),
                            child: Center(
                              child: Text(
                                "SUBMIT",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )      ),
          ],
        ),
      ),
    );

  }



  void getPrefrences() async {
    try {
      pref = await SharedPreferences.getInstance();

      setState(() {

        String json = pref!.getString(PrefrenceConst.events)!;

        ConData data = conDataFromJson(json);
        events = data.events!;
        network = data.network!;
        meetingPlaces = data.meetingPlaces!;
        eventTypevalue = events[0].eventNameLabel!;
        for (int i = 0; i < events.length; i++) {
          _eventTypes.add(DropdownMenuItem(
              child: Text(events[i].eventNameLabel!),
              value: events[i].eventNameCode.toString()!));
        }

        for (int i = 0; i < events[0].purposes!.length; i++) {
          _eventPurpose.add(DropdownMenuItem(
              child: Text(events[0].purposes![i].purposeName!),
              value: events[0].purposes![i].purposeCode!.toString()));
        }

        for (int i = 0; i < meetingPlaces.length; i++) {
          _meetingPlace.add(DropdownMenuItem(
              child: Text(meetingPlaces[i].name!),
              value: meetingPlaces[i].code.toString()));
        }
        regionvalue = network[0].name!;
        areavalue = network[0].areas![0].name!;
        for (int i = 0; i < network.length; i++) {
          _region.add(DropdownMenuItem(
              child: Text(network[i].name!), value: network[i].code!.toString()));
        }
        String a ="a";
      });
    } catch (e) {}
  }

  submittForm(BuildContext context, Map body ) async {
    EasyLoading.show(status: 'loading...');
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(PrefrenceConst.acessToken)!;

    print (jsonEncode(body));
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.replaceEventPlusFeedback);
      var response = await http.post(url, headers: {
        "Accept": 'application/json',
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      }, body: jsonEncode(body));
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        setState(() {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()));
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

  void saveData(NewEvent newEvent, String event_id) async {
    final prefs = await SharedPreferences.getInstance();

    ChangedPlanRequest changedPlanRequest = ChangedPlanRequest();
    ChangedPlan changedPlan = ChangedPlan();
    List<Feedbackschange> feedList = [];
    List<Questionairechange> questionaireList = [];
    Feedbackschange feedbacks = Feedbackschange();
    changedPlan.plannerEventId = int.parse(event_id);

    feedbacks.questionaire = questionaireList;
    feedList.add(feedbacks);
    changedPlan.feedbacks = feedList;
    changedPlan.newEvent = newEvent;
    List<ChangedPlan> listchangePlan = [];
    listchangePlan.add(changedPlan);
    changedPlanRequest.changedPlan = listchangePlan ;

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      submittForm(context, changedPlanRequest.toJson());
    } else if (connectivityResult == ConnectivityResult.wifi) {
      submittForm(context, changedPlanRequest.toJson());
    } else{

      ChangedPlanRequest request = ChangedPlanRequest();
      if(prefs!.get(PrefrenceConst.replaceEventPlusFeedback)! != ""){
        request = changeplanResponceFromJson(prefs.getString(PrefrenceConst.replaceEventPlusFeedback)!);
        List<ChangedPlan> list = [];
        list = request.changedPlan!;
        list.add(changedPlanRequest.changedPlan![0]);
        request.changedPlan = list;
      } else {
        List<ChangedPlan> list = [];
        list.add(changedPlanRequest.changedPlan![0]);
        request.changedPlan = list;
      }
      String jsonn = prefs.getString(PrefrenceConst.executionList)!;
      Execution_List_Responce? responce = getExeListResponceFromJson(jsonn);
      List<Data> liist = [];
      for(int i =0 ; i< responce.data!.length; i++){
        if(responce.data![i].plannerEventId.toString() == widget.plannerId){

        } else{
          liist.add(responce.data![i]);
        }
      }
      Execution_List_Responce changedResponce = new Execution_List_Responce();
      changedResponce.data = liist;

      //   final int index = responce.data!.indexWhere(
      //           (element) => element.plannerEventId == widget.event_id);
      // Data data1 = responce.data!.removeAt(index);
      //   Execution_List_Responce? responce1 = new Execution_List_Responce();
      //   responce1.data =data1;
      //   print (responce.toString());
      prefs.setString(PrefrenceConst.executionList, getExeListResponceInToJson(changedResponce));

      prefs.setString(PrefrenceConst.replaceEventPlusFeedback,changeplanResponceInToJson(request));
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>  HomeScreen() ));


    }
  }

  void setData(NewEvent event, String plannerId) async{
    final prefs = await SharedPreferences.getInstance();

    String json = prefs!.getString(PrefrenceConst.events)!;
    ConData _model = conDataFromJson(json);
    for(int i= 0; i< _model.events!.length; i++){
      if(_model.events![i].eventNameCode == event.eventId){
        for(int j=0; j<  _model.events![i].purposes!.length; j++ ){
          if(_model.events![i].purposes![j].purposeCode == event.purposeId){
              questionnaire = _model.events![i].purposes![j].feedbackQuestionnaire!;
              break;
          }
        }
      }
    }
    if(questionnaire.length > 0){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>  ChangedPlanFormScreen( event_id: widget.plannerId, newEvent: event, questionnaire: questionnaire, )),
      );
    } else {
      saveData(event, widget.plannerId);
    }
  }
}