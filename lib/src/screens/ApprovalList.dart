import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../initialscrrens/HomeScreen.dart';

class ApprovalList extends StatefulWidget {
  const ApprovalList({Key? key}) : super(key: key);

  @override
  _ExecutionListState createState() => _ExecutionListState();
}

class _ExecutionListState extends State<ApprovalList> {

  String dropdownvalue = 'Item 1';
  var items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];
  late String  formatteddate;

  @override
  void initState() {
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    formatteddate = formatter.format(now);
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(




      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,

          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 20,
                color: Colors.white,
              ),

              Container(
                color: Colors.white,
                child: Padding(
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
                          "Requests",
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
              ),

              Container(
                height: 8,
                width: MediaQuery.of(context).size.width,
                color: Color(0x759e9e9e),
              ),

              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/img/bg.jpg'), fit: BoxFit.fill),
                  ),
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      return Container(
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
                                      Text("Muhammad Zubair",textAlign: TextAlign.start, style: TextStyle(
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

                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                        width: 90,
                                        height: 30,
                                        decoration: BoxDecoration(

                                          border: Border.all(
                                            color: Color(0x759e9e9e),
                                            style: BorderStyle.solid,
                                            width: 1,
                                          ),

                                          borderRadius: new BorderRadius.only(
                                              topLeft: const Radius.circular(20.0),
                                              bottomLeft: const Radius.circular(20.0),
                                              topRight: const Radius.circular(20.0),
                                              bottomRight: const Radius.circular(20.0)),
                                        ),
                                        child: Center(
                                          child: Text("See Plans",style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.grey
                                          ),),
                                        ),
                                      ),
                                    ),
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
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }


}
