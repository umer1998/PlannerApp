
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
  String? fullname;
  String? designation;
  String? token;

  Data({this.fullname, this.designation, this.token});

  Data.fromJson(Map<String, dynamic> json) {
    fullname = json['fullname'];
    designation = json['designation'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fullname'] = this.fullname;
    data['designation'] = this.designation;
    data['token'] = this.token;
    return data;
  }
}
