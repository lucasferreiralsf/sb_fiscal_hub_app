import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:sb_fiscal_hub_app/utils/constants.dart';

Future<http.Response> httpGet<T>(
    {@required String url, Map<String, String> headersList}) async {
  final auth = json.decode(await FlutterSecureStorage().read(key: 'auth'));
  final _token = auth['token'] != null ? 'Bearer ${auth["token"]}' : null;
  http.Response response;
  if (headersList != null) {
    response = await http.get(Uri.encodeFull(URL_DEV + '/' + url), headers: {
      HttpHeaders.authorizationHeader: _token,
      HttpHeaders.userAgentHeader: 'insomnia/6.6.2',
      HttpHeaders.contentTypeHeader: 'application/json',
      ...headersList
    });
  } else {
    response = await http.get(Uri.encodeFull(URL_DEV + '/' + url), headers: {
      HttpHeaders.authorizationHeader: _token,
      HttpHeaders.userAgentHeader: 'insomnia/6.6.2',
      HttpHeaders.contentTypeHeader: 'application/json',
    });
  }
  return response;
}

Future<http.Response> httpPost<T>(
    {@required String url,
    dynamic data,
    Map<String, String> headersList,
    bool authenticated}) async {
  final auth = authenticated == true
      ? json.decode(await FlutterSecureStorage().read(key: 'auth'))
      : null;
  final _token = auth != null ? 'Bearer ${auth["token"]}' : null;
  dynamic response;
  if (headersList != null) {
    response = await http.post(Uri.encodeFull(URL_DEV + '/' + url),
        body: data ?? null,
        headers: {
          HttpHeaders.authorizationHeader: _token ?? '',
          HttpHeaders.userAgentHeader: 'insomnia/6.6.2',
          HttpHeaders.contentTypeHeader: 'application/json',
          ...headersList
        });
  } else {
    response = await http.post(Uri.encodeFull(URL_DEV + '/' + url),
        body: data ?? null,
        headers: {
          HttpHeaders.authorizationHeader: _token ?? '',
          HttpHeaders.userAgentHeader: 'insomnia/6.6.2',
          HttpHeaders.contentTypeHeader: 'application/json',
        });
  }
  return response;
}
