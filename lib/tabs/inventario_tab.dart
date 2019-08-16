import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:sb_fiscal_hub_app/models/inventario.dart';
import 'package:sb_fiscal_hub_app/widgets/custom_list.dart';

Future<Inventario> fetchInventario() async {
  final auth = json.decode(await FlutterSecureStorage().read(key: 'auth'));
  final currentCompany = json.decode(await FlutterSecureStorage().read(key: 'currentCompany'));
  String _currentCompanyId = '${currentCompany["id"]}';
  String _url = 'https://sbwebapidev.azurewebsites.net/api/inventario/GetByIdData/1/10/null/0/${currentCompany["id"]}';
  String _token = 'Bearer ${auth["token"]}';
  final response = await http.get(
      Uri.encodeFull(_url),
      headers: {
        HttpHeaders.authorizationHeader:
        _token,
        HttpHeaders.userAgentHeader: 'insomnia/6.6.2',
        'companyId': _currentCompanyId,
      });

  if (response.statusCode == 200) {
    // If server returns an OK response, parse the JSON.
    return Inventario.fromJson(json.decode(response.body));
  } else {
    // If that response was not OK, throw an error.
    throw Exception('Failed to load post');
  }
}

class InventarioTab extends StatefulWidget {
  @override
  _InventarioTabState createState() => _InventarioTabState();
}

class _InventarioTabState extends State<InventarioTab> {
  Future<Inventario> inventario;

  @override
  Widget build(BuildContext context) {
    Widget _buildBodyBack() => Container(
          decoration: BoxDecoration(
//            gradient: LinearGradient(colors: [
//              Color.fromARGB(255, 0, 137, 56),
//              Color.fromARGB(255, 0, 91, 37)
//            ], begin: Alignment.topLeft, end: Alignment.bottomRight),
            color: Colors.grey[100],
          ),
        );

    return Stack(
      children: <Widget>[
        _buildBodyBack(),
        FutureBuilder<Inventario>(
          future: inventario,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.none:
                return Center(child: CircularProgressIndicator());
              default:
                if (snapshot.hasError)
                  return Text("${snapshot.error}");
                else
                  return CustomList(context, snapshot);
            }
          },
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    inventario = fetchInventario();
  }
}
