import 'package:flutter/material.dart';

import 'package:together/Core/UIFunctions.dart';
import 'package:together/Core/Constants.dart';
import 'package:together/Controller/MainNavigation.dart';
import 'package:together/ViewModel/LoginViewModel.dart';


class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  LoginViewModel _viewModel = LoginViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.init(_userLoggedIn);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _viewModel.isChecking,
      initialData: true,
      builder: (context, snapshot) {
        return snapshot.data
            ? buildLoadingView(context)
            : buildLoginView(context);
      },
    );
  }

  Widget buildLoadingView(BuildContext context) {
    return Scaffold(body: new Center(child: new CircularProgressIndicator()));
  }

  Widget buildLoginView(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(_viewModel.background),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image(image: AssetImage(_viewModel.logo)),
                  Padding(
                      padding: EdgeInsets.only(top: kDefaultPadding),
                      child: Container(
                        width: 200,
                        child: TextField(
                          onChanged: _viewModel.emailChanged,
                          autofocus: true,
                          decoration: InputDecoration(
                              hintText: "Email",
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder()),
                        ),
                      )),
                  Padding(
                      padding: EdgeInsets.only(top: kDefaultPadding),
                      child: Container(
                        width: 200,
                        child: TextField(
                          onChanged: _viewModel.passwordChanged,
                          obscureText: true,
                          decoration: InputDecoration(
                              hintText: "Пароль",
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder()),
                        ),
                      )),
                  Padding(
                      padding: EdgeInsets.only(top: kDefaultPadding),
                      child: ElevatedButton(
                          child: Text("Войти"), onPressed: _onRegister)),
                ],
              ),
            )));
  }

  void _userLoggedIn() async {
    _viewModel.userLoggedIn(_onSuccess);
  }

  void _onRegister() {
    _viewModel.signIn(_onSuccess);
  }

  void _onSuccess() {
    pushReplacePage(
        context,
        MainNavigation(
          page: 0,
        ));
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}
