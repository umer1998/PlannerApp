

import 'dart:convert';

GetPendingApproval getPendingAppResponceFromJson(String str) => GetPendingApproval.fromJson(json.decode(str));

String getPendingAppResponceInToJson(GetPendingApproval user) => json.encode(user.toJson());





class GetPendingApproval {
  bool? success;
  List<Data>? data;
  String? message;

  GetPendingApproval({this.success, this.data, this.message});

  GetPendingApproval.fromJson(Map<String, dynamic> json) {
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
  int? id;
  String? event;
  String? eventPurpose;
  String? plan;
  String? purposeChild;
  String? plannedOn;

  Data(
      {this.id,
        this.event,
        this.eventPurpose,
        this.plan,
        this.purposeChild,
        this.plannedOn});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    event = json['event'];
    eventPurpose = json['event_purpose'];
    plan = json['plan'];
    purposeChild = json['purpose_child'];
    plannedOn = json['planned_on'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['event'] = this.event;
    data['event_purpose'] = this.eventPurpose;
    data['plan'] = this.plan;
    data['purpose_child'] = this.purposeChild;
    data['planned_on'] = this.plannedOn;
    return data;
  }
}
