import 'dart:convert';

CreateEvent_Responce createResponceFromJson(String str) => CreateEvent_Responce.fromJson(json.decode(str));

String createResponceInToJson(CreateEvent_Responce user) => json.encode(user.toJson());




class CreateEvent_Responce {
  bool? success;
  String? data;
  String? message;

  CreateEvent_Responce({this.success, this.data, this.message});

  CreateEvent_Responce.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['data'] = this.data;
    data['message'] = this.message;
    return data;
  }
}
