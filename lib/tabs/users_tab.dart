import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:sb_fiscal_hub_app/models/user_model.dart';
import 'package:sb_fiscal_hub_app/repository/user_repository.dart';
import 'package:sb_fiscal_hub_app/utils/functions/fetched_data.dart';

class UsersTab extends StatefulWidget {
  @override
  _UsersTabState createState() => _UsersTabState();
}

class _UsersTabState extends State<UsersTab> {
  Future<FetchedData<UserModel>> users;

  final _titleStyle = TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold);
  final _subTitleStyle = TextStyle(fontSize: 14.0);

  Widget _customList(BuildContext context, FetchedData<UserModel> snapshot) =>
      ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          itemCount: snapshot.data.total,
          itemBuilder: (context, index) {
            return Center(
//          Text(snapshot.data.data[index.toInt()]['data'].toString())
              child: Card(
                elevation: 5.0,
                child: Container(
                  height: 100.0,
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
                                'ID: ${snapshot.data.data[index.toInt()]["id"]} - ${snapshot.data.data[index.toInt()]["nome"]}',
                                style: _titleStyle,
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 10.0),
                              ),
                              Text(
                                '${snapshot.data.data[index.toInt()]["cargo"].length > 0 ? "Cargo: ${snapshot.data.data[index.toInt()]["cargo"]} - Válido até: ${_resolveDate(snapshot.data.data[index.toInt()]["dataValidade"])}" : "Válido até: ${_resolveDate(snapshot.data.data[index.toInt()]["dataValidade"])}"}',
                                style: _subTitleStyle,
                              ),
                            ],
                          )),
                      Positioned(
                        top: 3.0,
                        right: 15.0,
                        child: Chip(
                          backgroundColor: snapshot.data.data[index.toInt()]
                                      ['bloqueado'] ==
                                  'N'
                              ? Colors.green[600]
                              : Theme.of(context).errorColor,
                          label: Text(
                            snapshot.data.data[index.toInt()]['bloqueado'] ==
                                    'N'
                                ? 'Liberado'
                                : 'Bloqueado',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 10.0,
                        right: 15.0,
                        child: Row(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {},
                              child: Icon(Icons.done),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10.0),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Icon(Icons.delete),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<FetchedData<UserModel>>(
        future: users,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError)
                return Text("${snapshot.error}");
              else if (snapshot.data.error == true) {
                return Center(
                  child: Container(
                    padding: EdgeInsets.all(20.0),
                    child: SvgPicture.asset('assets/icons/empty.svg'),
                  ),
                );
              } else {
                return _customList(context, snapshot.data);
              }
          }
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    users = fetchUsers();
  }

  _resolveDate(data) {
    return DateFormat('dd-MM-yyyy').format(DateTime.parse(data));
  }
}
