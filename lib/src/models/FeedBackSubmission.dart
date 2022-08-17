
import 'dart:convert';

FeedBackSubmission feedbackResponceFromJson(String str) => FeedBackSubmission.fromJson(json.decode(str));

String feedbackInToJson(FeedBackSubmission user) => json.encode(user.toJson());


class FeedBackSubmission {
  List<Feedbacks>? feedbacks;

  FeedBackSubmission({this.feedbacks});

  FeedBackSubmission.fromJson(Map<String, dynamic> json) {
    if (json['feedbacks'] != null) {
      feedbacks = <Feedbacks>[];
      json['feedbacks'].forEach((v) {
        feedbacks!.add(new Feedbacks.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.feedbacks != null) {
      data['feedbacks'] = this.feedbacks!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Feedbacks {
  String? plannerEventId;
  List<Questionaire>? questionaire;

  Feedbacks({this.plannerEventId, this.questionaire});

  Feedbacks.fromJson(Map<String, dynamic> json) {
    plannerEventId = json['planner_event_id'];
    if (json['questionaire'] != null) {
      questionaire = <Questionaire>[];
      json['questionaire'].forEach((v) {
        questionaire!.add(new Questionaire.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['planner_event_id'] = this.plannerEventId;
    if (this.questionaire != null) {
      data['questionaire'] = this.questionaire!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Questionaire {
  int? questionId;
  String? result;

  Questionaire({this.questionId, this.result});

  Questionaire.fromJson(Map<String, dynamic> json) {
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
