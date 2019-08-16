import 'package:flutter/material.dart';
import 'package:sb_fiscal_hub_app/models/user_model.dart';
import 'package:sb_fiscal_hub_app/screens/home_screen.dart';
import 'package:sb_fiscal_hub_app/screens/select_company_screen.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _grupoController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final FocusNode _grupoFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passFocus = FocusNode();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void _login(model) {
      Map<String, dynamic> userData = {
        "grupo": _grupoController.text,
        "email": _emailController.text,
        "password": _passController.text,
      };
      model.loggout();
      model.signIn(userData: userData, onSuccess: _onSuccess, onFail: _onFail);
    }

    void _onSuccess() {
      Navigator.pushNamed(context, '/select-company');
    }

    void _onFail() {
      // ScopedModelDescendant<UserModel>(builder: (context, child, model) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('Chave, email ou senha incorretos.'),
          backgroundColor: Theme.of(context).errorColor,
          duration: Duration(seconds: 4),
        ));
      //   return null;
      // });
    }

  @override
  Widget build(BuildContext context) {
    _fieldFocusChange(
        BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
      currentFocus.unfocus();
      FocusScope.of(context).requestFocus(nextFocus);
    }    

    return Scaffold(
      key: _scaffoldKey,
      body: ScopedModelDescendant<UserModel>(
        builder: (context, child, model) {
          if (model.isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Container(
              decoration: BoxDecoration(
//          gradient: LinearGradient(
//            colors: [
//              Color.fromARGB(255, 0, 137, 56),
//              Color.fromARGB(255, 0, 91, 37),
//            ],
//            begin: Alignment.topLeft,
//            end: Alignment.bottomRight,
//          ),
                  color: Colors.grey[200]),
              alignment: Alignment.center,
              width: double.infinity,
              height: double.infinity,
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Theme(
                    data: ThemeData(
                      primaryColor: Color.fromARGB(255, 0, 137, 56),
                      primaryColorDark: Colors.red,
//              hintColor: Colors.grey[400],
                      hintColor: Colors.grey[600],
//              brightness: Brightness.dark,
                      brightness: Brightness.light,
//              accentColor: Color.fromARGB(150, 255, 255, 255),
                      accentColor: Colors.yellow[700],
                      errorColor: Colors.red[700],
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 40.0),
                      child: Column(
                        children: <Widget>[
                          Center(
                            child: Image.asset(
                              "assets/logo/mini-subway@2x.png",
//                        "assets/logo/mini-subway-branco@2x.png",
                              width: 70.0,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 10.0),
                          ),
                          Center(
                            child: Text(
                              "Fiscal Hub",
                              style: TextStyle(
                                fontSize: 26.0,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 100.0),
                          ),
                          TextFormField(
                            controller: _grupoController,
                            decoration: InputDecoration(
                              hintText: "Grupo",
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide:
                                      BorderSide(style: BorderStyle.none)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide:
                                      BorderSide(style: BorderStyle.none)),
                              filled: true,
                              fillColor: Color.fromARGB(20, 0, 0, 0),
                              prefixIcon: Icon(
                                Icons.domain,
//                          color: Theme.of(context).hintColor,
                              ),
                            ),
                            validator: (text) {
                              if (text.isEmpty) return "Campo obrigatório.";
                              return null;
                            },
                            textInputAction: TextInputAction.next,
                            focusNode: _grupoFocus,
                            onFieldSubmitted: (term) {
                              _fieldFocusChange(
                                  context, _grupoFocus, _emailFocus);
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 10.0),
                          ),
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              hintText: "Email",
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide:
                                      BorderSide(style: BorderStyle.none)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide:
                                      BorderSide(style: BorderStyle.none)),
                              filled: true,
                              fillColor: Color.fromARGB(20, 0, 0, 0),
                              prefixIcon: Icon(
                                Icons.person_outline,
//                          color: Theme.of(context).hintColor,
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (text) {
                              if (text.isEmpty) return "Campo obrigatório.";
                              if (!text.contains('@')) return "Email inválido.";
                              return null;
                            },
                            textInputAction: TextInputAction.next,
                            focusNode: _emailFocus,
                            onFieldSubmitted: (term) {
                              _fieldFocusChange(
                                  context, _emailFocus, _passFocus);
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 10.0),
                          ),
                          TextFormField(
                            controller: _passController,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: "Senha",
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide:
                                      BorderSide(style: BorderStyle.none)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  borderSide:
                                      BorderSide(style: BorderStyle.none)),
                              filled: true,
                              fillColor: Color.fromARGB(20, 0, 0, 0),
                              prefixIcon: Icon(
                                Icons.lock_outline,
//                          color: Theme.of(context).hintColor,
                              ),
                            ),
                            validator: (text) {
                              if (text.isEmpty) return "Campo obrigatório.";
                              return null;
                            },
                            textInputAction: TextInputAction.next,
                            focusNode: _passFocus,
                            onFieldSubmitted: (term) {
                              _passFocus.unfocus();
                              _login(model);
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 60.0),
                          ),
                          RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
//                      color: Colors.yellow[700],
                            color: Color.fromARGB(255, 0, 137, 56),
//                      color: Color.fromARGB(255, 0, 137, 56),
//                      color: Color.fromARGB(255, 76, 0, 106),
                            child: Container(
                              width: 250.0,
                              height: 50.0,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(right: 10.0),
                                      child: Text(
                                        'LOGIN',
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.white),
                                      ),
                                    ),
                                    Icon(
                                      Icons.send,
                                      color: Colors.white,
                                    ),
                                  ]),
                            ),
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                _login(model);
                              }
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 60.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
