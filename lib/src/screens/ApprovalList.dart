import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:plannerapp/src/models/Get_Managers.dart';
import 'package:plannerapp/src/screens/ApproveRejectList.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../utils/ApiConstants.dart';
import '../../utils/Prefrences.dart';
import '../../utils/alertdialogue.dart';
import '../initialscrrens/HomeScreen.dart';

class ApprovalList extends StatefulWidget {
  const ApprovalList({Key? key}) : super(key: key);

  @override
  _ExecutionListState createState() => _ExecutionListState();
}

class _ExecutionListState extends State<ApprovalList> {

  late Get_Managers get_managers;
  late String  formatteddate;

  @override
  void initState() {
    getReportingTeam(context);
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
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 70),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/img/bg.jpg'), fit: BoxFit.fill),
                    ),
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: get_managers.data!.length!,
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
                                        Text("${get_managers.data![index].fullname}",textAlign: TextAlign.start, style: TextStyle(
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
                                              "${get_managers.data![index].designation}",
                                              style: TextStyle(
                                                  fontFamily: "regular",
                                                  fontSize: 15,
                                                  color: Colors.grey),
                                            ),
                                          ],
                                        ),


                                      ],
                                    ),

                                    InkWell(
                                      onTap: (){
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) =>  ApproveReject(id : get_managers!.data![index].userId! , name: get_managers!.data![index].fullname!,)),
                                        );
                                      },
                                      child: Padding(
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
              ),
            ],
          ),
        ),
      ),

    );
  }

  getReportingTeam(BuildContext context) async {
    EasyLoading.show(status: 'loading...');
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(PrefrenceConst.acessToken)!;
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.getReportingTeam);
      var response = await http.get(url, headers: {
        "Accept": 'application/json',
        'Authorization': 'Bearer $token'
      });
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        setState(() {
          get_managers = getManagersResponceFromJson(response.body);
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
