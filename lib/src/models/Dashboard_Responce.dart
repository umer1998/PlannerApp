
import 'dart:convert';

Dashboard_Responce getDashboardResponceFromJson(String str) => Dashboard_Responce.fromJson(json.decode(str));

String getDashboardResponceInToJson(Dashboard_Responce user) => json.encode(user.toJson());


class Dashboard_Responce {
  bool? success;
  Data? data;
  String? message;

  Dashboard_Responce({this.success, this.data, this.message});

  Dashboard_Responce.fromJson(Map<String, dynamic> json) {
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
  EventSummary? eventSummary;
  List<Plans>? plans;

  Data({this.eventSummary, this.plans});

  Data.fromJson(Map<String, dynamic> json) {
    eventSummary = json['event_summary'] != null
        ? new EventSummary.fromJson(json['event_summary'])
        : null;
    if (json['plans'] != null) {
      plans = <Plans>[];
      json['plans'].forEach((v) {
        plans!.add(new Plans.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.eventSummary != null) {
      data['event_summary'] = this.eventSummary!.toJson();
    }
    if (this.plans != null) {
      data['plans'] = this.plans!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class EventSummary {
  int? visitPlanned;
  int? visitsExecuted;
  int? visitPending;
  int? leaves;

  EventSummary(
      {this.visitPlanned, this.visitsExecuted, this.visitPending, this.leaves});

  EventSummary.fromJson(Map<String, dynamic> json) {
    visitPlanned = json['visit_planned'];
    visitsExecuted = json['visits_executed'];
    visitPending = json['visit_pending'];
    leaves = json['leaves'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['visit_planned'] = this.visitPlanned;
    data['visits_executed'] = this.visitsExecuted;
    data['visit_pending'] = this.visitPending;
    data['leaves'] = this.leaves;
    return data;
  }
}

class Plans {
  String? event;
  String? eventPurpose;
  String? plan;
  String? description;
  String? plannedOn;

  Plans(
      {this.event,
        this.eventPurpose,
        this.plan,
        this.description,
        this.plannedOn});

  Plans.fromJson(Map<String, dynamic> json) {
    event = json['event'];
    eventPurpose = json['event_purpose'];
    plan = json['plan'];
    description = json['description'];
    plannedOn = json['planned_on'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['event'] = this.event;
    data['event_purpose'] = this.eventPurpose;
    data['plan'] = this.plan;
    data['description'] = this.description;
    data['planned_on'] = this.plannedOn;
    return data;
  }
}
