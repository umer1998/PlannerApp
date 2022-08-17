import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../../style/colors.dart';
import '../../utils/ApiConstants.dart';
import '../../utils/Prefrences.dart';
import '../../utils/alertdialogue.dart';
import '../initialscrrens/HomeScreen.dart';
import 'package:http/http.dart' as http;

import '../models/ChangedPlanRequest.dart';
import '../models/Configurations.dart';
import '../models/FeedBackSubmission.dart';


class ChangedPlanFormScreen extends StatefulWidget {
  const ChangedPlanFormScreen({Key? key, required this.eventPurpose, required this.event, required this.event_id, required this.newEvent,  }) : super(key: key);
  final String eventPurpose;
  final String event;
  final String event_id;
  final NewEvent newEvent;

  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<ChangedPlanFormScreen> {

  final Map textFieldMap = Map<String, String>();
  final Map radioMap = Map<String, String>();

  late List<FeedbackQuestionnaire> questionnaire =[];

  @override
  void initState() {

    setData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/img/bg.jpg'), fit: BoxFit.fill),
            ),
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.6)
              ),
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
                              "Questionaire",
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
                    height: 6,
                    width: MediaQuery.of(context).size.width,
                    color: Color(0x759e9e9e),
                  ),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: questionnaire.length,
                      itemBuilder: (context, index) {
                        if(questionnaire[index].type == "textfield"){
                          return Wrap(
                            children: [
                              DynamicTextField(
                                hint: questionnaire[index].question!, id: questionnaire[index].id!.toString() , textFieldMap: radioMap,)
                            ],
                          );
                        } else if(questionnaire[index].type == "radiobutton"){

                          return DynamicRadio(list: questionnaire[index].mcqs!, hint: questionnaire[index].question!, id: questionnaire[index].id!.toString(), radioMap: radioMap,);
                        } else {
                          return Center(
                            child: Text(""),
                          );
                        }

                      },
                    ),
                  ),

                  Center(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 15, 15, 30),
                      child: InkWell(
                        onTap: (){
                          saveData(radioMap);
                        },
                        child: Container(
                          height: 40,
                          width: 90,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                  bottomLeft: Radius.circular(30),
                                  bottomRight: Radius.circular(30)),
                              color: AppColors.greenText),
                          child: Center(
                            child: Text(
                              "Continue",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: "semibold",
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
        ),
      ),
    );
  }

  void saveData( Map radioMap) async {
    final prefs = await SharedPreferences.getInstance();

    ChangedPlanRequest changedPlanRequest = ChangedPlanRequest();
    ChangedPlan changedPlan = ChangedPlan();
    List<Feedbackschange> feedList = [];
    List<Questionairechange> questionaireList = [];
    Feedbackschange feedbacks = Feedbackschange();
    changedPlan.plannerEventId = int.parse(widget.event_id);
    for(int i = 0 ; i< radioMap.length; i++){
      Questionairechange questionairee = new  Questionairechange();
      questionairee.questionId = int.parse(radioMap.keys.elementAt(i));
      questionairee.result = radioMap.values.elementAt(i);
      questionaireList.add(questionairee);

    }
    feedbacks.questionaire = questionaireList;
    feedList.add(feedbacks);
    changedPlan.feedbacks = feedList;
    changedPlan.newEvent = widget.newEvent;
    List<ChangedPlan> listchangePlan = [];
    listchangePlan.add(changedPlan);
    changedPlanRequest.changedPlan = listchangePlan ;

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      submittForm(context, changedPlanRequest.toJson());
    } else if (connectivityResult == ConnectivityResult.wifi) {
      submittForm(context, changedPlanRequest.toJson());
    } else{

      ChangedPlanRequest request = ChangedPlanRequest();
      if(prefs!.get(PrefrenceConst.replaceEventPlusFeedback)! != ""){
        request = changeplanResponceFromJson(prefs.getString(PrefrenceConst.replaceEventPlusFeedback)!);
        List<ChangedPlan> list = [];
        list = request.changedPlan!;
        list.add(changedPlanRequest.changedPlan![0]);
        request.changedPlan = list;
      } else {
        List<ChangedPlan> list = [];
        list.add(changedPlanRequest.changedPlan![0]);
        request.changedPlan = list;
      }
      prefs.setString(PrefrenceConst.replaceEventPlusFeedback,changeplanResponceInToJson(request));
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  HomeScreen() ));


    }
  }


  void setData() async{
    final prefs = await SharedPreferences.getInstance();

    String json = prefs!.getString(PrefrenceConst.events)!;
    ConData _model = conDataFromJson(json);
    for(int i= 0; i< _model.events!.length; i++){
      if(_model.events![i].eventNameLabel == widget.event){
        for(int j=0; j<_model.events![i].purposes!.length; i++ ){
          if(_model.events![i].purposes![j].purposeName == widget.eventPurpose){
            setState(() {
              questionnaire = _model.events![i].purposes![j].feedbackQuestionnaire!;
              return;
            });

          }
        }
      }
    }
  }

  submittForm(BuildContext context, Map body ) async {
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
        setState(() {
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
      AlertDialogue().showAlertDialog(context, "Alert Dialogue", "$error");
    }
  }

}

class DynamicRadio extends StatefulWidget {
  const DynamicRadio({Key? key, required this.list, required this.hint, required this.id, required this.radioMap}) : super(key: key);
  final List<String> list ;
  final String hint;
  final String id;
  final Map radioMap ;
  @override
  _DynamicRadioState createState() => _DynamicRadioState();
}

class _DynamicRadioState extends State<DynamicRadio> {


  String? _value;
  @override
  void initState() {

    _value = widget.list[0];
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${widget.hint}", style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: Colors.black
          ),),
          SizedBox(height: 3,),
          ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: widget.list.length,
              itemBuilder: (context, index) {

                return SizedBox(
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  child:  ListTile(
                    contentPadding: EdgeInsets.all(0),
                    title:  Text("${widget.list[index]}",style: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Colors.grey,
                        fontSize: 16
                    ),),
                    leading: Radio(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      value: widget.list[index],
                      groupValue: _value,
                      onChanged: ( value) {
                        setState(() {
                          _value = value as String;
                          widget.radioMap[widget.id] = _value;
                        });
                      },
                    ),
                  ),
                );
              }
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
            child: Container(
              height: 1,
              width: MediaQuery.of(context).size.width,
              color: Color(0xffDCDCDC),
            ),
          ),
        ],
      ),
    );
  }
}



class DynamicTextField extends StatefulWidget {
  const DynamicTextField({Key? key,required this.hint, required this.id, required this.textFieldMap}) : super(key: key);

  final String hint;
  final String id;
  final Map textFieldMap;


  @override
  _DynamicTextFieldState createState() => _DynamicTextFieldState();
}

class _DynamicTextFieldState extends State<DynamicTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: widget.hint,
                  hintText: widget.hint,
                ),
                onChanged: (value){
                  widget.textFieldMap[widget.id] = value.toString();
                },
              )
          ),
          //   TextField(
          //     onChanged: (value){
          //       widget.textFieldMap[widget.id] = value.toString();
          //     },
          //     decoration: InputDecoration(
          //         hintText: widget.hint
          //     ),
          //   ),
          // ),
          Container(
            height: 1,
            width: MediaQuery.of(context).size.width,
            color: Color(0xffDCDCDC),
          ),
        ],
      ),);
  }
}



