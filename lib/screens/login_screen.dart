import 'package:flutter/material.dart';
import 'package:sb_fiscal_hub_app/repository/auth_repository.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _grupoController = TextEditingController(text: 'grupo1');
  final _emailController = TextEditingController(text: 'master@subway.com');
  final _passController = TextEditingController(text: 'Subw@y12');
  final FocusNode _grupoFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passFocus = FocusNode();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;

  void _login() {
    setState(() {
      _isLoading = true;
    });
    Map<String, dynamic> userData = {
      "grupo": _grupoController.text,
      "email": _emailController.text,
      "password": _passController.text,
    };
    loggout();
    signIn(userData: userData).then((result) {
      if (result['loggedIn'] == true) {
        _onSuccess();
      } else {
        _onFail(result['message']);
      }
    });
  }

  void _onSuccess() {
    setState(() {
      _isLoading = false;
    });
    Navigator.pushNamed(context, '/select-company');
  }

  void _onFail(String content) {
    setState(() {
      _isLoading = false;
    });
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(content),
      backgroundColor: Theme.of(context).errorColor,
      duration: Duration(seconds: 4),
    ));
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
      body: _isLoading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
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
                              _login();
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
                                _login();
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
            ),
    );
  }
}
