
import 'dart:convert';

Get_All_List getAllListResponceFromJson(String str) => Get_All_List.fromJson(json.decode(str));

String getAllListResponceInToJson(Get_All_List user) => json.encode(user.toJson());



DataallList getdataallResponceFromJson(String str) => DataallList.fromJson(json.decode(str));

String getdataallResponceInToJson(DataallList user) => json.encode(user.toJson());

class Get_All_List {
  bool? success;
  Data? data;
  String? message;

  Get_All_List({this.success, this.data, this.message});

  Get_All_List.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  List<DataallList>? events;
  List<Plans>? plans;

  Data({this.events, this.plans});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['events'] != null) {
      events = <DataallList>[];
      json['events'].forEach((v) {
        events!.add(new DataallList.fromJson(v));
      });
    }
    if (json['plans'] != null) {
      plans = <Plans>[];
      json['plans'].forEach((v) {
        plans!.add(new Plans.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.events != null) {
      data['events'] = this.events!.map((v) => v.toJson()).toList();
    }
    if (this.plans != null) {
      data['plans'] = this.plans!.map((v) => v.toJson()).toList();
    }
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

class Plans {
  String? plan;
  String? month;
  int? status;

  Plans({this.plan, this.month, this.status});

  Plans.fromJson(Map<String, dynamic> json) {
    plan = json['plan'];
    month = json['month'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['plan'] = this.plan;
    data['month'] = this.month;
    data['status'] = this.status;
    return data;
  }
}
