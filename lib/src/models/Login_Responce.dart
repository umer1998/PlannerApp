
import 'dart:convert';

Login_Responce getLoginResponceFromJson(String str) => Login_Responce.fromJson(json.decode(str));

String getLoginResponceInToJson(Login_Responce user) => json.encode(user.toJson());




Data getDataResponceFromJson(String str) => Data.fromJson(json.decode(str));

String getDataResponceInToJson(Data user) => json.encode(user.toJson());



class Login_Responce {
  bool? success;
  Data? data;
  String? message;

  Login_Responce({this.success, this.data, this.message});

  Login_Responce.fromJson(Map<String, dynamic> json) {
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
  String? image;
  String? fullname;
  String? designation;
  String? token;
  List<Events>? events;
  List<Network>? network;

  Data(
      {this.image,
        this.fullname,
        this.designation,
        this.token,
        this.events,
        this.network});

  Data.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    fullname = json['fullname'];
    designation = json['designation'];
    token = json['token'];
    if (json['events'] != null) {
      events = <Events>[];
      json['events'].forEach((v) {
        events!.add(new Events.fromJson(v));
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
    data['image'] = this.image;
    data['fullname'] = this.fullname;
    data['designation'] = this.designation;
    data['token'] = this.token;
    if (this.events != null) {
      data['events'] = this.events!.map((v) => v.toJson()).toList();
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
  String? eventColorCode;
  List<Purposes>? purposes;

  Events(
      {this.eventId, this.eventNameLabel, this.eventColorCode, this.purposes});

  Events.fromJson(Map<String, dynamic> json) {
    eventId = json['event_id'];
    eventNameLabel = json['event_name_label'];
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
  String? purposeColorCode;

  Purposes({this.purposeId, this.purposeName, this.purposeColorCode});

  Purposes.fromJson(Map<String, dynamic> json) {
    purposeId = json['purpose_id'];
    purposeName = json['purpose_name'];
    purposeColorCode = json['purpose_color_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['purpose_id'] = this.purposeId;
    data['purpose_name'] = this.purposeName;
    data['purpose_color_code'] = this.purposeColorCode;
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
