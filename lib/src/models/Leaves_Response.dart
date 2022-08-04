import 'dart:convert';

Leaves_Response getleavesResponceFromJson(String str) => Leaves_Response.fromJson(json.decode(str));

String getleavesResponceInToJson(Leaves_Response user) => json.encode(user.toJson());

Data getdataResponceFromJson(String str) => Data.fromJson(json.decode(str));

String getdataResponceInToJson(Data user) => json.encode(user.toJson());




class Leaves_Response {
  bool? success;
  List<Data>? data;
  String? message;

  Leaves_Response({this.success, this.data, this.message});

  Leaves_Response.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  String? event;
  String? eventPurpose;
  String? plan;
  int? purposeChild;
  String? eventStatus;
  String? plannedOn;

  Data(
      {this.event,
        this.eventPurpose,
        this.plan,
        this.purposeChild,
        this.eventStatus,
        this.plannedOn});

  Data.fromJson(Map<String, dynamic> json) {
    event = json['event'];
    eventPurpose = json['event_purpose'];
    plan = json['plan'];
    purposeChild = json['purpose_child'];
    eventStatus = json['event_status'];
    plannedOn = json['planned_on'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['event'] = this.event;
    data['event_purpose'] = this.eventPurpose;
    data['plan'] = this.plan;
    data['purpose_child'] = this.purposeChild;
    data['event_status'] = this.eventStatus;
    data['planned_on'] = this.plannedOn;
    return data;
  }
}
