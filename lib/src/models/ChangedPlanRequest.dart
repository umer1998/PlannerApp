
import 'dart:convert';

ChangedPlanRequest changeplanResponceFromJson(String str) => ChangedPlanRequest.fromJson(json.decode(str));

String changeplanResponceInToJson(ChangedPlanRequest user) => json.encode(user.toJson());



class ChangedPlanRequest {
  List<ChangedPlan>? changedPlan;

  ChangedPlanRequest({this.changedPlan});

  ChangedPlanRequest.fromJson(Map<String, dynamic> json) {
    if (json['changedPlan'] != null) {
      changedPlan = <ChangedPlan>[];
      json['changedPlan'].forEach((v) {
        changedPlan!.add(new ChangedPlan.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.changedPlan != null) {
      data['changedPlan'] = this.changedPlan!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ChangedPlan {
  NewEvent? newEvent;
  int? plannerEventId;
  List<Feedbackschange>? feedbacks;

  ChangedPlan({this.newEvent, this.plannerEventId, this.feedbacks});

  ChangedPlan.fromJson(Map<String, dynamic> json) {
    newEvent = json['new_event'] != null
        ? new NewEvent.fromJson(json['new_event'])
        : null;
    plannerEventId = json['plannerEventId'];
    if (json['feedbacks'] != null) {
      feedbacks = <Feedbackschange>[];
      json['feedbacks'].forEach((v) {
        feedbacks!.add(new Feedbackschange.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.newEvent != null) {
      data['new_event'] = this.newEvent!.toJson();
    }
    data['plannerEventId'] = this.plannerEventId;
    if (this.feedbacks != null) {
      data['feedbacks'] = this.feedbacks!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NewEvent {
  String? plan;
  String? plannedOn;
  String? eventId;
  String? purposeId;
  String? purposeChildId;

  NewEvent(
      {this.plan,
        this.plannedOn,
        this.eventId,
        this.purposeId,
        this.purposeChildId});

  NewEvent.fromJson(Map<String, dynamic> json) {
    plan = json['plan'];
    plannedOn = json['planned_on'];
    eventId = json['event_id'];
    purposeId = json['purpose_id'];
    purposeChildId = json['purpose_child_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['plan'] = this.plan;
    data['planned_on'] = this.plannedOn;
    data['event_id'] = this.eventId;
    data['purpose_id'] = this.purposeId;
    data['purpose_child_id'] = this.purposeChildId;
    return data;
  }
}

class Feedbackschange {
  List<Questionairechange>? questionaire;

  Feedbackschange({this.questionaire});

  Feedbackschange.fromJson(Map<String, dynamic> json) {
    if (json['questionaire'] != null) {
      questionaire = <Questionairechange>[];
      json['questionaire'].forEach((v) {
        questionaire!.add(new Questionairechange.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.questionaire != null) {
      data['questionaire'] = this.questionaire!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Questionairechange {
  int? questionId;
  String? result;

  Questionairechange({this.questionId, this.result});

  Questionairechange.fromJson(Map<String, dynamic> json) {
    questionId = json['question_id'];
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['question_id'] = this.questionId;
    data['result'] = this.result;
    return data;
  }
}
