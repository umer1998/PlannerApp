import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:plannerapp/src/apis/ApiService%20.dart';
import 'package:plannerapp/style/colors.dart';
import 'package:plannerapp/utils/Prefrences.dart';
import 'package:plannerapp/utils/alertdialogue.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/Configurations.dart';


class CreateEventInPlanningPopup extends StatefulWidget {
  const CreateEventInPlanningPopup({Key? key, required this.datee, required this.month})
      : super(key: key);
  final DateTime datee;
  final String month;

  @override
  _MyDialogueContentState createState() => _MyDialogueContentState();
}

class _MyDialogueContentState extends State<CreateEventInPlanningPopup> {
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

                  // value: regionvalue,

                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),

                  hint: Text("Select Region"),
                  value: regionvalue,
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
                      branchvalue = "0";
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
                        branchvalue = newValue!;
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
              onPressed: () {

                if(eventTypevalue == "field_visit"){
                  if (eventPurposevalue == "0" || eventTypevalue == "0" || regionvalue == "0" || areavalue == "0"
                      || branchvalue =="0") {
                    AlertDialogue().showAlertDialog(context, "Alert Dialogue",
                        "Please select all values");
                  } else {
                    Map<String, String> body = {
                      'planned_on': DateFormat('yyyy-MM-dd').format(widget.datee),
                      'plan': widget.month,
                      'event_id': eventTypevalue.toString(),
                      'purpose_id': eventPurposevalue.toString(),
                      'purpose_child_id': branchvalue.toString(),
                    };

                    ApiService().createEvent(body, context);
                  }
                } else if(eventTypevalue == "meeting"){
                  if (eventPurposevalue == "0" || eventTypevalue == "0" || branchvalue =="0") {
                    AlertDialogue().showAlertDialog(context, "Alert Dialogue",
                        "Please select all values");
                  } else {
                    Map<String, String> body = {
                      'planned_on': DateFormat('yyyy-MM-dd').format(widget.datee),
                      'plan': widget.month,
                      'event_id': eventTypevalue.toString(),
                      'purpose_id': eventPurposevalue.toString(),
                      'purpose_child_id': branchvalue.toString(),
                    };

                    ApiService().createEvent(body, context);
                  }
                } else {
                  if (eventPurposevalue == "0" || eventTypevalue == "0" ) {
                    AlertDialogue().showAlertDialog(context, "Alert Dialogue",
                        "Please select all values");
                  } else {
                    Map<String, String> body = {
                      'planned_on': DateFormat('yyyy-MM-dd').format(widget.datee),
                      'plan': widget.month,
                      'event_id': eventTypevalue.toString(),
                      'purpose_id': eventPurposevalue.toString(),
                      'purpose_child_id': branchvalue.toString(),
                    };

                    ApiService().createEvent(body, context);
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
}