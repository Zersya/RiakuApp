import 'package:flutter/material.dart';
import 'package:riaku_app/helper/router.dart';
import 'package:riaku_app/utils/strKey.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((val) {
      if (val.containsKey(kIdKey)) {
        Navigator.of(context).pushReplacementNamed(Router.kRouteHome);
      } else {
        Navigator.of(context).pushReplacementNamed(Router.kRouteAuth);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              ClipRRect(
                    borderRadius: BorderRadius.circular(30.0),
                    child: Image.asset(
                      'assets/logos/logo_transparent.png',
                      width: MediaQuery.of(context).size.width / 1.5,
                    )),
              Positioned(
                bottom: 16,
                child: Center(child: CircularProgressIndicator(strokeWidth: 2,)))
            ],
          ),
        ),
      ),
    );
  }
}
