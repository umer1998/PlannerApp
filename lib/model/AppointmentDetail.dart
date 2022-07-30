import 'dart:convert';


AppointmentDetail userPrefFromJson(String str) => AppointmentDetail.fromJson(json.decode(str));

String userPrefToJson(AppointmentDetail user) => json.encode(user.toJson());


class AppointmentDetail {
  String? subject;
  String? starttime;
  String? endtime;

  AppointmentDetail(String subject, String? starttime, String? endtime) {
    this.starttime = starttime;
    this.subject = subject;
    this.endtime = endtime;
  }




  AppointmentDetail.fromJson(Map<String, dynamic> json) {

    starttime = json['starttime'];
    endtime = json['endtime'];
    subject = json['subject'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['starttime'] = this.starttime;
    data['endtime'] = this.endtime;
    data['subject'] = this.subject;
    return data;
  }

}