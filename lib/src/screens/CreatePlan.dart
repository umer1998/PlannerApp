import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:plannerapp/src/apis/ApiService%20.dart';
import 'package:plannerapp/src/models/Login_Responce.dart';
import 'package:plannerapp/style/colors.dart';
import 'package:plannerapp/utils/MeetingDataSource.dart';
import 'package:plannerapp/utils/Prefrences.dart';
import 'package:plannerapp/utils/alertdialogue.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CreatePlan extends StatefulWidget {
  const CreatePlan({Key? key}) : super(key: key);

  @override
  State<CreatePlan> createState() => _CreatePlanState();
}

class _CreatePlanState extends State<CreatePlan> {
  CalendarDataSource? _dataSource;
  String month = "";

  List<Appointment> _appointmentDetails = <Appointment>[];

  @override
  void initState() {
    _getCalendarDataSource();
  }

  _getCalendarDataSource() {
    List<Appointment> appointment = <Appointment>[];

    appointment.add(Appointment(
        startTime: DateTime(2022, 06, 27),
        endTime: DateTime(2022, 06, 27),
        subject: "meeting",
        isAllDay: false));

    _dataSource = MeetingDataSource(appointment);
  }

  Widget monthCellBuilder(BuildContext context, MonthCellDetails details) {
    return Column(
      children: [
        Container(
          child: Text(details.date.day.toString()),
        ),
        Container(
          child: IconButton(
            icon: Icon(Icons.date_range),
            onPressed: () {},
          ),
        )
      ],
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
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
                Container(
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
              backgroundColor: Colors.white,
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
                String month = DateFormat.MMMM().format(detail.date!);
                DateTime now = DateTime.now();
                String currentmonth = DateFormat.MMMM().format(DateTime.now());
                if (DateFormat.MMMM().format(detail.date!) ==
                        DateFormat.MMMM().format(DateTime.now()) ||
                    DateFormat.MMMM().format(detail.date!) ==
                        DateFormat.MMMM().format(
                            DateTime(now.year, now.month + 1, now.day))) {
                  setState(() {
                    _openPopup(context, detail.date);
                  });
                } else {
                  showAlertDialog(context);
                }
              },
              monthViewSettings: const MonthViewSettings(
                appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
                showAgenda: false,
                agendaItemHeight: 70,
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Color(0xfff3f3f1),
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: _appointmentDetails.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 100,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x51424040),
                              blurRadius: 3.0,
                              spreadRadius: 0.5,
                              offset: Offset(
                                  1.5, 1.5), // shadow direction: bottom right
                            )
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(15, 7, 10, 7),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _appointmentDetails[index].subject,
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
                                            Icons.calendar_today,
                                            color: Colors.grey,
                                          ),
                                          fit: BoxFit.fill)),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    '${DateFormat('hh:mm').format(_appointmentDetails[index].startTime)}',
                                    style: TextStyle(
                                        fontFamily: "semibold",
                                        fontSize: 14,
                                        color: Color(0xff909089)),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "to",
                                    style: TextStyle(
                                        fontFamily: "regular",
                                        fontSize: 14,
                                        color: Colors.grey),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "'${DateFormat('hh:mm').format(_appointmentDetails[index].endTime)}'",
                                    style: TextStyle(
                                        fontFamily: "semibold",
                                        fontSize: 14,
                                        color: Color(0xff909089)),
                                  ),
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                child: Container(
                                  height: 0.5,
                                  width: MediaQuery.of(context).size.width,
                                  color: Colors.grey,
                                ),
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
                                  Text(
                                    "Akhuwat Head Office, Lahore",
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
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    ));
  }

  Widget monthhCellBuilder(BuildContext context, MonthCellDetails details) {
    var length = details.appointments.length;
    if (details.appointments.isNotEmpty) {
      return Container(
        child: Column(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  details.date.day.toString(),
                  textAlign: TextAlign.center,
                ),
                Divider(
                  color: Colors.transparent,
                ),
                Text(
                  '$length',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.deepPurple),
                ),
              ],
            )
          ],
        ),
      );
    }
    return Container(
      child: Text(
        details.date.day.toString(),
        textAlign: TextAlign.center,
      ),
    );
  }

  void calendarTappeded(CalendarTapDetails calendarTapDetails) {
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

  SharedPreferences? pref;
  late String eventTypevalue = "sdasd";
  late String eventPurposevalue = "s";
  String regionvalue = "Lahore";

  String areavalue = "Madhulal";
  String branchvalue = "0";

  int typeid = 0;
  int purposeid = 0;

  bool isVisible = false;
  bool isLocationVisible = false;

  List<Events> events = [];
  List<Purposes> purposes = [];

  List<Network> network = [];

  List<Areas> areaslist = [];

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
              // After selecting the desired option,it will
              // change button value to selected value
              onChanged: (String? newValue) async {
                eventTypevalue = newValue!;

                if (newValue == "1") {
                  isVisible = false;
                  isLocationVisible = false;
                } else if(newValue == "2") {
                  isVisible = true;
                  isLocationVisible = false;
                }
                else{
                  isVisible = false;
                  isLocationVisible = true;
                }
                final int index = events.indexWhere(
                    (element) => element.eventId == int.parse(newValue));

                List<DropdownMenuItem<String>> eventPurpose = [];
                for (int i = 0; i < events[index].purposes!.length; i++) {
                  eventPurpose.add(DropdownMenuItem(
                      child: Text(events[index].purposes![i].purposeName!),
                      value: events[index].purposes![i].purposeId!.toString()));
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

                  // Array list of items
                  items: _eventPurpose,
                  // After selecting the desired option,it will
                  // change button value to selected value
                  onChanged: (String? newValue) {
                    setState(() {

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

                  // Array list of items
                  items: _region,
                  // After selecting the desired option,it will
                  // change button value to selected value
                  onChanged: (String? newValue) => setState(() {
                    regionvalue = newValue!;
                    final int index = network.indexWhere(
                        (element) => element.id.toString() == newValue);
                    List<DropdownMenuItem<String>> eventPurpose = [];
                    for (int i = 0; i < network[index].areas!.length; i++) {
                      eventPurpose.add(DropdownMenuItem(
                          child: Text(network[index].areas![i].name!),
                          value: network[index].areas![i].id!.toString()));
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
                    // Array list of items
                    items: _area,
                    // After selecting the desired option,it will
                    // change button value to selected value
                    onChanged: (String? newValue) => setState(
                          () {
                            areavalue = newValue!;

                            final int index = areaslist.indexWhere(
                                (element) => element.id.toString() == newValue);
                            List<DropdownMenuItem<String>> eventPurpose = [];
                            for (int i = 0;
                                i < areaslist[index].branches!.length;
                                i++) {
                              eventPurpose.add(DropdownMenuItem(
                                  child:
                                      Text(areaslist[index].branches![i].name!),
                                  value: areaslist[index]
                                      .branches![i]
                                      .id
                                      .toString()));
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

        Data data = getDataResponceFromJson(json);
        events = data.events!;
        network = data.network!;
        eventTypevalue = events[0].eventNameLabel!;
        for (int i = 0; i < events.length; i++) {
          _eventTypes.add(DropdownMenuItem(
              child: Text(events[i].eventNameLabel!),
              value: events[i].eventId.toString()!));
        }

        for (int i = 0; i < events[0].purposes!.length; i++) {
          _eventPurpose.add(DropdownMenuItem(
              child: Text(events[0].purposes![i].purposeName!),
              value: events[0].purposes![i].purposeId!.toString()));
        }
        regionvalue = network[0].name!;
        areavalue = network[0].areas![0].name!;
        for (int i = 0; i < network.length; i++) {
          _region.add(DropdownMenuItem(
              child: Text(network[i].name!), value: network[i].id!.toString()));
        }
      });
    } catch (e) {}
  }
}
