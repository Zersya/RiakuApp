import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:riaku_app/generated/locale_base.dart';
import 'package:riaku_app/screens/auth/login/login_screen.dart';
import 'package:riaku_app/screens/auth/register/register_screen.dart';
import 'package:riaku_app/utils/enum.dart';
import 'package:riaku_app/utils/router.dart';
import 'package:riaku_app/utils/strKey.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login/login_bloc.dart';
import 'register/register_bloc.dart';

class AuthScreen extends StatefulWidget {
  AuthScreen({Key key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  LoginBloc _loginBloc = LoginBloc();
  RegisterBloc _registerBloc = RegisterBloc();

  int indexForm = 0;

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((val){
      if(val.getString(kIdKey) != null){
        Navigator.pushReplacementNamed(context, Router.kRouteHome);
      }
    });

    _loginBloc.subjectResponse.listen((val) {
      if (val.responseState == ResponseState.SUCCESS) {
        Navigator.of(context).pushReplacementNamed(Router.kRouteHome);
      } else {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(val.message),
          backgroundColor: Theme.of(context).colorScheme.surface,
        ));
      }
    });

    _registerBloc.subjectResponse.listen((val) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(val.message),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ));
    });
  }

  @override
  void dispose() {
    super.dispose();

    _registerBloc.dispose();
    _loginBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            indexForm = 0;
                          });
                        },
                        child: ButtonSelectAuth(indexForm: indexForm, mode: 0),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            indexForm = 1;
                          });
                        },
                        child: ButtonSelectAuth(indexForm: indexForm, mode: 1),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                IndexedStack(
                  index: indexForm,
                  children: <Widget>[
                    Provider.value(value: _loginBloc, child: LoginScreen()),
                    Provider.value(value: _registerBloc, child: RegisterScreen()),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}

class ButtonSelectAuth extends StatelessWidget {
  const ButtonSelectAuth({
    Key key,
    @required this.indexForm,
    @required this.mode,
  }) : super(key: key);

  final int indexForm;
  final int mode;

  @override
  Widget build(BuildContext context) {
    final loc = Localizations.of<LocaleBase>(context, LocaleBase);

    return Container(
      padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
              style: indexForm == mode ? BorderStyle.solid : BorderStyle.solid,
              width: indexForm == mode ? 2 : 1,
              color: indexForm == mode
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.surface),
        ),
      ),
      child: Center(
        child: Text(mode == 0 ? loc.auth.login : loc.auth.register),
      ),
    );
  }
}
