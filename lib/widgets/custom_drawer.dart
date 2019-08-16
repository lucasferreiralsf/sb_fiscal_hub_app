import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sb_fiscal_hub_app/models/user_model.dart';
import 'package:sb_fiscal_hub_app/screens/login_screen.dart';
import 'package:sb_fiscal_hub_app/tiles/drawer_tile.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:string_mask/string_mask.dart';

enum MenuButton { sair, trocarEmpresa }

class CustomDrawer extends StatelessWidget {
  final PageController pageController;
  final Map<String, dynamic> _currentCompany;

  CustomDrawer(this.pageController, this._currentCompany);

  @override
  Widget build(BuildContext context) {
    Widget _buildDrawerBack() => Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.white, Colors.grey[300]],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight),
          ),
        );

    return Drawer(
      child: Stack(
        children: <Widget>[
          _buildDrawerBack(),
          ListView(
            padding: EdgeInsets.only(left: 32.0, top: 16.0),
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 8.0),
                padding: EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 8.0),
                height: 170.0,
                child: ScopedModelDescendant<UserModel>(
                    builder: (context, child, model) {
                  return Stack(
                    children: <Widget>[
                      Positioned(
                        top: 8.0,
                        left: 0.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Fiscal Hub",
                              style: TextStyle(
                                  fontSize: 34.0, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "${StringMask('00.000.000/0000-00').apply(_currentCompany['cnpj'])} \n ${_currentCompany['razaoSocial']}",
                              style: TextStyle(fontSize: 14.0),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        child: Text(
                          "Olá, Master",
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Positioned(
                        top: 4.0,
                        right: -10.0,
                        child: PopupMenuButton<MenuButton>(
                          onSelected: (MenuButton result) {
                            switch (result) {
                              case MenuButton.sair:
                                model.loggout();
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    '/', (Route<dynamic> route) => false);
                                break;
                              case MenuButton.trocarEmpresa:
                                model.changeCompany();
                                Navigator.of(context)
                                    .pushReplacementNamed('/select-company');
                                break;
                            }
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<MenuButton>>[
                            const PopupMenuItem<MenuButton>(
                              value: MenuButton.sair,
                              child: Text('Sair'),
                            ),
                            const PopupMenuItem<MenuButton>(
                              value: MenuButton.trocarEmpresa,
                              child: Text('Trocar empresa'),
                            ),
                          ],
                          icon: Icon(Icons.more_vert),
                        ),
                      ),
                    ],
                  );
                }),
              ),
              Divider(),
              DrawerTile(Icons.home, 'Início', pageController, 0),
              DrawerTile(Icons.people, 'Usuários', pageController, 1),
              DrawerTile(Icons.account_balance_wallet, 'Inventário', pageController, 2),
              DrawerTile(Icons.access_alarms, 'Teste', pageController, 3),
            ],
          )
        ],
      ),
    );
  }
}

// Column(
//                           children: <Widget>[
//                             GestureDetector(
//                               onTap: () {
//                                 model.loggout();
//                                 Navigator.of(context).pushNamedAndRemoveUntil(
//                                     '/', (Route<dynamic> route) => false);
//                                 // Navigator.of(context).push(MaterialPageRoute(
//                                 //     builder: (context) => LoginScreen()));
//                               },
//                               child: Text(
//                                 "Sair",
//                                 style: TextStyle(
//                                     fontSize: 18.0,
//                                     fontWeight: FontWeight.bold,
//                                     color: Theme.of(context).primaryColor),
//                               ),
//                             ),
//                             GestureDetector(
//                               onTap: () {
//                                 model.changeCompany();
//                                 Navigator.of(context).pushReplacementNamed('select-company');
//                                 // Navigator.of(context).push(MaterialPageRoute(
//                                 //     builder: (context) => LoginScreen()));
//                               },
//                               child: Text(
//                                 "Trocar empresa",
//                                 style: TextStyle(
//                                     fontSize: 18.0,
//                                     fontWeight: FontWeight.bold,
//                                     color: Theme.of(context).primaryColor),
//                               ),
//                             ),
//                           ],
//                         ),
