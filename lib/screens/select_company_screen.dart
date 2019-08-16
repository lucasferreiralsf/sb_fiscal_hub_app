import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sb_fiscal_hub_app/models/user_model.dart';
import 'package:sb_fiscal_hub_app/screens/home_screen.dart';
import 'package:string_mask/string_mask.dart';
import 'package:http/http.dart' as http;

Future<CompanyList> fetchCompanyByUser(String token) async {
  final response = await http.post(
      'https://sbwebapidev.azurewebsites.net/api/usuario/rolecompany',
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        HttpHeaders.userAgentHeader: 'insomnia/6.6.2'
      });

  if (response.statusCode == 200) {
    // If server returns an OK response, parse the JSON.
    await FlutterSecureStorage()
        .write(key: 'companyListById', value: response.body);
    return CompanyList.fromJson(json.decode(response.body));
  } else {
    // If that response was not OK, throw an error.
    throw Exception('Failed to load post');
  }
}

class SelectCompanyScreen extends StatefulWidget {
  @override
  _SelectCompanyScreenState createState() => _SelectCompanyScreenState();
}

class _SelectCompanyScreenState extends State<SelectCompanyScreen> {
  Future<CompanyList> companies;

  void _setCompany(Map<String, dynamic> company) async {
    await FlutterSecureStorage().write(key: 'currentCompany', value: json.encode(company));
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    Widget _companyList(context, snapshot) {
      return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          itemCount: snapshot.data.data.length,
          itemBuilder: (context, index) {
            return Center(
//          Text(snapshot.data.data[index.toInt()]['data'].toString())
              child: GestureDetector(
                onTap: (){
                  _setCompany(snapshot.data.data[index.toInt()]);
                },
                child: Card(
                  elevation: 5.0,
                  child: Container(
                    height: 110.0,
                    width: double.maxFinite,
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          top: 10.0,
                          left: 15.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'ID: ${snapshot.data.data[index.toInt()]['id']}',
                                style: TextStyle(
                                    fontSize: 16.0, fontWeight: FontWeight.bold),
                              ),
                              Padding(padding: EdgeInsets.only(bottom: 5.0),),
                              Text(
                                'Razão Social: ${snapshot.data.data[index.toInt()]['razaoSocial']}',
                                style: TextStyle(
                                    fontSize: 14.0, fontWeight: FontWeight.bold),
                              ),
                              Padding(padding: EdgeInsets.only(bottom: 5.0),),
                              Text(
                                'Nome Fantasia: ${snapshot.data.data[index.toInt()]['fantasia']}',
                                style: TextStyle(
                                    fontSize: 14.0, fontWeight: FontWeight.bold),
                              ),
                              Padding(padding: EdgeInsets.only(bottom: 5.0),),
                              Text(
                                'UF: ${snapshot.data.data[index.toInt()]['sigla']}',
                                style: TextStyle(
                                    fontSize: 14.0, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 10.0,
                          right: 15.0,
                          child: Text(
                            'CNPJ: ${StringMask('00.000.000/0000-00').apply(snapshot.data.data[index.toInt()]['cnpj'])}',
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
    }

    return Container(
      decoration: BoxDecoration(
//            gradient: LinearGradient(colors: [
//              Color.fromARGB(255, 0, 137, 56),
//              Color.fromARGB(255, 0, 91, 37)
//            ], begin: Alignment.topLeft, end: Alignment.bottomRight),
        color: Colors.grey[100],
      ),
      child: FutureBuilder<CompanyList>(
        future: companies,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError)
                return Text("${snapshot.error}");
              else
                return Scaffold(
                  appBar: AppBar(
                    title: Text('Selecione a empresa'),
                    centerTitle: true,
                  ),
                  body: _companyList(context, snapshot),
                );
          }
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    var auth;
      FlutterSecureStorage().read(key: 'auth').then((result) {
        auth = json.decode(result);
        companies = fetchCompanyByUser(auth['token']);
        setState(() {});
    });
  }
}
