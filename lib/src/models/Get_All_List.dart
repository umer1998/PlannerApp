
import 'dart:convert';

Get_All_List getAllListResponceFromJson(String str) => Get_All_List.fromJson(json.decode(str));

String getAllListResponceInToJson(Get_All_List user) => json.encode(user.toJson());



DataallList getdataallResponceFromJson(String str) => DataallList.fromJson(json.decode(str));

String getdataallResponceInToJson(DataallList user) => json.encode(user.toJson());



class Get_All_List {
  bool? success;
  List<DataallList>? data;
  String? message;

  Get_All_List({this.success, this.data, this.message});

  Get_All_List.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <DataallList>[];
      json['data'].forEach((v) {
        data!.add(new DataallList.fromJson(v));
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

class DataallList {
  int? id;
  String? event;
  String? eventPurpose;
  String? plan;
  String? description;
  String? plannedOn;
  String? eventStatus;
  String? executionStatus;

  DataallList(
      {this.id,
        this.event,
        this.eventPurpose,
        this.plan,
        this.description,
        this.plannedOn,
        this.eventStatus,
        this.executionStatus});

  DataallList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    event = json['event'];
    eventPurpose = json['event_purpose'];
    plan = json['plan'];
    description = json['description'];
    plannedOn = json['planned_on'];
    eventStatus = json['event_status'];
    executionStatus = json['execution_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['event'] = this.event;
    data['event_purpose'] = this.eventPurpose;
    data['plan'] = this.plan;
    data['description'] = this.description;
    data['planned_on'] = this.plannedOn;
    data['event_status'] = this.eventStatus;
    data['execution_status'] = this.executionStatus;
    return data;
  }
}
