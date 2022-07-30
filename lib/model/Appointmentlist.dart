import 'dart:convert';

import 'package:plannerapp/model/AppointmentDetail.dart';

Appointmentlistt listPrefFromJson(String str) => Appointmentlistt.fromJson(json.decode(str));

String listPrefToJson(Appointmentlistt user) => json.encode(user.toJson());


class Appointmentlistt {

  List<AppointmentDetail>? listdetail ;

  Appointmentlistt(List<AppointmentDetail> listdetail) {

    this.listdetail = listdetail;

  }


  Appointmentlistt.fromJson(Map<String, dynamic> json) {

    listdetail = json['listdetail'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['listdetail'] = this.listdetail;

    return data;
  }

}