import 'dart:async';
import 'dart:ui';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:plannerapp/src/apis/ApiService%20.dart';
import 'package:plannerapp/src/models/Get_All_List.dart';
import 'package:plannerapp/src/models/Login_Responce.dart';
import 'package:plannerapp/style/colors.dart';
import 'package:plannerapp/utils/MeetingDataSource.dart';
import 'package:plannerapp/utils/Prefrences.dart';
import 'package:plannerapp/utils/alertdialogue.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../utils/ApiConstants.dart';
import '../models/Configurations.dart';

class CreatePlan extends StatefulWidget {
  const CreatePlan({Key? key}) : super(key: key);

  @override
  State<CreatePlan> createState() => _CreatePlanState();
}

class _CreatePlanState extends State<CreatePlan> {
  CalendarDataSource? _dataSource;
  String month = "";
  late Get_All_List getAllList ;
  Timer? _timer;
  bool addVisibility = false;
  DateTime dateTime = DateTime.now();
  List<Appointment> _appointmentDetails = <Appointment>[];

  @override
  void initState() {
    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });
    getAllEventList(context);
  }

  _getCalendarDataSource() {
    List<Appointment> appointment = <Appointment>[];

    for(int i=0; i< getAllList.data!.length; i++){
      DateTime dateTime = DateFormat('yyyy-MM-dd').parse(getAllList.data![i].plannedOn!);

      String json = getdataallResponceInToJson(getAllList.data![i]);
      appointment.add(Appointment(
        notes: json,
          startTime: DateFormat('yyyy-MM-dd').parse(getAllList.data![i].plannedOn!),
          endTime: DateFormat('yyyy-MM-dd').parse(getAllList.data![i].plannedOn!),
          subject: getAllList.data![i].event!,
          isAllDay: false));
    }



    _dataSource = MeetingDataSource(appointment);
  }


  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child : Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/img/bg.jpg'), fit: BoxFit.fill),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Plan for \n$month ",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      InkWell(
                        onTap: (){
                          Map<String, String> body ={
                            'plan': month,
                            'status': "3"
                          };

                          ApiService().submitPlan(body, context, month);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: new BorderRadius.only(
                                topLeft: const Radius.circular(15.0),
                                bottomLeft: const Radius.circular(15.0),
                                topRight: const Radius.circular(15.0),
                                bottomRight: const Radius.circular(15.0)),
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 0),
                                blurRadius: 2,
                                spreadRadius: 2,
                                color: Color(0xddcdcdd0),
                              ),
                            ],
                          ),
                          height: 45,
                          width: 150,
                          child: Center(
                            child: Text(
                              "Submitt Plan for \n$month",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  height: 500,
                  child: SfCalendar(
                    viewHeaderHeight: 40,

                    onViewChanged: (ViewChangedDetails details) {
                      List<DateTime> dates = details.visibleDates;

                      SchedulerBinding.instance.addPostFrameCallback((duration) {
                        setState(() {
                          month = DateFormat.yMMMM().format(dates[8]);
                        });
                      });
                    },
                    minDate:
                    DateTime(DateTime.now().year, DateTime.now().month, 1, 0),
                    maxDate:
                    DateTime(DateTime.now().year, DateTime.now().month + 2, 0, 0),
                    headerHeight: 80,
                    headerStyle: CalendarHeaderStyle(
                        textStyle:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                    backgroundColor: Colors.white.withOpacity(0.4),
                    cellBorderColor: Colors.black12,
                    todayHighlightColor: Colors.green,
                    appointmentTextStyle: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    view: CalendarView.month,
                    dataSource: _dataSource,
                    onTap: calendarTappeded,
                    onLongPress: (CalendarLongPressDetails detail) {

                    },
                    monthViewSettings: const MonthViewSettings(
                      appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
                      showAgenda: false,
                      agendaItemHeight: 70,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: (){
                        String month = DateFormat.MMMM().format(dateTime!);
                        DateTime now = DateTime.now();
                        String currentmonth = DateFormat.MMMM().format(DateTime.now());
                        if (DateFormat.MMMM().format(dateTime!) ==
                            DateFormat.MMMM().format(DateTime.now()) ||
                            DateFormat.MMMM().format(dateTime!) ==
                                DateFormat.MMMM().format(
                                    DateTime(now.year, now.month + 1, now.day))) {
                          setState(() {
                            _openPopup(context, dateTime);
                          });
                        } else {
                          showAlertDialog(context);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 50,
                          width: 120,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20)),
                              border: Border.all(
                                  color: AppColors.greenText, width: 0.7)
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add),
                                SizedBox(
                                  width: 5,
                                ),
                                Text('Add Event', style: TextStyle(
                                  fontFamily: "regular",
                                  fontSize: 15,
                                  color: AppColors.bgGreen
                                ),)
                              ],
                            )
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Expanded(
                  child: Container(

                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: _appointmentDetails.length,
                      itemBuilder: (context, index) {
                        DataallList data = getdataallResponceFromJson(_appointmentDetails![index].notes!);
                        return Slidable(

                          endActionPane:  ActionPane(
                            motion: ScrollMotion(),
                            children: [
                              SlidableAction(
                                // An action can be bigger than the others.
                                flex: 2,
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'delete', onPressed: (BuildContext context) {
                                Map<String, String> body ={
                                  'id': data.id.toString(),
                                  'deleted': 1.toString(),
                                };
                                ApiService().editEvent(body, context);

                              },

                              ),


                            ],
                          ),
                          child: InkWell(
                            onTap: (){

                              _editEventPopup(context,  data);

                              // Map<String, String> body ={
                              //   'id': "nameController.text",
                              //   'event': "nameController.text",
                              //   'email': "nameController.text",
                              //   'event_purpose': "nameController.text",
                              //   'description': "nameController.text",
                              //   'planned_on': "nameController.text",
                              //   'event_status': "nameController.text",
                              //   'execution_status': "nameController.text"
                              // };
                              // editEvent(context, body);
                            },
                            child: Container(
                              color: Colors.white.withOpacity(0.6),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(15, 17, 15, 0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("${_appointmentDetails[index].subject}",textAlign: TextAlign.start, style: TextStyle(
                                                fontSize: 19,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black
                                            ),),

                                            SizedBox(height: 8,),

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



                                                Text(
                                                  "  ${DateFormat("yyyy-MM-dd").format(_appointmentDetails[index].startTime)}",
                                                  style: TextStyle(
                                                      fontFamily: "regular",
                                                      fontSize: 15,
                                                      color: Colors.grey),
                                                ),
                                              ],
                                            ),


                                          ],
                                        ),



                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 17, 0, 0),
                                    child: Container(
                                      height: 1,
                                      width: MediaQuery.of(context).size.width,
                                      color: Color(0x759e9e9e),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                        );
                      },
                    )
                  ),
                ),
              ],
            ),
          ),

        ));
  }


  void calendarTappeded(CalendarTapDetails calendarTapDetails) {
    setState(() {
      dateTime = calendarTapDetails.date!;
    });
    if (calendarTapDetails.targetElement == CalendarElement.calendarCell) {
      setState(() {
        _appointmentDetails =
            calendarTapDetails.appointments!.cast<Appointment>();
      });
    }
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Ok"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("AlertDialog"),
      content: Text("Could not add event other than current month"),
      actions: [
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  doNothing(BuildContext context) {

  }


  _openPopup(BuildContext context, DateTime? datee) {
    String date = DateFormat.yMMMMd().format(datee!);
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              bottomLeft: Radius.circular(0),
              bottomRight: Radius.circular(0),
              topRight: Radius.circular(20)),
          color: Colors.black12,
        ),
        height: 55,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(alignment: Alignment.centerLeft, child: Text('Event')),
              SizedBox(
                height: 5,
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '$date',
                    style: TextStyle(fontSize: 18),
                  ))
            ],
          ),
        ),
      ),
      content: Wrap(
        children: [MyDialogueContent(datee: datee, month: month)],
      ),
      titlePadding: const EdgeInsets.all(0),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  getAllEventList(BuildContext context) async {
    EasyLoading.show(status: 'loading...');
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(PrefrenceConst.acessToken)!;
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.getEvents);
      var response = await http.get(url, headers: {
        "Accept": 'application/json',
        'Authorization': 'Bearer $token'
      });
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        setState(() {
          getAllList = getAllListResponceFromJson(response.body);
          _getCalendarDataSource();
          String a = "a";
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



  _editEventPopup(BuildContext context, DataallList list) {

    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              bottomLeft: Radius.circular(0),
              bottomRight: Radius.circular(0),
              topRight: Radius.circular(20)),
          color: Colors.black12,
        ),
        height: 55,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Align(alignment: Alignment.centerLeft, child: Text('Event')),
              SizedBox(
                height: 5,
              ),

            ],
          ),
        ),
      ),
      content: Wrap(
        children: [EditEvent(list: list)],
      ),
      titlePadding: const EdgeInsets.all(0),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class MyDialogueContent extends StatefulWidget {
  const MyDialogueContent({Key? key, required this.datee, required this.month})
      : super(key: key);
  final DateTime datee;
  final String month;

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
              onPressed: () {
                if (eventPurposevalue == "s") {
                  AlertDialogue().showAlertDialog(context, "Alert Dialogue",
                      "Please select the Event Type Purpose.");
                } else {
                  Map<String, String> body = {
                    'planned_on': DateFormat('yyyy-MM-dd').format(widget.datee),
                    'plan': widget.month,
                    'event_id': eventTypevalue.toString(),
                    'purpose_id': eventPurposevalue.toString(),
                    'purpose_child_id': branchvalue.toString(),
                  };
                  print(widget.month);
                  ApiService().createEvent(body, context);
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
            dateMask: 'd MMM, yyyy',
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
              if (date.weekday == 6 || date.weekday == 7) {
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
              onPressed: () {


                // editEvent(context, body);
                if (eventPurposevalue == "s") {
                  AlertDialogue().showAlertDialog(context, "Alert Dialogue",
                      "Please select the Event Type Purpose.");
                } else {
                  Map<String, String> body ={
                    'id': widget.list.id.toString(),
                    'planned_on': DateFormat('yyyy-MM-dd').format(DateTime.parse(_valueChanged1)),
                    'event_id': eventTypevalue.toString(),
                    'purpose_id': eventPurposevalue.toString(),
                    'purpose_child_id': branchvalue.toString(),

                  };

                  ApiService().editEvent(body, context);
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



