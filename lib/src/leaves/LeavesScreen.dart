import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../initialscrrens/HomeScreen.dart';

class LeavesScreen extends StatefulWidget {
  const LeavesScreen({Key? key}) : super(key: key);

  @override
  _LeavesScreenState createState() => _LeavesScreenState();
}

class _LeavesScreenState extends State<LeavesScreen> with SingleTickerProviderStateMixin {

  late TabController _controller;
  int _selectedIndex = 0;



  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 3, vsync: this);
   // /
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [

                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: DefaultTabController(
                    length: 3,
                    child:Column(
                      children: [
                        Padding(
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
                                  "Leaves",
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
                        Container(
                          height: 1,
                          width: MediaQuery.of(context).size.width,
                          color: Color(0x759e9e9e),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                          child: TabBar(
                            controller: _controller,
                            indicatorColor: Color(0xff96C949),
                            tabs: [
                              Container(height: 40 , child: Column( mainAxisAlignment: MainAxisAlignment.center,children: [
                                Text("Pending" ,textAlign: TextAlign.center, style: TextStyle(

                                ),),
                              ],),),

                              Container(height: 40 , child: Column( mainAxisAlignment: MainAxisAlignment.center,children: [
                                Text("Approved", textAlign: TextAlign.center, style: TextStyle(

                                ),),
                              ],),),

                              Container(height: 40, child: Column( mainAxisAlignment: MainAxisAlignment.center,children: [
                                Text("Rejected", textAlign: TextAlign.center,style: TextStyle(

                                ),),
                              ],),)
                            ],
                            labelColor: Colors.black,
                            unselectedLabelColor: Colors.grey,
                          ),
                        ),
                      ],
                    ),


                  ),


                ),
                Container(
                  height: 8,
                  width: MediaQuery.of(context).size.width,
                  color: Color(0xffDCDCDC),
                ),
                Expanded(child: TabBarView(
                  controller: _controller,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Container(
                          decoration: BoxDecoration(

                            image: DecorationImage(
                                image: AssetImage('assets/img/bg.jpg'), fit: BoxFit.fill),
                          ),
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: 10,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: GestureDetector(
                                  onTap: () {
                                  },
                                  child: Container(

                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.4),
                                    ),
                                    child: Wrap(
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(20, 7, 20, 0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Disbursement",
                                                    style: TextStyle(
                                                        fontFamily: "bold",
                                                        fontSize: 22,
                                                        color: Colors.black),
                                                  ),

                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 6,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                              child: Row(
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
                                                    "July 30,2022",
                                                    style: TextStyle(
                                                        fontFamily: "semibold",
                                                        fontSize: 14,
                                                        color: Color(0xff909089)),
                                                  ),


                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                              const EdgeInsets.fromLTRB(0, 10, 0, 7),
                                              child: Container(
                                                height: 0.5,
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
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Container(
                          decoration: BoxDecoration(

                            image: DecorationImage(
                                image: AssetImage('assets/img/bg.jpg'), fit: BoxFit.fill),
                          ),
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: 10,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: GestureDetector(
                                  onTap: () {
                                  },
                                  child: Container(

                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.4),
                                    ),
                                    child: Wrap(
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(20, 7, 20, 0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Disbursement",
                                                    style: TextStyle(
                                                        fontFamily: "bold",
                                                        fontSize: 22,
                                                        color: Colors.black),
                                                  ),

                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 6,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                              child: Row(
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
                                                    "July 30,2022",
                                                    style: TextStyle(
                                                        fontFamily: "semibold",
                                                        fontSize: 14,
                                                        color: Color(0xff909089)),
                                                  ),


                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                              const EdgeInsets.fromLTRB(0, 10, 0, 7),
                                              child: Container(
                                                height: 0.5,
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
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Container(
                          decoration: BoxDecoration(

                            image: DecorationImage(
                                image: AssetImage('assets/img/bg.jpg'), fit: BoxFit.fill),
                          ),
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: 10,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: GestureDetector(
                                  onTap: () {
                                  },
                                  child: Container(

                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.4),
                                    ),
                                    child: Wrap(
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(20, 7, 20, 0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Disbursement",
                                                    style: TextStyle(
                                                        fontFamily: "bold",
                                                        fontSize: 22,
                                                        color: Colors.black),
                                                  ),

                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 6,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                              child: Row(
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
                                                    "July 30,2022",
                                                    style: TextStyle(
                                                        fontFamily: "semibold",
                                                        fontSize: 14,
                                                        color: Color(0xff909089)),
                                                  ),


                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                              const EdgeInsets.fromLTRB(0, 10, 0, 7),
                                              child: Container(
                                                height: 0.5,
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
                    ),
                  ],
                ),)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
