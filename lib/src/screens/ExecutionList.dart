import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plannerapp/src/initialscrrens/HomeScreen.dart';
import 'package:plannerapp/src/models/Execution_List_Responce.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../utils/ApiConstants.dart';
import '../../utils/Prefrences.dart';
import '../../utils/alertdialogue.dart';


class ExecutionList extends StatefulWidget {
  const ExecutionList({Key? key}) : super(key: key);

  @override
  _ExecutionListState createState() => _ExecutionListState();
}

class _ExecutionListState extends State<ExecutionList> {

  late Execution_List_Responce responce;
  late String  formatteddate;

  @override
  void initState() {
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
     formatteddate = formatter.format(now);
     // getList();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: new FloatingActionButton(
      //   onPressed: () {
      //     _openPopup(context);
      //   },
      //   backgroundColor: Colors.grey,
      //   child: const Icon(Icons.add),
      // ),
      // floatingActionButtonLocation:
      // FloatingActionButtonLocation.endFloat,



      body: SafeArea(
        child: Column(
          children: [

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
                        "Execution List",
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
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(0,0,0,0),
                      child: GestureDetector(
                        onTap: () {
                          _samePopup(context);
                        },
                        child: Container(

                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.6),

                          ),
                          child: Wrap(
                            children: [
                              Column(

                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(15, 7, 10, 7),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Disbursement",
                                              style: TextStyle(
                                                  fontFamily: "bold",
                                                  fontSize: 22,
                                                  color: Colors.black),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "Status: ",
                                                  style: TextStyle(
                                                      fontFamily: "semibold",
                                                      fontSize: 17,
                                                      color: Colors.black),
                                                ),
                                                Text(
                                                  "pending",
                                                  style: TextStyle(
                                                      fontFamily: "medium",
                                                      fontSize: 17,
                                                      color: Colors.green),
                                                ),
                                              ],
                                            )
                                          ],
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

                                        // Padding(
                                        //   padding:
                                        //   const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                        //   child: Container(
                                        //     height: 0.5,
                                        //     width: MediaQuery.of(context).size.width,
                                        //     color: Colors.grey,
                                        //   ),
                                        // ),
                                        SizedBox(height: 5,),
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

                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                    child: Container(
                                      height: 1,
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
          ],
        ),
      ),

    );
  }


  getList(Map<String, String> body, BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(PrefrenceConst.acessToken)!;
    try {

      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.executedPlans);
      var response = await http.get(url, headers: {
        "Accept": 'application/json',
        'Authorization': 'Bearer $token'
      });
      if (response.statusCode == 200) {
        Execution_List_Responce _model = getExeListResponceFromJson(response.body);
        setState(() {
          responce = _model;
        });

      } else {
        AlertDialogue().showAlertDialog(context, "Alert Dialogue", response.body.toString());
      }
    } catch (e) {
      String error = e.toString();
      AlertDialogue().showAlertDialog(context, "Alert Dialogue", "$error");

    }
  }

  _samePopup(
      BuildContext context){
    AlertDialog alert = AlertDialog(

      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)),
      title: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(0),
              bottomRight: Radius.circular(0),topRight: Radius.circular(20)),
          color: Colors.black12,
        ),
        height: 60,

        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(alignment: Alignment.centerLeft,    child: Text('Execution')),
              Text(formatteddate,
                style: TextStyle(
                    color: Colors.green
                ),),
            ],
          ),
        ),
      ),

      content: Wrap(
        children: [
          Container(
            width:  MediaQuery. of(context). size. width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5,),


                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Type: ",
                      style: TextStyle(
                          color: Colors.black
                      ),),
                    Text("Disbursement Cermony",
                      style: TextStyle(
                          color: Colors.green
                      ),),
                  ],
                ),
                SizedBox(height: 10,),

                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Reason: ",
                      style: TextStyle(
                          color: Colors.black
                      ),),
                    Text("Disbursement of Loans",
                      style: TextStyle(
                          color: Colors.green
                      ),),
                  ],
                ),
                SizedBox(height: 10,),

                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Region: ",
                      style: TextStyle(
                          color: Colors.black
                      ),),
                    Text("Lahore",
                      style: TextStyle(
                          color: Colors.green
                      ),),
                  ],
                ),
                SizedBox(height: 10,),

                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Area: ",
                      style: TextStyle(
                          color: Colors.black
                      ),),
                    Text("HeadOffice",
                      style: TextStyle(
                          color: Colors.green
                      ),),
                  ],
                ),
                SizedBox(height: 10,),

                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Branch: ",
                      style: TextStyle(
                          color: Colors.black
                      ),),
                    Text("HeadOffice",
                      style: TextStyle(
                          color: Colors.green
                      ),),
                  ],
                ),
                SizedBox(height: 10,),

                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Approved By: ",
                      style: TextStyle(
                          color: Colors.black
                      ),),
                    Text("Regional Cordinator",
                      style: TextStyle(
                          color: Colors.green
                      ),),
                  ],
                ),
                SizedBox(height: 20,),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap : (){
                        Navigator.of(context, rootNavigator: true).pop('dialog');},
                      child: Container(
                        width: 90,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              width: 1,
                              color: Colors.black12//                   <--- border width here
                          ),
                        ),
                        child: Center(
                          child: Text("Cancel"),
                        ),
                      ),
                    ),

                    SizedBox(width: 10,),

                    GestureDetector(
                      onTap : (){
                        Navigator.of(context, rootNavigator: true).pop('dialog');},
                      child: Container(
                        width: 90,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.green,
                          border: Border.all(
                              width: 1,
                              color: Colors.black12//                   <--- border width here
                          ),
                        ),
                        child: Center(
                          child: Text("Schedule",
                            style: TextStyle(
                                color: Colors.white
                            ),),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],

      ),
      titlePadding: const EdgeInsets.all(0),
    );


    showDialog(context: context,
      builder: (BuildContext context) {
        return alert;
      },);
  }
}
