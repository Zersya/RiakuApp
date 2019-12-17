import 'package:flutter/material.dart';
import 'package:riaku_app/utils/router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
       child: FlatButton(child: Text('Logout'), onPressed: (){
         SharedPreferences.getInstance().then((val){
           val.clear();
           Navigator.of(context).pushReplacementNamed(Router.kRouteAuth);
         });
       },),
    );
  }
}