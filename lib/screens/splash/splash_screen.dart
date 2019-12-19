import 'package:flutter/material.dart';
import 'package:Riaku/utils/router.dart';
import 'package:Riaku/utils/strKey.dart';
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'RIAKU',
                style: Theme.of(context).textTheme.title,
              ),
              SizedBox(height: 16.0),
              CircularProgressIndicator()
            ],
          ),
        ),
      ),
    );
  }
}
