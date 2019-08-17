import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sb_fiscal_hub_app/models/user_model.dart';
import 'package:sb_fiscal_hub_app/repository/auth_repository.dart';
import 'package:sb_fiscal_hub_app/utils/functions/fetched_data.dart';
import 'package:string_mask/string_mask.dart';

class SelectCompanyScreen extends StatefulWidget {
  @override
  _SelectCompanyScreenState createState() => _SelectCompanyScreenState();
}

class _SelectCompanyScreenState extends State<SelectCompanyScreen> {
  Future<FetchedData<CompanyList>> companies;

  void _setCompany(Map<String, dynamic> company) async {
    await FlutterSecureStorage()
        .write(key: 'currentCompany', value: json.encode(company));
    Navigator.of(context).pushReplacementNamed('/home');
    // Navigator.of(context).push(
    //     MaterialPageRoute(builder: (context) => HomeScreen()));
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
                onTap: () {
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
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 5.0),
                              ),
                              Text(
                                'Razão Social: ${snapshot.data.data[index.toInt()]['razaoSocial']}',
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 5.0),
                              ),
                              Text(
                                'Nome Fantasia: ${snapshot.data.data[index.toInt()]['fantasia']}',
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 5.0),
                              ),
                              Text(
                                'UF: ${snapshot.data.data[index.toInt()]['sigla']}',
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold),
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
      child: FutureBuilder<FetchedData<CompanyList>>(
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
                  body: snapshot.data.error == true
                      ? Center(
                          child: Container(
                            padding: EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SvgPicture.asset('assets/icons/empty.svg'),
                                Text('Sem dados...', style: Theme.of(context).textTheme.subhead,)
                              ],
                            ),
                          ),
                        )
                      : _companyList(context, snapshot.data),
                );
          }
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    companies = fetchCompanyByUser();
    // setState(() {});
    // var auth;
    // FlutterSecureStorage().read(key: 'auth').then((result) {
    //   auth = json.decode(result);
    // });
  }
}
