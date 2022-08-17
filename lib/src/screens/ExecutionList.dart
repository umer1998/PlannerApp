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
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                            child: Container(
                              height: 1,
                              width: MediaQuery.of(context).size.width,
                              color: Color(0x759e9e9e),
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
                                    MaterialPageRoute(builder: (context) =>    MyDialogueContent(month: widget.plan, plannerId: widget.event_id,eventPurpose: widget.eventPurpose, event: widget.event,)));


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

class MyDialogueContent extends StatefulWidget {
  const MyDialogueContent({Key? key,  required this.month, required this.plannerId, required this.eventPurpose, required this.event})
      : super(key: key);


  final String month;
  final String plannerId;
  final String eventPurpose;
  final String event;


  @override
  _MyDialogueContentState createState() => _MyDialogueContentState();
}

class _MyDialogueContentState extends State<MyDialogueContent> {
  List<DropdownMenuItem<String>> _eventTypes = [];
  List<DropdownMenuItem<String>> _eventPurpose = [];

  List<DropdownMenuItem<String>> _region = [];
  List<DropdownMenuItem<String>> _area = [];
  List<DropdownMenuItem<String>> _branch = [];

  List<DropdownMenuItem<String>> _meetingPlace = [];
  late TextEditingController _controller1 = TextEditingController(text: DateTime.now().toString());

  SharedPreferences? pref;
  late String eventTypevalue = "sdasd";
  late String eventPurposevalue = "s";
  String regionvalue = "Lahore";

  String areavalue = "Madhulal";
  String branchvalue = "0";

  String meetingPlace = "0";

  int typeid = 0;
  int purposeid = 0;

  bool isVisible = false;
  bool isLocationVisible = false;

  List<Events> events = [];
  List<Purposes> purposes = [];

  List<Network> network = [];

  List<Areas> areaslist = [];
  String _valueChanged1 = '';


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
                        dateMask: 'd MMM, yyyy',
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
                          hint: Text("Select Type"),

                          // Down Arrow Icon
                          icon: const Icon(Icons.keyboard_arrow_down),
                          // Array list of items
                          items: _eventTypes,
                          // value: eventTypevalue,
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
                              eventPurposevalue = events[index].purposes![0].purposeName!;
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
                        hint: Text("Select Purpose"),

                        // Down Arrow Icon
                        icon: const Icon(Icons.keyboard_arrow_down),
                        // value: eventPurposevalue,
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
                              // value: branchvalue,
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

                              // value: regionvalue,

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
                                // value: areavalue,
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
                              // value: branchvalue,

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

                            if (eventPurposevalue == "s") {
                              AlertDialogue().showAlertDialog(context, "Alert Dialogue",
                                  "Please select the Event Type Purpose.");
                            } else {

                              NewEvent newEvent = NewEvent();
                              newEvent.plannedOn = DateFormat('yyyy-MM-dd').format(DateTime.parse(_valueChanged1));
                              newEvent.plan = widget.month;
                              newEvent.eventId = eventTypevalue.toString();
                              newEvent.purposeId = eventPurposevalue.toString();
                              newEvent.purposeChildId = branchvalue.toString();


                              if(eventTypevalue.toString() == "leave" || eventTypevalue.toString() == "Leave"){
                                ChangedPlanRequest changePlanRequest = ChangedPlanRequest();

                                ChangedPlan changePlan = ChangedPlan();

                                changePlan.newEvent = newEvent;
                                changePlan.plannerEventId = int.parse(widget.plannerId);
                                List<Feedbackschange> list = [];
                                changePlan.feedbacks = list;

                                List<ChangedPlan> listt = [];
                                listt.add(changePlan);

                                changePlanRequest.changedPlan = listt;
                                 var connectivityResult = await (Connectivity().checkConnectivity());
                                 if (connectivityResult == ConnectivityResult.mobile) {
                                   submittForm(context, changePlanRequest.toJson());
                                 } else if (connectivityResult == ConnectivityResult.wifi) {
                                   submittForm(context, changePlanRequest.toJson());
                                 } else{
                                   ChangedPlanRequest request = ChangedPlanRequest();
                                   if(prefs!.get(PrefrenceConst.replaceEventPlusFeedback)! != ""){
                                     request = changeplanResponceFromJson(prefs.getString(PrefrenceConst.replaceEventPlusFeedback)!);
                                     List<ChangedPlan> changeList = [];
                                     changeList = request.changedPlan!;
                                     changeList.add(changePlan);
                                     request.changedPlan = changeList;
                                   } else {
                                     List<ChangedPlan> changeList = [];
                                     changeList.add(changePlan);
                                     request.changedPlan = changeList;
                                   }
                                   prefs.setString(PrefrenceConst.replaceEventPlusFeedback,changeplanResponceInToJson(request));
                                   Navigator.push(
                                     context,
                                     MaterialPageRoute(builder: (context) =>  HomeScreen() ));
                                 }


                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) =>  ChangedPlanFormScreen(eventPurpose: widget.eventPurpose, event: widget.event, event_id: widget.plannerId, newEvent: newEvent)),
                                );
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
}