import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:plannerapp/src/apis/ApiService%20.dart';
import 'package:plannerapp/src/models/Get_All_List.dart';
import 'package:plannerapp/src/popups/CreateEventInPlanningPopup.dart';
import 'package:plannerapp/src/popups/DeleteEventPopUp.dart';
import 'package:plannerapp/style/colors.dart';
import 'package:plannerapp/utils/MeetingDataSource.dart';
import 'package:plannerapp/utils/Prefrences.dart';
import 'package:plannerapp/utils/alertdialogue.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../utils/ApiConstants.dart';
import '../initialscrrens/HomeScreen.dart';
import '../models/Configurations.dart';
import '../models/CreateEvent_Responce.dart';
import '../popups/EditEventPopup.dart';

class CreatePlan extends StatefulWidget {
  const CreatePlan({Key? key}) : super(key: key);

  @override
  State<CreatePlan> createState() => _CreatePlanState();
}

class _CreatePlanState extends State<CreatePlan> {
  CalendarDataSource? _dataSource;
  String month = "";
  late Get_All_List getAllList ;
  late List<Plans> planList = [];
  Timer? _timer;
  bool addVisibility = false;
  DateTime dateTime = DateTime.now();
  List<Appointment> _appointmentDetails = <Appointment>[];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


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

    for(int i=0; i< getAllList.data!.events!.length; i++){
      DateTime dateTime = DateFormat('yyyy-MM-dd').parse(getAllList.data!.events![i].plannedOn!);

      String json = getdataallResponceInToJson(getAllList.data!.events![i]);
      appointment.add(Appointment(
        notes: json,
          startTime: DateFormat('yyyy-MM-dd').parse(getAllList.data!.events![i].plannedOn!),
          endTime: DateFormat('yyyy-MM-dd').parse(getAllList.data!.events![i].plannedOn!),
          subject: getAllList.data!.events![i].event!,
          isAllDay: false));
    }



    _dataSource = MeetingDataSource(appointment);
  }





  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 100),
        child: new FloatingActionButton(
          elevation: 0,
          child: new Icon(Icons.add, color: Colors.white,),
          backgroundColor: AppColors.bgGreen,
          onPressed: (){
            DateTime now = DateTime.now();
            String currentmonth = DateFormat.MMMM().format(DateTime.now());
            if (DateFormat.MMMM().format(dateTime!) ==
                DateFormat.MMMM().format(DateTime.now()) ||
                DateFormat.MMMM().format(dateTime!) ==
                    DateFormat.MMMM().format(
                        DateTime(now.year, now.month + 1, now.day))) {
              setState(() {

                final int index = planList.indexWhere(
                        (element) => element.plan == month);

                if(index >= 0 && planList[index].status == 1){

                  AlertDialogue().showAlertDialog(context, "Alert", "Not allowed to perform this action !");
                } else{
                  _openPopup(context, dateTime);
                }


              });
            } else {
              showAlertDialog(context);
            }
          },
        ),
      ),
        body: SafeArea(
          child : RefreshIndicator(
            onRefresh: () async {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const CreatePlan()),
              );
            },
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 150),
                child: Container(
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
                                  fontSize: 17,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            InkWell(
                              onTap: (){
                                Map<String, String> body ={
                                  'plan': month,
                                  'status': "3"
                                };
                                final int index = planList.indexWhere(
                                        (element) => element.plan == month);

                                if(index >= 0 && planList[index].status == 1){

                                  AlertDialogue().showAlertDialog(context, "Alert", "Not allowed to perform this action !");
                                } else{
                                  showConfirmationDialog(body, context, month);
                                }


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
                                height: 40,
                                width: 120,
                                child: Center(
                                  child: Text(
                                    "Submitt Plan for \n$month",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
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
                        height: 400,
                        child: SfCalendar(
                          viewHeaderHeight: 30,

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
                          headerHeight: 60,
                          headerStyle: CalendarHeaderStyle(
                              textStyle:
                              TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
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
                            appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
                            showAgenda: false,
                            agendaItemHeight: 70,
                            agendaViewHeight: 100
                          ),
                        ),
                      ),

                      Expanded(
                        child: Container(
                          height: _appointmentDetails.length * 60,
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
                                        final int index = planList.indexWhere(
                                                (element) => element.plan == month);

                                        if(index >= 0 && planList[index].status == 1){

                                          AlertDialogue().showAlertDialog(context, "Alert", "Not allowed to perform this action !");
                                        } else{

                                          _deleteEvent(context, body);



                                        }

                                      },

                                      ),


                                    ],
                                  ),
                                  child: InkWell(
                                    onTap: (){



                                      final int index = planList.indexWhere(
                                              (element) => element.plan == month);

                                      if(index >= 0 && planList[index].status == 1){

                                        AlertDialogue().showAlertDialog(context, "Alert", "Not allowed to perform this action !");
                                      } else{
                                        _editEventPopup(context,  data);
                                      }

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
              )
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
        children: [

          CreateEventInPlanningPopup(datee: datee, month: month)],
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
              Align(alignment: Alignment.centerLeft, child: Text('Edit Event')),
              SizedBox(
                height: 5,
              ),

            ],
          ),
        ),
      ),
      content: Wrap(
        children: [
          EditEvent(list: list)

        ],
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

  void showConfirmationDialog(Map<String, String> body, BuildContext context, String month) {
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
                      Navigator.of(context, rootNavigator: true).pop();

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
            Text("Are You Sure to Submitt Plan?", style: TextStyle(
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
                    Navigator.of(context, rootNavigator: true).pop();


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
                    Navigator.of(context, rootNavigator: true).pop();
                    ApiService().submitPlan(body, context, month);
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

  _deleteEvent(BuildContext context, Map<String, String> body) {

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
        children: [
          DeleteEventPopUp(body: body )

        ],
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
          planList = getAllList.data!.plans!;
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



}










