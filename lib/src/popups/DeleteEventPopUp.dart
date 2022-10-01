import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:plannerapp/src/apis/ApiService%20.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../utils/ApiConstants.dart';
import '../../utils/Prefrences.dart';
import '../../utils/alertdialogue.dart';
import '../initialscrrens/HomeScreen.dart';
import '../models/CreateEvent_Responce.dart';

class DeleteEventPopUp extends StatefulWidget {
  const DeleteEventPopUp( {Key? key  ,required this.body}) : super(key: key);

  final Map<String, String> body;
  @override
  _DeleteEventPopUpState createState() => _DeleteEventPopUpState();
}

class _DeleteEventPopUpState extends State<DeleteEventPopUp> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: showAlertDialog(context, "Alert Dialogue", "Are You Sure to Delete This Event ?"),
    );
  }

  showAlertDialog(BuildContext context, String title, String message) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Ok"),
      onPressed: () {

        editEvent(widget.body, context);

      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("$title"),
      content: Text("$message"),
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


  Future<CreateEvent_Responce?> editEvent(Map<String, String> body, BuildContext context) async {
    print (body);
    EasyLoading.show(status: 'loading...');
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(PrefrenceConst.acessToken)!;
    print (jsonEncode(body));
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.updateEvent);
      var response = await http.post(url, body: body, headers: {
        "Accept": 'application/json',
        'Authorization': 'Bearer $token'
      });
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        CreateEvent_Responce responce = createResponceFromJson(response.body);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        EasyLoading.dismiss();
        AlertDialogue().showAlertDialog(context, "Alert Dialogue", response.body.toString());
      }
    } catch (e) {
      EasyLoading.dismiss();
      String error = e.toString();
      AlertDialogue().showAlertDialog(context, "Alert Dialogue", "$error");

    }
  }

}
