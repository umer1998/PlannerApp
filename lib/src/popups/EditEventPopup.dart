import 'dart:ui';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:plannerapp/src/apis/ApiService%20.dart';
import 'package:plannerapp/src/models/Get_All_List.dart';
import 'package:plannerapp/style/colors.dart';
import 'package:plannerapp/utils/Prefrences.dart';
import 'package:plannerapp/utils/alertdialogue.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/Configurations.dart';

class EditEvent extends StatefulWidget {
  const EditEvent({Key? key, required this.list}) : super(key: key,);

  final DataallList list;
  @override
  _EditEventState createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {

  List<DropdownMenuItem<String>> _eventTypes = [];
  List<DropdownMenuItem<String>> _eventPurpose = [];

  List<DropdownMenuItem<String>> _region = [];
  List<DropdownMenuItem<String>> _area = [];
  List<DropdownMenuItem<String>> _branch = [];

  List<DropdownMenuItem<String>> _meetingPlace = [];

  SharedPreferences? pref;
  late String eventTypevalue = "0";
  late String eventPurposevalue = "0";
  String regionvalue = "0";

  String areavalue = "0";
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
  String _valueChanged1 = DateFormat('yyyy-MM-dd').format(DateTime.now());
  late TextEditingController _controller1 = TextEditingController(text: DateTime.now().toString());
  List<MeetingPlaces> meetingPlaces = [];


  @override
  void initState() {
    getPrefrences();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
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
            firstDate: DateTime(DateTime.now().year, DateTime.now().month, 1, 0),
            lastDate: DateTime(DateTime.now().year, DateTime.now().month + 2, 0, 0),
            icon: Icon(Icons.event),
            dateLabelText: 'Date',
            timeLabelText: "Hour",
            //use24HourFormat: false,
            //locale: Locale('pt', 'BR'),
            selectableDayPredicate: (date) {
              if ( date.weekday == 7) {
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
            hint: Text("Select Purpose"),

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
              onPressed: () {

                if (eventTypevalue == "field_visit") {
                  if (eventPurposevalue == "0" || eventTypevalue == "0" ||
                      regionvalue == "0" || areavalue == "0"
                      || branchvalue == "0") {
                    AlertDialogue().showAlertDialog(
                        context, "Alert Dialogue",
                        "Please select all values");
                  } else {
                    Map<String, String> body ={
                      'id': widget.list.id.toString(),
                      'planned_on': DateFormat('yyyy-MM-dd').format(DateTime.parse(_valueChanged1)),
                      'event_id': eventTypevalue.toString(),
                      'purpose_id': eventPurposevalue.toString(),
                      'purpose_child_id': branchvalue.toString(),

                    };
                    showConfirmationDialog(body, context);
                  }
                }
                else if (eventTypevalue == "meeting") {
                  if (eventPurposevalue == "0" || eventTypevalue == "0" ||
                      branchvalue == "0") {
                    AlertDialogue().showAlertDialog(
                        context, "Alert Dialogue",
                        "Please select all values");
                  } else {
                    Map<String, String> body ={
                      'id': widget.list.id.toString(),
                      'planned_on': DateFormat('yyyy-MM-dd').format(DateTime.parse(_valueChanged1)),
                      'event_id': eventTypevalue.toString(),
                      'purpose_id': eventPurposevalue.toString(),
                      'purpose_child_id': branchvalue.toString(),

                    };
                    showConfirmationDialog(body, context);
                  }
                }
                else {
                  if (eventPurposevalue == "0" || eventTypevalue == "0") {
                    AlertDialogue().showAlertDialog(
                        context, "Alert Dialogue",
                        "Please select all values");
                  }
                  else {
                    Map<String, String> body ={
                      'id': widget.list.id.toString(),
                      'planned_on': DateFormat('yyyy-MM-dd').format(DateTime.parse(_valueChanged1)),
                      'event_id': eventTypevalue.toString(),
                      'purpose_id': eventPurposevalue.toString(),
                      'purpose_child_id': branchvalue.toString(),

                    };
                    showConfirmationDialog(body, context);
                  }
                }
                //
                // // editEvent(context, body);
                // if (eventPurposevalue == "s") {
                //   AlertDialogue().showAlertDialog(context, "Alert Dialogue",
                //       "Please select the Event Type Purpose.");
                // } else {

                // }
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

  void showConfirmationDialog(Map<String, String> body, BuildContext context) {
    AlertDialog alert = AlertDialog(
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      content: Container(
        height: 130,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(

        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 5, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
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
                ],
              ),
            ),
            Text("Are You Sure to Edit Event?", style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black,
                fontSize: 20
            ),),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: (){
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    height: 35,
                    width: 80,
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
                        "Cancel",
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: "semibold",
                            color: Color(0xff909089)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                InkWell(

                  onTap: (){
                    ApiService().editEvent(body, context);
                  },
                  child: Container(
                    height: 35,
                    width: 80,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30)),
                        color: AppColors.greenText),
                    child: Center(
                      child: Text(
                        "Yes",
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
      ),

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