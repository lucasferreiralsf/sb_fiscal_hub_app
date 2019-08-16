import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

class CompanyList {
  List<dynamic> data;

  CompanyList({this.data});

  factory CompanyList.fromJson(List<dynamic> returnedJson) {
    return CompanyList(data: returnedJson);
  }
}

class UserModel extends Model {
  bool isLoading = false;
  var signInError;

  void signIn(
      {@required Map<String, dynamic> userData,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail}) async {
    isLoading = true;
    notifyListeners();

    FlutterSecureStorage().write(key: 'userData', value: userData.toString());

    http.post('https://sbwebapidev.azurewebsites.net/api/usuario/authenticate',
        body: json.encode({
          'enderecoEmail': userData['email'],
          'senha': userData['password'],
          'autNewOrigin': 'false'
        }),
        headers: {
          'grupo': userData['grupo'],
          HttpHeaders.userAgentHeader: 'insomnia/6.6.2',
          HttpHeaders.contentTypeHeader: 'application/json',
        }).then((result) {
      FlutterSecureStorage().write(key: 'auth', value: result.body);

      onSuccess();
      isLoading = false;
      notifyListeners();
    }).catchError((e) {
      signInError = e;
      onFail();
      isLoading = false;
      notifyListeners();
    });
  }

  void recoverPass() {}

  void loggout() {
    FlutterSecureStorage().deleteAll();
  }

  void changeCompany() async {
    await FlutterSecureStorage().delete(key: 'currentCompany');
  }

  bool isLoggedIn() {
    var userAuthData;
    getAuthData().then((result) => {userAuthData = result});
    return userAuthData.token ? true : false;
  }

  getAuthData() async {
    String auth = await FlutterSecureStorage().read(key: 'auth');
    return json.decode(auth);
  }
}
