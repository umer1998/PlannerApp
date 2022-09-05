
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:plannerapp/src/apis/ApiService%20.dart';
import 'package:plannerapp/src/initialscrrens/Drawer.dart';
import 'package:plannerapp/src/screens/DashboardScreen.dart';
import 'package:plannerapp/src/screens/PlannedScreen.dart';
import 'package:plannerapp/style/colors.dart';
import 'package:plannerapp/utils/Prefrences.dart';
import 'package:plannerapp/utils/alertdialogue.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../utils/ApiConstants.dart';
import '../leaves/LeavesScreen.dart';
import '../models/Leaves_Response.dart';
import '../screens/ApprovalList.dart';
import '../screens/CreatePlan.dart';
import '../screens/ExecutionList.dart';
import '../screens/SplashScreen.dart';


class HomeScreen extends StatefulWidget {


  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  late Leaves_Response leaves_response ;
  late String designation;
  late String name = "";
  late PersistentTabController _controller;
  late bool _hideNavBar;
  var testContext;
  int _selectedDestination = 0;
  List<Data> pendingList= [];
  List<Data> approvedList= [];
  List<Data> rejectedList= [];
  @override
  void initState() {
    super.initState();
    getLeavesResponse();
    getPrefrences();
    ApiService().getConfiguration(context);
    setState(() {
      _controller = PersistentTabController(initialIndex: 0);
    });
    _hideNavBar = false;
  }


  List<Widget> _buildScreens() {

    if(designation == "AM"){

      return [
        DashboardScreen(),
        PlannedScreen(),
        CreatePlan(
        ),
        ExecutionList(),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: Text("You are not allowed to perform this action ."),
          ),
        )

      ];
    } else {

      return [
        DashboardScreen(),
        PlannedScreen(),
        CreatePlan(),
        ExecutionList(),
        ApprovalList(),

      ];
    }

  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
      return [
        PersistentBottomNavBarItem(
          icon: Icon(Icons.home_filled , size: 25,),

          title: "DashBoard",
          activeColorPrimary: AppColors.greenText,
          inactiveColorPrimary: Colors.grey,

        ),
        PersistentBottomNavBarItem(
          icon: Icon(Icons.list , size: 25,),

          title: ("Planning"),
          activeColorPrimary: AppColors.greenText,
          inactiveColorPrimary: Colors.grey,

        ),
        PersistentBottomNavBarItem(
          icon: Icon(Icons.add, color: Colors.white,),
          title: ("Create"),
          activeColorPrimary: AppColors.greenText,
          activeColorSecondary: Colors.white,
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Icons.playlist_add_check_rounded , size: 25,),

          title: ("Execution"),
          activeColorPrimary: AppColors.greenText,
          inactiveColorPrimary: Colors.grey,

        ),
        PersistentBottomNavBarItem(
          icon: Icon(Icons.article_outlined , size: 25,),
          title: ("Approval"),
          activeColorPrimary: AppColors.greenText,
          inactiveColorPrimary: Colors.grey,

        ),

      ];

  }



  @override
  Widget build(BuildContext context) {

    return  Scaffold(

      drawer:    Drawer(
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
      body:  PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: Colors.white,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        navBarHeight: MediaQuery.of(context).viewInsets.bottom > 0
            ? 0.0
            : kBottomNavigationBarHeight,
        hideNavigationBarWhenKeyboardShows: true,
        margin: EdgeInsets.all(0.0),
        popActionScreens: PopActionScreensType.all,
        bottomScreenMargin: 0.0,
        selectedTabScreenContext: (context) {
          testContext = context;
        },
        hideNavigationBar: _hideNavBar,
        decoration: NavBarDecoration(
          colorBehindNavBar: Colors.indigo,
          borderRadius: new BorderRadius.only(
            topLeft: const Radius.circular(20.0),

            topRight: const Radius.circular(20.0),
          ),),
        popAllScreensOnTapOfSelectedTab: true,
        itemAnimationProperties: ItemAnimationProperties(
          duration: Duration(milliseconds: 400),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimation(
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle:
        NavBarStyle.style17, // Choose the nav bar style with this property
      ),

    );
  }

  void getPrefrences() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();

      setState(() {

        designation = pref.getString(PrefrenceConst.userDesignation)!;
        name = pref.getString(PrefrenceConst.userName)!;
      });
    } catch (e) {}
  }
  Future<void> selectDestination(int index) async {

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

        Navigator.of(context).pop();
        _controller.jumpToTab(0);
      }
      else if(_selectedDestination == 1){

        Navigator.of(context).pop();
        _controller.jumpToTab(1);
      }
      else if(_selectedDestination == 2){
        Navigator.of(context).pop();
        _controller.jumpToTab(3);
      }
      else if(_selectedDestination == 3){

        if(designation == "AM"){

        } else {

          Navigator.of(context).pop();
          _controller.jumpToTab(4);
        }

      }

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
