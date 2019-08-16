import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sb_fiscal_hub_app/tabs/home_tab.dart';
import 'package:sb_fiscal_hub_app/widgets/custom_drawer.dart';

class HomeScreen extends StatelessWidget {
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    var currentCompany = FlutterSecureStorage().read(key: 'currentCompany');
    return FutureBuilder<String>(
        future: currentCompany,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError)
                return Text("${snapshot.error}");
              else
                return PageView(
                  controller: _pageController,
                  physics: NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    Scaffold(
                      appBar: AppBar(
                        title: Text('Inventário'),
                        centerTitle: true,
                      ),
                      body: HomeTab(),
                      drawer: CustomDrawer(
                          _pageController, json.decode(snapshot.data)),
                    ),
                    Scaffold(
                      appBar: AppBar(
                        title: Text('Outra coisa'),
                        centerTitle: true,
                      ),
                      body: Container(
                        color: Colors.red,
                      ),
                      drawer: CustomDrawer(
                          _pageController, json.decode(snapshot.data)),
                    ),
                  ],
                );
          }
        });
  }
}
