import 'package:flutter/material.dart';
import 'package:riaku_app/generated/locale_base.dart';
import 'package:riaku_app/screens/home/dashboard/dashboard_screen.dart';
import 'package:riaku_app/screens/profile/profile_screen.dart';
import 'package:riaku_app/utils/router.dart';
import 'package:riaku_app/utils/strKey.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 0, length: 2, vsync: this);

    SharedPreferences.getInstance().then((val){
      if(val.getString(kIdKey) == null){
        Navigator.pushReplacementNamed(context, Router.kRouteAuth);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = Localizations.of<LocaleBase>(context, LocaleBase);

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        title: Text(
          loc.home.home,
          style: Theme.of(context).textTheme.title,
        ),
        bottom: PreferredSize(
          preferredSize: Size(30, 20),
          child: TabBar(
            controller: _tabController,
            tabs: <Widget>[
              Icon(Icons.home, color: Theme.of(context).primaryColor),
              Icon(Icons.person, color: Theme.of(context).primaryColor),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[DashboardScreen(), ProfileScreen()],
      ),
    );
  }
}