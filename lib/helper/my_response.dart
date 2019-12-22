import 'package:riaku_app/models/user.dart';
import 'package:riaku_app/utils/enum.dart';
import 'package:riaku_app/utils/strKey.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyResponse<T> {
  final ResponseState responseState;
  final String message;
  final T result;

  MyResponse(this.responseState, this.result, {this.message});
}

class BaseReponseBloc<T> {
  BehaviorSubject<T> subjectState;
  BehaviorSubject<MyResponse> subjectResponse;
  BehaviorSubject<User> subjectUser;

  User user;

  BaseReponseBloc() {
    subjectResponse = BehaviorSubject<MyResponse>();
    subjectState = BehaviorSubject<T>();
    subjectUser = BehaviorSubject<User>();

    fetchUser().then((val) => user = val);
  }

  ValueStream<MyResponse> get responseStream => subjectResponse.stream;
  ValueStream<T> get stateStream => subjectState.stream;
  ValueStream<User> get userStream => subjectUser.stream;

  Future<User> fetchUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String email = pref.getString(kEmailKey);
    String id = pref.getString(kIdKey);
    String username = pref.getString(kUsernameKey);

    user = User(email, id: id, username: username);
    subjectUser.sink.add(user);

    return user;
  }

  void dispose() {
    subjectResponse.close();
    subjectState.close();
    subjectUser.close();
  }
}
