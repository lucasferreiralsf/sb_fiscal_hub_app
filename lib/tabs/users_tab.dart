import 'package:async/async.dart';
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
  bool _isLoading = false;
  final AsyncMemoizer<FetchedData<UserModel>> _memoizer =
      AsyncMemoizer<FetchedData<UserModel>>();

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
                              onLongPress: () {},
                              onTap: () {
                                _neverSatisfied(
                                    context, snapshot.data.data[index.toInt()]);
                              },
                              child: Icon(snapshot.data.data[index.toInt()]
                                          ['bloqueado'] ==
                                      'N'
                                  ? Icons.lock_open
                                  : Icons.lock_outline),
                            ),
                            // Padding(
                            //   padding: EdgeInsets.only(left: 10.0),
                            // ),
                            // GestureDetector(
                            //   onTap: () {},
                            //   child: Icon(Icons.delete),
                            // ),
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
                if (_isLoading) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return _customList(context, snapshot.data);
                }
              }
          }
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    users = _fetchUsers();
  }

  _resolveDate(data) {
    return DateFormat('dd-MM-yyyy').format(DateTime.parse(data));
  }

  _updateAndGetUsers({context, user, @required String action}) async {
    setState(() {
      _isLoading = true;
    });
    user['bloqueado'] = user['bloqueado'] == 'N' ? 'S' : 'N';
    // var userModified = Map<String, dynamic>();
    // userModified.addAll(user);
    // userModified['bloqueado'] = !userModified['bloqueado'];
    final result = await saveUser(user);/* .then((result) { */
      setState(() {
        _isLoading = false;
      });
      if (result.statusCode == 200) {
        // Scaffold.of(context).showSnackBar(SnackBar(
        //   content: Text(
        //       'Usuário ${user['bloqueado'] ? 'bloqueado com sucesso.' : 'desbloqueado com sucesso.'}'),
        //   backgroundColor: Theme.of(context).primaryColor,
        //   duration: Duration(seconds: 4),
        // ));
        setState(() {
          
        users = _fetchUsers();
        });
      } else {
        // Scaffold.of(context).showSnackBar(SnackBar(
        //   content: Text(result.message),
        //   backgroundColor: Theme.of(context).errorColor,
        //   duration: Duration(seconds: 4),
        // ));
      }
    // });
  }

  _fetchUsers() {
    // return _memoizer.runOnce(() async {
      return fetchUsers();
    // });
  }

  Future<void> _neverSatisfied(context, user) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: user['bloqueado'] == 'N' ? Text('Bloquear Usuário') : Text('Desbloquear Usuário'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                user['bloqueado'] == 'N' ? Text('Tem certeza que deseja bloquear o(a) ${user['nome']}?') :
                Text('Tem certeza que deseja desbloquear o(a) ${user['nome']}?'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Confirmar'),
              onPressed: () async {
                Navigator.of(context).pop();
                await _updateAndGetUsers(context: context, user: user, action: 'A');
              },
            ),
          ],
        );
      },
    );
  }
}
