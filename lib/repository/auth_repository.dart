import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sb_fiscal_hub_app/models/user_model.dart';
import 'package:sb_fiscal_hub_app/utils/constants.dart';
import 'package:sb_fiscal_hub_app/utils/functions/fetched_data.dart';
import 'package:sb_fiscal_hub_app/utils/functions/httpClient.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> signIn(
    {@required Map<String, dynamic> userData}) async {
  await FlutterSecureStorage()
      .write(key: 'userData', value: userData.toString());

  try {
    final response = await httpPost<UserAuth>(
        url: 'usuario/authenticate',
        data: json.encode({
          'enderecoEmail': userData['email'],
          'senha': userData['password'],
          'autNewOrigin': 'false'
        }),
        headersList: {
          'grupo': userData['grupo'],
        });
    if (response != null) {
      switch (response.statusCode) {
        case 200:
          await FlutterSecureStorage().write(key: 'auth', value: response.body);
          return {'statusCode': response.statusCode, 'loggedIn': true};
        case 500:
          await FlutterSecureStorage().write(key: 'auth', value: response.body);
          return {
            'statusCode': response.statusCode,
            'loggedIn': false,
            'message': 'Erro interno, tente novamente mais tarde.'
          };
        default:
          throw ({
            'statusCode': response.statusCode,
            'loggedIn': false,
            'message': 'Chave, email ou senha incorretos.'
          });
      }
    } else {
      throw ({
        'statusCode': response.statusCode,
        'loggedIn': false,
        'message': 'Chave, email ou senha incorretos.'
      });
    }
  } catch (e) {
    return {
      'e': e,
      'loggedIn': false,
      'message': 'Chave, email ou senha incorretos.'
    };
  }
}

Future<FetchedData<CompanyList>> fetchCompanyByUser() async {
  try {
    final response = await httpPost<CompanyList>(url: 'usuario/rolecompany', authenticated: true);
    // final response = await http.post(Uri.encodeFull(URL_DEV + '/' + 'usuario/rolecompany'), headers: {HttpHeaders.authorizationHeader: 'Bearer '});

    switch (response.statusCode) {
      case 200:
        // If server returns an OK response, parse the JSON.
        await FlutterSecureStorage()
            .write(key: 'companyListById', value: response.body);
        return FetchedData(
            error: false,
            message: 'OK',
            statusCode: 200,
            data: CompanyList.fromJson(json.decode(response.body)));
      case 401:
        // If that response was not OK, throw an error.
        return FetchedData(
            error: true,
            message: 'Usuário não autorizado.',
            statusCode: 401,
            data: '');
      default:
        return FetchedData(
            error: true,
            message: response.body,
            statusCode: response.statusCode,
            data: json.decode(response.body));
    }
  } catch (e) {
    return FetchedData(
        error: true,
        message: 'Falha interna, tente novamente.',
        statusCode: 500,
        data: '');
  }
}

void recoverPass() {}

void loggout() {
  FlutterSecureStorage().deleteAll();
}

void changeCompany() async {
  await FlutterSecureStorage().delete(key: 'currentCompany');
}

bool isLoggedIn() {
  return getAuthData().then((result) {
    return result.token != null ? true : false;
  });
}

getAuthData() async {
  String auth = await FlutterSecureStorage().read(key: 'auth');
  return json.decode(auth);
}
