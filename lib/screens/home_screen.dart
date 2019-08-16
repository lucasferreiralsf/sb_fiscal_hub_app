import 'package:flutter/material.dart';
import 'package:sb_fiscal_hub_app/tabs/home_tab.dart';
import 'package:sb_fiscal_hub_app/widgets/custom_drawer.dart';

class HomeScreen extends StatelessWidget {
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
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
          drawer: CustomDrawer(_pageController),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text('Outra coisa'),
            centerTitle: true,
          ),
          body: Container(color: Colors.red,),
          drawer: CustomDrawer(_pageController),
        ),

      ],
    );
  }
}
