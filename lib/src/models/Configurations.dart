import 'dart:convert';

Configurations configResponceFromJson(String str) => Configurations.fromJson(json.decode(str));

String configResponceInToJson(Configurations user) => json.encode(user.toJson());


ConData conDataFromJson(String str) => ConData.fromJson(json.decode(str));

String conDataInToJson(ConData user) => json.encode(user.toJson());
class Configurations {
  bool? success;
  ConData? data;
  String? message;

  Configurations({this.success, this.data, this.message});

  Configurations.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new ConData.fromJson(json['data']) : null;
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

class ConData {
  List<Events>? events;
  List<MeetingPlaces>? meetingPlaces;
  List<Network>? network;

  ConData({this.events, this.meetingPlaces, this.network});

  ConData.fromJson(Map<String, dynamic> json) {
    if (json['events'] != null) {
      events = <Events>[];
      json['events'].forEach((v) {
        events!.add(new Events.fromJson(v));
      });
    }
    if (json['meeting_places'] != null) {
      meetingPlaces = <MeetingPlaces>[];
      json['meeting_places'].forEach((v) {
        meetingPlaces!.add(new MeetingPlaces.fromJson(v));
      });
    }
    if (json['network'] != null) {
      network = <Network>[];
      json['network'].forEach((v) {
        network!.add(new Network.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.events != null) {
      data['events'] = this.events!.map((v) => v.toJson()).toList();
    }
    if (this.meetingPlaces != null) {
      data['meeting_places'] =
          this.meetingPlaces!.map((v) => v.toJson()).toList();
    }
    if (this.network != null) {
      data['network'] = this.network!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Events {
  int? eventId;
  String? eventNameLabel;
  String? eventNameCode;
  String? eventColorCode;
  List<Purposes>? purposes;

  Events(
      {this.eventId,
        this.eventNameLabel,
        this.eventNameCode,
        this.eventColorCode,
        this.purposes});

  Events.fromJson(Map<String, dynamic> json) {
    eventId = json['event_id'];
    eventNameLabel = json['event_name_label'];
    eventNameCode = json['event_name_code'];
    eventColorCode = json['event_color_code'];
    if (json['purposes'] != null) {
      purposes = <Purposes>[];
      json['purposes'].forEach((v) {
        purposes!.add(new Purposes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['event_id'] = this.eventId;
    data['event_name_label'] = this.eventNameLabel;
    data['event_name_code'] = this.eventNameCode;
    data['event_color_code'] = this.eventColorCode;
    if (this.purposes != null) {
      data['purposes'] = this.purposes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Purposes {
  int? purposeId;
  String? purposeName;
  String? purposeCode;
  String? purposeColorCode;
  List<FeedbackQuestionnaire>? feedbackQuestionnaire;

  Purposes(
      {this.purposeId,
        this.purposeName,
        this.purposeCode,
        this.purposeColorCode,
        this.feedbackQuestionnaire});

  Purposes.fromJson(Map<String, dynamic> json) {
    purposeId = json['purpose_id'];
    purposeName = json['purpose_name'];
    purposeCode = json['purpose_code'];
    purposeColorCode = json['purpose_color_code'];
    if (json['feedback_questionnaire'] != null) {
      feedbackQuestionnaire = <FeedbackQuestionnaire>[];
      json['feedback_questionnaire'].forEach((v) {
        feedbackQuestionnaire!.add(new FeedbackQuestionnaire.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['purpose_id'] = this.purposeId;
    data['purpose_name'] = this.purposeName;
    data['purpose_code'] = this.purposeCode;
    data['purpose_color_code'] = this.purposeColorCode;
    if (this.feedbackQuestionnaire != null) {
      data['feedback_questionnaire'] =
          this.feedbackQuestionnaire!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FeedbackQuestionnaire {
  int? id;
  String? type;
  String? question;
  List<String>? mcqs;

  FeedbackQuestionnaire({this.id, this.type, this.question, this.mcqs});

  FeedbackQuestionnaire.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    question = json['question'];
    mcqs = json['mcqs'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['question'] = this.question;
    data['mcqs'] = this.mcqs;
    return data;
  }
}

class MeetingPlaces {
  int? id;
  String? name;
  String? code;

  MeetingPlaces({this.id, this.name, this.code});

  MeetingPlaces.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['code'] = this.code;
    return data;
  }
}

class Network {
  int? id;
  String? name;
  String? code;
  var latitude;
  var longitude;
  List<Areas>? areas;

  Network(
      {this.id,
        this.name,
        this.code,
        this.latitude,
        this.longitude,
        this.areas});

  Network.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    if (json['areas'] != null) {
      areas = <Areas>[];
      json['areas'].forEach((v) {
        areas!.add(new Areas.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['code'] = this.code;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    if (this.areas != null) {
      data['areas'] = this.areas!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Areas {
  int? id;
  String? name;
  String? code;
  var latitude;
  var longitude;
  List<Branches>? branches;

  Areas(
      {this.id,
        this.name,
        this.code,
        this.latitude,
        this.longitude,
        this.branches});

  Areas.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    if (json['branches'] != null) {
      branches = <Branches>[];
      json['branches'].forEach((v) {
        branches!.add(new Branches.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['code'] = this.code;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    if (this.branches != null) {
      data['branches'] = this.branches!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Branches {
  int? id;
  String? name;
  String? code;
  var latitude;
  var longitude;

  Branches({this.id, this.name, this.code, this.latitude, this.longitude});

  Branches.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['code'] = this.code;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}
