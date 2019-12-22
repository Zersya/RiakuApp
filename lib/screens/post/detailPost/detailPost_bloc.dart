import 'package:riaku_app/models/user.dart';
import 'package:riaku_app/utils/strKey.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailBloc{
  User _user;
  BehaviorSubject<User> _subjectUser;



  Future<User> fetchUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String email = pref.getString(kEmailKey);
    String id = pref.getString(kIdKey);
    String username = pref.getString(kUsernameKey);

    _user = User(email, id: id, username: username);
    _subjectUser.sink.add(_user);

    return _user;
  }
}