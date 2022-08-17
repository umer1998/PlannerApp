
import 'dart:convert';

ApproveEventRequest approveRequestFromJson(String str) => ApproveEventRequest.fromJson(json.decode(str));

String approveRequestInToJson(ApproveEventRequest user) => json.encode(user.toJson());

class ApproveEventRequest {
  int? eventStatus;
  int? plannedBy;
  int? planStatus;
  String? plan;
  List<Ids>? ids;

  ApproveEventRequest(
      {this.eventStatus, this.plannedBy, this.planStatus, this.plan, this.ids});

  ApproveEventRequest.fromJson(Map<String, dynamic> json) {
    eventStatus = json['event_status'];
    plannedBy = json['planned_by'];
    planStatus = json['plan_status'];
    plan = json['plan'];
    if (json['ids'] != null) {
      ids = <Ids>[];
      json['ids'].forEach((v) {
        ids!.add(new Ids.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['event_status'] = this.eventStatus;
    data['planned_by'] = this.plannedBy;
    data['plan_status'] = this.planStatus;
    data['plan'] = this.plan;
    if (this.ids != null) {
      data['ids'] = this.ids!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Ids {
  int? id;

  Ids({this.id});

  Ids.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    return data;
  }
}
