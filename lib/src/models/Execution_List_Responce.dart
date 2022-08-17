
import 'dart:convert';

Execution_List_Responce getExeListResponceFromJson(String str) => Execution_List_Responce.fromJson(json.decode(str));

String getExeListResponceInToJson(Execution_List_Responce user) => json.encode(user.toJson());

class Execution_List_Responce {
  bool? success;
  List<Data>? data;
  String? message;

  Execution_List_Responce({this.success, this.data, this.message});

  Execution_List_Responce.fromJson(Map<String, dynamic> json) {
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
  int? plannerEventId;
  String? event;
  String? eventPurpose;
  String? plan;
  String? description;
  String? plannedOn;

  Data(
      {this.plannerEventId,
        this.event,
        this.eventPurpose,
        this.plan,
        this.description,
        this.plannedOn});

  Data.fromJson(Map<String, dynamic> json) {
    plannerEventId = json['planner_event_id'];
    event = json['event'];
    eventPurpose = json['event_purpose'];
    plan = json['plan'];
    description = json['description'];
    plannedOn = json['planned_on'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['planner_event_id'] = this.plannerEventId;
    data['event'] = this.event;
    data['event_purpose'] = this.eventPurpose;
    data['plan'] = this.plan;
    data['description'] = this.description;
    data['planned_on'] = this.plannedOn;
    return data;
  }
}
