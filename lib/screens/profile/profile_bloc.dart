import 'package:Riaku/models/user.dart';
import 'package:Riaku/utils/strKey.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileBloc {
  BehaviorSubject<User> _streamUser;

  ProfileBloc() {
    _streamUser = BehaviorSubject<User>();
  }

  BehaviorSubject<User> get userStream => _streamUser.stream;

  void fetchUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String email = pref.getString(kEmailKey);
    String id = pref.getString(kIdKey);
    String username = pref.getString(kUsernameKey);

    User user = User(email, id: id, username: username);

    _streamUser.sink.add(user);
  }

  void dispose(){
    _streamUser.close();
  }
}
