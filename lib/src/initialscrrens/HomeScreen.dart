import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plannerapp/src/initialscrrens/Drawer.dart';
import 'package:plannerapp/src/screens/DashboardScreen.dart';
import 'package:plannerapp/src/screens/PlannedScreen.dart';
import 'package:plannerapp/utils/Prefrences.dart';

import '../screens/ApprovalList.dart';
import '../screens/CreatePlan.dart';
import '../screens/ExecutionList.dart';


class HomeScreen extends StatefulWidget {


  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentTab = 0;
  late String name;
  late String designation;
  final PageStorageBucket pageStorageBucket = PageStorageBucket();
  Widget currentScreen = DashboardScreen();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      drawer: DrawerScreen(),
      body: PageStorage(
        child: currentScreen,
        bucket: pageStorageBucket,
      ),
      floatingActionButton: FloatingActionButton(
        child:  Image.asset('assets/img/create.png', ),
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreatePlan()),
          );
        },

      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        shape: CircularNotchedRectangle(),
        notchMargin: 8,
        child: Container(

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20), topLeft: Radius.circular(20)),

          ),
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    minWidth: 40,
                    onPressed: (){
                      setState(() {
                        currentScreen = DashboardScreen();
                        currentTab = 0;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: Container(
                            height: 22,
                            width: 22,
                            child: Center(
                              child: Image.asset('assets/img/home.png', )
                            ),
                          ),
                        ),
                        // Text(
                        //   "Home",
                        //   style: TextStyle(
                        //       color: currentTab == 0 ? Colors.blue : Colors.grey
                        //   ),
                        // )
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: (){
                      setState(() {
                        currentScreen = PlannedScreen();
                        currentTab = 1;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: Container(
                            height: 22,
                            width: 22,
                            child: Center(
                                child: Image.asset('assets/img/plans.png')
                            ),
                          ),
                        ),
                        // Text(
                        //   "Planned \nVisits",
                        //   textAlign: TextAlign.center,
                        //   style: TextStyle(
                        //       color: currentTab == 1 ? Colors.blue : Colors.grey
                        //   ),
                        // )
                      ],
                    ),
                  )
                ],
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(10, 20, 0, 0),
                child: Text("Create Plan",
                style: TextStyle(
                  fontWeight: FontWeight.w500
                ),),
              ),
              //right tab
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    minWidth: 40,
                    onPressed: (){
                      setState(() {
                        currentScreen = ExecutionList();
                        currentTab = 2;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: Container(
                            height: 22,
                            width: 22,
                            child: Center(
                                child: Image.asset('assets/img/executed.png')
                            ),
                          ),
                        ),
                        // Text(
                        //   "Execution\nList",
                        //   textAlign: TextAlign.center,
                        //
                        //   style: TextStyle(
                        //       color: currentTab == 2 ? Colors.blue : Colors.grey
                        //   ),
                        // )
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: (){
                      setState(() {
                        currentScreen = ApprovalList();
                        currentTab = 3;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: Container(
                            height: 22,
                            width: 22,
                            child: Center(
                                child: Image.asset('assets/img/executed.png')
                            ),
                          ),
                        ),
                        // Text(
                        //   "Approval\nList",
                        //   textAlign: TextAlign.center,
                        //
                        //   style: TextStyle(
                        //       color: currentTab == 3 ? Colors.blue : Colors.grey
                        //   ),
                        // )
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }


}
