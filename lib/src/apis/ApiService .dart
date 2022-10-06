import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:plannerapp/src/initialscrrens/HomeScreen.dart';
import 'package:plannerapp/src/models/Configurations.dart';
import 'package:plannerapp/src/models/CreateEvent_Responce.dart';
import 'package:plannerapp/src/models/Dashboard_Responce.dart';
import 'package:plannerapp/src/models/Login_Responce.dart';
import 'package:plannerapp/src/screens/CreatePlan.dart';
import 'package:plannerapp/utils/Prefrences.dart';
import 'package:plannerapp/utils/alertdialogue.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/ApiConstants.dart';
import 'package:http/http.dart' as http;

class ApiService {

  Future<Login_Responce?> login(Map<String, String> body, BuildContext context) async {
    EasyLoading.show(status: 'loading...');
    final prefs = await SharedPreferences.getInstance();
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.login);
      var response = await http.post(url, body: body);
      if (response.statusCode == 200) {
        Login_Responce _model = getLoginResponceFromJson(response.body) ;
        prefs.setString(PrefrenceConst.acessToken, _model.data!.token!);
        prefs.setString(PrefrenceConst.userName, _model.data!.fullname!);
        prefs.setString(PrefrenceConst.userDesignation, _model.data!.designation!);

        // String _eventJson = jsonEncode(_model.data!);
        // String _NetworkJson = jsonEncode(_model.data!.network!);
        //
        // prefs.setString(PrefrenceConst.events, _eventJson);
        //
        // prefs.setString(PrefrenceConst.networks, _NetworkJson);
        prefs.setBool(PrefrenceConst.isLogin, true);

        EasyLoading.showSuccess(_model.message!);

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



  Future<CreateEvent_Responce?> createEvent(Map<String, String> body, BuildContext context) async {
    print("body");
    EasyLoading.show(status: 'loading...');
    print(jsonEncode(body));
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(PrefrenceConst.acessToken)!;
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.createEvent);
      var response = await http.post(url, body: body, headers: {
      "Accept": 'application/json',
      'Authorization': 'Bearer $token'
      });
      if (response.statusCode == 200) {
        CreateEvent_Responce responce = createResponceFromJson(response.body);
        EasyLoading.showSuccess(responce.message!);

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


  Future<CreateEvent_Responce?> submitPlan(Map<String, String> body, BuildContext context, String month) async {
    EasyLoading.show(status: 'loading...');
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(PrefrenceConst.acessToken)!;
    print(jsonEncode(body));
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.actionStatusPlan);
      var response = await http.post(url, body: body, headers: {
        "Accept": 'application/json',
        'Authorization': 'Bearer $token'
      });
      if (response.statusCode == 200) {

        EasyLoading.dismiss();
        CreateEvent_Responce responce = createResponceFromJson(response.body);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CreatePlan()),
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


  getConfiguration(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(PrefrenceConst.acessToken)!;
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.configurations);
      var response = await http.get(url, headers: {
        "Accept": 'application/json',
        'Authorization': 'Bearer $token'
      });
      if (response.statusCode == 200) {

        Configurations _model = configResponceFromJson(response.body);

        String _eventJson = jsonEncode(_model.data!);
        String image = jsonEncode(_model.data!.userImage);

        prefs.setString(PrefrenceConst.image, image);
        print(image);
        prefs.setString(PrefrenceConst.events, _eventJson);

      } else {
        AlertDialogue().showAlertDialog(
            context, "Alert Dialogue", response.body.toString());
      }
    } catch (e) {
      String error = e.toString();
      if(error.contains("Connection failed")){

      } else {
        AlertDialogue().showAlertDialog(context, "Alert Dialogue", "$error");
      }

    }
  }

  getImage(BuildContext context , Map<String, String> body ) async {
    EasyLoading.show(status: 'loading...');

    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(PrefrenceConst.acessToken)!;
    print(body);
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.uploadProfileImage);
      var response = await http.post(url, body : body,  headers: {
        "Accept": 'application/json',
        'Authorization': 'Bearer $token'
      });
      if (response.statusCode == 200) {
        EasyLoading.dismiss();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );

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