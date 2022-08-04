
import 'dart:convert';

Get_Managers getManagersResponceFromJson(String str) => Get_Managers.fromJson(json.decode(str));

String getManagersResponceInToJson(Get_Managers user) => json.encode(user.toJson());





class Get_Managers {
  bool? success;
  List<Data>? data;
  String? message;

  Get_Managers({this.success, this.data, this.message});

  Get_Managers.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
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

class Data {
  int? userId;
  String? username;
  String? fullname;
  String? empCode;
  String? cnic;
  String? designation;
  String? division;
  String? region;
  String? area;

  Data(
      {this.userId,
        this.username,
        this.fullname,
        this.empCode,
        this.cnic,
        this.designation,
        this.division,
        this.region,
        this.area});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    username = json['username'];
    fullname = json['fullname'];
    empCode = json['emp_code'];
    cnic = json['cnic'];
    designation = json['designation'];
    division = json['division'];
    region = json['region'];
    area = json['area'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['username'] = this.username;
    data['fullname'] = this.fullname;
    data['emp_code'] = this.empCode;
    data['cnic'] = this.cnic;
    data['designation'] = this.designation;
    data['division'] = this.division;
    data['region'] = this.region;
    data['area'] = this.area;
    return data;
  }
}
