import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:plannerapp/src/apis/ApiService%20.dart';
import 'package:plannerapp/src/initialscrrens/HomeScreen.dart';
import 'package:plannerapp/src/models/ChangedPlanRequest.dart';
import 'package:plannerapp/src/models/Dashboard_Responce.dart';
import 'package:plannerapp/src/screens/ExecutionList.dart';
import 'package:plannerapp/src/screens/PlannedScreen.dart';
import 'package:plannerapp/style/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/ApiConstants.dart';
import '../../utils/Prefrences.dart';
import '../../utils/alertdialogue.dart';
import '../models/Execution_List_Responce.dart';
import '../models/FeedBackSubmission.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Timer? _timer;
  final ImagePicker _picker = ImagePicker();
  late PickedFile? _imageFile = null;

  late String name;
  late String designation;
  late Dashboard_Responce responce;

   String image = "";

  @override
  void initState() {
    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });

    getPrefrences();

    submittFormData();

    submittChangedPlanData();
    getList(context);
    getDashboard(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
            child: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 70),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/img/bg.jpg'), fit: BoxFit.fill),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Scaffold.of(context).openDrawer();
                          },
                          child: Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: new BorderRadius.only(
                                  topLeft: const Radius.circular(7.0),
                                  bottomLeft: const Radius.circular(7.0),
                                  topRight: const Radius.circular(7.0),
                                  bottomRight: const Radius.circular(7.0)),
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(0, 0),
                                  blurRadius: 2,
                                  spreadRadius: 2,
                                  color: Color(0x79cdcdd0),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Container(
                                height: 15,
                                width: 15,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage('assets/img/menu.png',), fit: BoxFit.fill),
                                ),
                              ),
                            )
                          ),
                        ),

                        imageProfile(),
                        // Container(
                        //   height: 80,
                        //   width: 80,
                        //   decoration: BoxDecoration(
                        //     shape: BoxShape.circle,
                        //     image: DecorationImage(
                        //         image: AssetImage('assets/img/shape.png'),
                        //         fit: BoxFit.fill),
                        //   ),
                        //
                        // ),
                        Container(
                          height: 35,
                          width: 35,

                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),

                  Container(
                    child: Text(
                      "$name",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          fontSize: 22),
                    ),
                  ),

                  Container(
                    child: Text(
                      "$designation",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: AppColors.greenText,
                          fontSize: 18),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => const PlannedScreen()),
                            // );
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width / 2 - 20,
                            height: 135,
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 23, 0, 0),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2 - 20,
                                    height: 140,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image:
                                              AssetImage('assets/img/card_bg.png'),
                                          fit: BoxFit.fill),
                                      border: Border.all(color: Colors.white),
                                      borderRadius: new BorderRadius.only(
                                          topLeft: const Radius.circular(10.0),
                                          bottomLeft: const Radius.circular(10.0),
                                          topRight: const Radius.circular(10.0),
                                          bottomRight: const Radius.circular(10.0)),
                                      boxShadow: [
                                        BoxShadow(
                                          offset: Offset(0, 0),
                                          blurRadius: 2,
                                          spreadRadius: 2,
                                          color: Color(0x79cdcdd0),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                                  child: Container(
                                    height: 45,
                                    width: 45,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.green),
                                    child: Center(
                                        child:
                                            Image.asset('assets/img/calendar.png')),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 55, 15, 15),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${responce.data!.eventSummary!.visitPlanned}",
                                        style: TextStyle(
                                            fontSize: 26,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Visits Planned",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.greenText),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {

                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width / 2 - 20,
                            height: 135,
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 23, 0, 0),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2 - 20,
                                    height: 140,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image:
                                              AssetImage('assets/img/card_bg.png'),
                                          fit: BoxFit.fill),
                                      border: Border.all(color: Colors.white),
                                      borderRadius: new BorderRadius.only(
                                          topLeft: const Radius.circular(10.0),
                                          bottomLeft: const Radius.circular(10.0),
                                          topRight: const Radius.circular(10.0),
                                          bottomRight: const Radius.circular(10.0)),
                                      boxShadow: [
                                        BoxShadow(
                                          offset: Offset(0, 0),
                                          blurRadius: 2,
                                          spreadRadius: 2,
                                          color: Color(0x79cdcdd0),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                                  child: Container(
                                    height: 45,
                                    width: 45,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.green),
                                    child: Center(
                                        child:
                                            Image.asset('assets/img/planned.png')),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 55, 15, 15),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${responce.data!.eventSummary!.visitsExecuted}",
                                        style: TextStyle(
                                            fontSize: 26,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Visits Executed",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.greenText),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => const ExecutionList()),
                            // );
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width / 2 - 20,
                            height: 135,
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 23, 0, 0),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2 - 20,
                                    height: 140,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image:
                                              AssetImage('assets/img/card_bg.png'),
                                          fit: BoxFit.fill),
                                      border: Border.all(color: Colors.white),
                                      borderRadius: new BorderRadius.only(
                                          topLeft: const Radius.circular(10.0),
                                          bottomLeft: const Radius.circular(10.0),
                                          topRight: const Radius.circular(10.0),
                                          bottomRight: const Radius.circular(10.0)),
                                      boxShadow: [
                                        BoxShadow(
                                          offset: Offset(0, 0),
                                          blurRadius: 2,
                                          spreadRadius: 2,
                                          color: Color(0x79cdcdd0),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                                  child: Container(
                                    height: 45,
                                    width: 45,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.green),
                                    child: Center(
                                        child:
                                            Image.asset('assets/img/pending.png')),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 55, 15, 15),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${responce.data!.eventSummary!.visitPending}",
                                        style: TextStyle(
                                            fontSize: 26,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Visits Pending",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.greenText),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {

                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width / 2 - 20,
                            height: 135,
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 23, 0, 0),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2 - 20,
                                    height: 140,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image:
                                              AssetImage('assets/img/card_bg.png'),
                                          fit: BoxFit.fill),
                                      border: Border.all(color: Colors.white),
                                      borderRadius: new BorderRadius.only(
                                          topLeft: const Radius.circular(10.0),
                                          bottomLeft: const Radius.circular(10.0),
                                          topRight: const Radius.circular(10.0),
                                          bottomRight: const Radius.circular(10.0)),
                                      boxShadow: [
                                        BoxShadow(
                                          offset: Offset(0, 0),
                                          blurRadius: 2,
                                          spreadRadius: 2,
                                          color: Color(0x79cdcdd0),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                                  child: Container(
                                    height: 45,
                                    width: 45,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.green),
                                    child: Center(
                                        child:
                                            Image.asset('assets/img/leaves.png')),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 55, 15, 15),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${responce.data!.eventSummary!.leaves}",
                                        style: TextStyle(
                                            fontSize: 26,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Total Leaves",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.greenText),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 20, 15, 15),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Today's Plan",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontSize: 28),
                      ),
                    ),
                  ),

                  Expanded(
                    child: Container(
                      height: 300,
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: responce.data!.plans!.length,
                        itemBuilder: (context, index) {
                          Color bg = Colors.amber;
                          if (responce.data!.plans![index].event == "Disbursement") {
                            bg = AppColors.bgBlue;
                          } else if (responce.data!.plans![index].event == "Meeting") {
                            bg = AppColors.bgGreen;
                          } else {
                            bg = AppColors.bgYellow;
                          }
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                            child: Container(
                              height: 70,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: bg,
                                borderRadius: new BorderRadius.only(
                                    topLeft: const Radius.circular(10.0),
                                    bottomLeft: const Radius.circular(10.0),
                                    topRight: const Radius.circular(10.0),
                                    bottomRight: const Radius.circular(10.0)),
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(0, 0),
                                    blurRadius: 2,
                                    spreadRadius: 2,
                                    color: Color(0x79cdcdd0),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 10, 15, 15),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${responce.data!.plans![index].event}",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                                height: 15,
                                                width: 15,
                                                decoration: BoxDecoration(),
                                                child: FittedBox(
                                                    child: Icon(
                                                      Icons.calendar_today,
                                                      color: Colors.white,
                                                    ),
                                                    fit: BoxFit.fill)),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "${responce.data!.plans![index].plannedOn}",
                                              style: TextStyle(
                                                  fontFamily: "semibold",
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w300,
                                                  color: Colors.white),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Container(
                                                height: 15,
                                                width: 15,
                                                decoration: BoxDecoration(),
                                                child: FittedBox(
                                                    child: Icon(
                                                      Icons.location_on,
                                                      color: Colors.white,
                                                    ),
                                                    fit: BoxFit.fill)),
                                            Text(
                                              "${responce.data!.plans![index].eventPurpose}",
                                              style: TextStyle(
                                                  fontFamily: "regular",
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.white),
                                            ),
                                          ],
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
        ),
      ),
          )),
    );
  }

  void getPrefrences() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();

      setState(() {
        image  = pref.getString(PrefrenceConst.image) == null ? "" : pref.getString(PrefrenceConst.image)!.replaceAll("\"", "")!;
        name = pref.getString(PrefrenceConst.userName)!;
        designation = pref.getString(PrefrenceConst.userDesignation)!;
      });
    } catch (e) {}
  }

  Widget imageProfile() {
    return
      Container(
        height: 79,
        width: 82,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
              image: AssetImage('assets/img/shape.png'), fit: BoxFit.fill),
        ),
        child: Center(
          child: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  useRootNavigator: true,
                  context: context,
                  builder: ((builder) => bottomSheet()),
                );
              },
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 3, 8, 0),
                  child: CircleAvatar(
                    radius: 34,
                    backgroundImage:  NetworkImage(image),
                  ),
                ),
              )
              // CircleAvatar(
              //   radius: 65.0,
              //
              //   backgroundImage: _imageFile == null
              //       ? Image.asset("assets/img/profileavatar").image
              //       : FileImage(File(_imageFile!.path)),
              // ),
              ),
        ));
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            "Choose Profile photo",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            TextButton.icon(
              icon: Icon(Icons.camera, color: Colors.grey),
              onPressed: () {
                takePhoto(ImageSource.camera);
              },
              label: Text(
                "Camera",
                style: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(
              width: 40,
            ),
            TextButton.icon(
              icon: Icon(
                Icons.image,
                color: Colors.grey,
              ),
              onPressed: () {
                takePhoto(ImageSource.gallery);
              },
              label: Text(
                "Gallery",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ])
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.getImage(
      source: source,
    );
    Navigator.of(context, rootNavigator: true).pop();
    final bytes = File(pickedFile!.path).readAsBytesSync();
    String base64Image = base64Encode(bytes);
    Map<String, String> body ={
      'image': base64Image,
    };
    ApiService().getImage(context, body);
    setState(() {
      // print (base64Image);
      _imageFile = pickedFile!;
    });
  }

  getDashboard(BuildContextcontext) async {
    EasyLoading.show(status: 'loading...');
    final prefs = await SharedPreferences.getInstance();

    String token = prefs.getString(PrefrenceConst.acessToken)!;
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.dashboard);
      var response = await http.get(url, headers: {
        "Accept": 'application/json',
        'Authorization': 'Bearer $token'
      });
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        setState(() {
          responce = getDashboardResponceFromJson(response.body);
        });
      } else {
        EasyLoading.dismiss();
        AlertDialogue().showAlertDialog(
            context, "Alert Dialogue", response.body.toString());
      }
    } catch (e) {
      EasyLoading.dismiss();
      String error = e.toString();
      if(error.contains("Connection failed")){
        AlertDialogue().showAlertDialog(context, "Alert Dialogue", "No internet connection");

      } else {
        AlertDialogue().showAlertDialog(context, "Alert Dialogue", "$error");
      }
    }
  }

  getList(BuildContext context) async {
    EasyLoading.show(status: 'loading...');
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(PrefrenceConst.acessToken)!;
    try {

      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.executedPlans);
      var response = await http.get(url, headers: {
        "Accept": 'application/json',
        'Authorization': 'Bearer $token'
      });
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        Execution_List_Responce _model = getExeListResponceFromJson(response.body);
        setState(() {
          prefs.setString(PrefrenceConst.executionList, response.body);
        });

      } else {
        EasyLoading.dismiss();
        AlertDialogue().showAlertDialog(context, "Alert Dialogue", response.body.toString());
      }
    } catch (e) {
      EasyLoading.dismiss();
      String error = e.toString();
      if(error.contains("Connection failed")){

      } else {
        AlertDialogue().showAlertDialog(context, "Alert Dialogue", "$error");
      }
    }
  }

  submittFormData() async{
    final prefs = await SharedPreferences.getInstance();
    if(prefs.getString(PrefrenceConst.feedback) != ""){
      FeedBackSubmission submission = feedbackResponceFromJson(prefs.getString(PrefrenceConst.feedback)!);
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
        submittForm(context, submission.toJson());
      }
    } else {

    }


  }

  submittForm(BuildContext context, Map body ) async {
    EasyLoading.show(status: 'loading...');
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(PrefrenceConst.acessToken)!;


    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.postFeedback);
      var response = await http.post(url, headers: {
        "Accept": 'application/json',
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      }, body: jsonEncode(body));
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        setState(() async {
          final prefs = await SharedPreferences.getInstance();
          prefs.setString(PrefrenceConst.feedback, "");
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
      if(error.contains("Connection failed")){

      } else {
        AlertDialogue().showAlertDialog(context, "Alert Dialogue", "$error");
      }
    }
  }

  submittChangedPlanData() async {
    final prefs = await SharedPreferences.getInstance();
    if(prefs.getString(PrefrenceConst.replaceEventPlusFeedback) != ""){
      ChangedPlanRequest request = changeplanResponceFromJson(prefs.getString(PrefrenceConst.replaceEventPlusFeedback)!);
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile) {
        submittChangedPlan(context, request.toJson());
      } else if (connectivityResult == ConnectivityResult.wifi) {
        submittChangedPlan(context, request.toJson());




      }
    } else {

    }

  }


  submittChangedPlan(BuildContext context, Map body ) async {
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
        setState(()  {
          prefs.setString(PrefrenceConst.replaceEventPlusFeedback, "");

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
      if(error.contains("Connection failed")){

      } else {
        AlertDialogue().showAlertDialog(context, "Alert Dialogue", "$error");
      }
    }
  }
}
