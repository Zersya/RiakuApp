import 'package:flutter/material.dart';
import 'package:riaku_app/models/user.dart';
import 'package:riaku_app/screens/profile/profile_bloc.dart';
import 'package:riaku_app/helper/router.dart';
import 'package:riaku_app/widgets/avatarWIdget.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileBloc _profileBloc = ProfileBloc();

  @override
  void initState() {
    super.initState();
    _profileBloc.fetchUser();
  }

  @override
  void dispose() {
    super.dispose();
    _profileBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
        stream: _profileBloc.userStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AvatarWidget(
                url: snapshot.data.id,
                radius: 32,
              ),
              SizedBox(
                height: 16.0,
              ),
              Text(
                snapshot.data.username,
                style: Theme.of(context).textTheme.subhead,
              ),
              Container(
                child: RaisedButton(
                  child: Text('Logout'),
                  onPressed: () {
                    _profileBloc.logout();
                    Navigator.of(context)
                        .pushReplacementNamed(Router.kRouteAuth);
                  },
                ),
              ),
            ],
          );
        });
  }
}
