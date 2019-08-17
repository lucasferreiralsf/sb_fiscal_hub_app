class CompanyList {
  List<dynamic> data;

  CompanyList({this.data});

  factory CompanyList.fromJson(List<dynamic> returnedJson) {
    return CompanyList(data: returnedJson);
  }
}

class UserAuth {
  List<dynamic> data;

  UserAuth({this.data});

  factory UserAuth.fromJson(List<dynamic> returnedJson) {
    return UserAuth(data: returnedJson);
  }
}

class UserModel {
  final int total;
  final List<dynamic> data;

  UserModel({this.total, this.data});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(total: json['total'], data: json['data']);
  }
}