
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plannerapp/src/leaves/LeavesScreen.dart';
import 'package:plannerapp/src/screens/ApprovalList.dart';
import 'package:plannerapp/src/screens/DashboardScreen.dart';
import 'package:plannerapp/src/screens/ExecutionList.dart';
import 'package:plannerapp/src/screens/PlannedScreen.dart';
import 'package:plannerapp/src/screens/SplashScreen.dart';
import 'package:plannerapp/utils/Prefrences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../utils/ApiConstants.dart';
import '../../utils/alertdialogue.dart';
import '../models/Leaves_Response.dart';



class DrawerScreen extends StatefulWidget {
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  _DrawerState createState() => _DrawerState();
}

class _DrawerState extends State<DrawerScreen> {

  late Leaves_Response leaves_response ;
  late String name = "";
  late String designation = "";
  List<Data> pendingList= [];
  List<Data> approvedList= [];
  List<Data> rejectedList= [];
  String image = "";

  @override
  void initState() {
    getPrefrences();
    getLeavesResponse();
    super.initState();


  }

    int _selectedDestination = 0;
  var activeScreen = DashboardScreen();
  final ImagePicker _picker = ImagePicker();
  late PickedFile? _imageFile = null;

  @override
  Widget build(BuildContext context) {



    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return SafeArea(
      child: Row(
        children: [
          Drawer(
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: <Widget>[
                Container(
                  height: 250,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(

                    image: DecorationImage(
                      image: AssetImage(
                        'assets/img/drawershape.png',
                      ),
                      fit: BoxFit.fill,),
                  ),
                  child: Wrap(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap : (){
                                    Navigator.pop(context);
                                  },
                                  child: Icon(
                                    Icons.arrow_back_ios_outlined,
                                    size: 20,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                              height: 90,
                              width: 90,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("assets/img/person.png"),
                                    fit: BoxFit.fitHeight),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  // color: Color(0xffFEFEFE),
                                  width: 3,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Center(
                                  child: Text(
                                    "${name}",
                                    style: TextStyle(
                                        fontFamily: "semibold",
                                        fontSize: 18,
                                        color: Colors.black),
                                  ),
                                ),

                              ],
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                                "${designation}",
                              style: TextStyle(
                                  fontFamily: "regular",
                                  fontSize: 15,
                                  color: Colors.grey),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                ListTile(
                  leading: Image.asset('assets/img/home.png',height: 20, width: 20, color: Colors.grey, ),
                  title: Text('Home', style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: Color(0xff404042)
                  ),),
                  selected: _selectedDestination == 0,
                  onTap: () => selectDestination(0),
                ),
                ListTile(
                  leading: Image.asset('assets/img/executed.png',height: 20, width: 20,  color: Colors.grey,),
                  title: Text('Planned List', style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: Color(0xff404042)

                  ),),
                  selected: _selectedDestination == 1,
                  onTap: () => selectDestination(1),
                ),
                ListTile(
                  leading: Image.asset('assets/img/plans.png',height: 20, width: 20, color: Colors.grey, ),
                  title: Text('Executed List', style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: Color(0xff404042)

                  ),),
                  selected: _selectedDestination == 2,
                  onTap: () => selectDestination(2),
                ),
                ListTile(
                  leading: Image.asset('assets/img/approval.png',height: 20, width: 20, color: Colors.grey,  ),
                  title: Text('Approval List', style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: Color(0xff404042)
                  ),),
                  selected: _selectedDestination == 3,
                  onTap: () => selectDestination(3),
                ),
                ListTile(),
                Divider(
                  height: 1,
                  thickness: 1,
                ),
            ListTile(),

                ListTile(
                  leading: Icon(Icons.weekend , size: 20, color: Colors.grey,),
                  title: Text('Leaves List', style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: Color(0xff404042)
                  ),),
                  selected: _selectedDestination == 4,
                  onTap: () => selectDestination(4),
                ),
                ListTile(
                  leading: Icon(Icons.logout, size: 20, color: Colors.grey,),
                  title: Text('Logout', style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: Color(0xff404042)
                  ),),
                  selected: _selectedDestination == 5,
                  onTap: () => selectDestination(5),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }

  void selectDestination(int index) {
    setState(() async {
      _selectedDestination = index;
      if(_selectedDestination == 4){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  LeavesScreen(pendingList : pendingList, approvedList: approvedList, rejectedList: rejectedList)),
        );

      } else if(_selectedDestination == 5){

        SharedPreferences preferences = await SharedPreferences.getInstance();
        await preferences.clear();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SplashScreen()),
        );
      } else if(_selectedDestination == 0){


        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      }
      else if(_selectedDestination == 1){


        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PlannedScreen()),
        );
      }
      else if(_selectedDestination == 2){


        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ExecutionList()),
        );
      }
      else if(_selectedDestination == 3){

        if(designation == "AM"){

        } else {

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ApprovalList()),
          );
        }

      }
    });
  }

  Widget imageProfile() {

    return Center(
      child: GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: ((builder) => bottomSheet()),
            );
          },
          child: Center(
            child: CircleAvatar(
              radius: 34,
              backgroundImage:  NetworkImage(image),
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
    );
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
              icon: Icon(Icons.camera,color: Colors.grey),
              onPressed: () {
                takePhoto(ImageSource.camera);
              },
              label: Text("Camera",
                style: TextStyle(
                    color: Colors.black
                ),),
            ),
            SizedBox(width: 40,),
            TextButton.icon(
              icon: Icon(Icons.image, color: Colors.grey,),
              onPressed: () {
                takePhoto(ImageSource.gallery);
              },
              label: Text("Gallery",
                style: TextStyle(
                    color: Colors.black
                ),),
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
    setState(() {
      _imageFile = pickedFile!;
      Navigator.pop(context);
    });
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
  getLeavesResponse() async {

    EasyLoading.show(status: 'loading...');
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(PrefrenceConst.acessToken)!;
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.getLeaves);
      var response = await http.get(url, headers: {
        "Accept": 'application/json',
        'Authorization': 'Bearer $token',
        "Content-Type": "application/json"
      });
      if (response.statusCode == 200) {
        EasyLoading.dismiss();

        print("success");
        setState(() {
          leaves_response = getleavesResponceFromJson(response.body);
          for(int i = 0; i< leaves_response.data!.length; i++){
            if(leaves_response.data![i].eventStatus == "pending"){
              pendingList.add(leaves_response.data![i]);
            } else if(leaves_response.data![i].eventStatus == "approved"){
              approvedList.add(leaves_response.data![i]);
            } else if(leaves_response.data![i].eventStatus == "rejected"){
              rejectedList.add(leaves_response.data![i]);
            }
          }

        });
      } else {
        print("error");
        EasyLoading.dismiss();
        AlertDialogue().showAlertDialog(
            context, "Alert Dialogue", response.body.toString());
      }
    } catch (e) {
      print("e");
      EasyLoading.dismiss();
      String error = e.toString();
      AlertDialogue().showAlertDialog(context, "Alert Dialogue", "$error");
    }

  }

}


