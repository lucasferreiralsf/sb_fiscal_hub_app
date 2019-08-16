import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sb_fiscal_hub_app/models/user_model.dart';
import 'package:sb_fiscal_hub_app/screens/home_screen.dart';
import 'package:sb_fiscal_hub_app/screens/login_screen.dart';
import 'package:sb_fiscal_hub_app/screens/select_company_screen.dart';
import 'package:scoped_model/scoped_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
      model: UserModel(),
      child: MaterialApp(
        localizationsDelegates: [
          // ... app-specific localization delegate[s] here
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en', 'US'),
          // English
          const Locale('pt', 'BR'),
          // Hebrew// Chinese *See Advanced Locales below*
          // ... other locales the app supports
        ],
        title: 'Fiscal Hub',
        theme: ThemeData(
          primarySwatch: Colors.green,
          primaryColor: Color.fromARGB(255, 0, 137, 56),
          fontFamily: 'OpenSans',
          errorColor: Colors.red[700],
        ),
        debugShowCheckedModeBanner: false,
        // home: LoginScreen(),
        initialRoute: '/',
        routes: {
          '/': (context) => LoginScreen(),
          '/home': (context) => HomeScreen(),
          '/select-company': (context) => SelectCompanyScreen(),
        },
      ),
    );
  }
}
