import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:riaku_app/generated/locale_base.dart';
import 'package:riaku_app/models/user.dart';
import 'package:riaku_app/utils/enum.dart' as Enum;

import 'login_bloc.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  FocusNode _emailFN = FocusNode();
  FocusNode _passwordFN = FocusNode();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  LoginBloc _loginBloc;

  @override
  Widget build(BuildContext context) {
    final loc = Localizations.of<LocaleBase>(context, LocaleBase);
    final double radiusInputField = 10.0;

    _loginBloc = Provider.of<LoginBloc>(context);

    return StreamBuilder<Enum.FormState>(
        stream: _loginBloc.stateStream,
        initialData: Enum.FormState.IDLE,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          Enum.FormState state = snapshot.data;
          if (state == Enum.FormState.ERROR) {
            return Container(child: Center(child: Text('Error')));
          }

          if (state == Enum.FormState.LOADING) {
            return Center(child: CircularProgressIndicator());
          }
          if (state == Enum.FormState.IDLE) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    border: Border.all(
                        color: Theme.of(context).colorScheme.surface,
                        width: 0.5),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Material(
                          elevation: 2,
                          borderRadius: BorderRadius.circular(radiusInputField),
                          shadowColor:
                              Theme.of(context).colorScheme.primaryVariant,
                          child: TextFormField(
                            controller: _emailController,
                            focusNode: _emailFN,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              hintText: 'Email',
                              prefixIcon: Icon(Icons.email),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(radiusInputField)),
                            ),
                            onFieldSubmitted: (val) {
                              FocusScope.of(context).requestFocus(_passwordFN);
                            },
                            validator: (val) {
                              if (val.isEmpty) {
                                return loc.error.emailEmpty;
                              } else if (!EmailValidator.validate(val)) {
                                return loc.error.emailValid;
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 48.0,
                                                  child: GestureDetector(
                            onTap: (){},
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(loc.auth.forgotPassword),
                              ),
                            ),
                          ),
                        ),
                        StreamBuilder<bool>(
                          stream: _loginBloc.isVisibleStream,
                          initialData: true,
                          builder: (context, snapshot) {
                            bool isVisible = snapshot.data;
                            return Material(
                              elevation: 2,
                              borderRadius: BorderRadius.circular(radiusInputField),
                              shadowColor:
                                  Theme.of(context).colorScheme.primaryVariant,
                              child: TextFormField(
                                controller: _passwordController,
                                focusNode: _passwordFN,
                                obscureText: isVisible,
                                textInputAction: TextInputAction.done,
                                decoration: InputDecoration(
                                  hintText: 'Password',
                                  suffixIcon: GestureDetector(
                                    onTap: (){
                                      _loginBloc.setVisibility(!isVisible);
                                    },
                                    child: Icon(isVisible ? Icons.visibility_off:Icons.visibility)),
                                  prefixIcon: Icon(Icons.lock),
                                ),
                                onFieldSubmitted: (val) {
                                  _submitLogin();
                                },
                                validator: (val) {
                                  if (val.isEmpty) {
                                    return loc.error.passwordEmpty;
                                  } else if (val.length < 6) {
                                    return loc.error.passwordMin;
                                  }
                                  return null;
                                },
                              ),
                            );
                          }
                        ),
                        SizedBox(
                          height: 32,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: RaisedButton(
                            elevation: 2,
                            child: Text(loc.auth.login,
                                style: Theme.of(context).textTheme.button),
                            onPressed: () {
                              _submitLogin();
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else
            return Container();
        });
  }

  void _submitLogin() {
    if (_formKey.currentState.validate()) {
      FocusScope.of(context).unfocus();
      User user =
          User(_emailController.text, password: _passwordController.text);
      _loginBloc.loginUser(user);
    }
  }
}
