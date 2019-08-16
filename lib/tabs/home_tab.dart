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
  final response = await http.get(
      'https://sbwebapidev.azurewebsites.net/api/inventario/GetByIdData/1/10/${currentCompany['id']}/0/null',
      headers: {
        HttpHeaders.authorizationHeader:
            'Bearer ${auth['token']}',
        HttpHeaders.userAgentHeader: 'insomnia/6.6.2'
      });

  if (response.statusCode == 200) {
    // If server returns an OK response, parse the JSON.
    return Inventario.fromJson(json.decode(response.body));
  } else {
    // If that response was not OK, throw an error.
    throw Exception('Failed to load post');
  }
}

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
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
