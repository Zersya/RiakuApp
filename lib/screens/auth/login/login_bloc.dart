import 'package:riaku_app/models/user.dart';
import 'package:riaku_app/services/auth_service.dart';
import 'package:riaku_app/utils/enum.dart';
import 'package:riaku_app/utils/my_response.dart';
import 'package:riaku_app/utils/strKey.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginBloc extends BaseReponseBloc<FormState> {
  AuthService _authService;
  BehaviorSubject<bool> _isVisible;

  LoginBloc() {
    _authService = AuthService();
    _isVisible = BehaviorSubject<bool>();
  }

  @override
  ValueStream<MyResponse> get responseStream => super.responseStream;
  ValueStream<bool> get isVisibleStream => _isVisible.stream;

  void setVisibility(bool data) {
    _isVisible.sink.add(data);
  }

  void loginUser(User user) async {
    this.subjectState.sink.add(FormState.LOADING);

    MyResponse response = await _authService.loginUser(user);
    if (response.responseState == ResponseState.SUCCESS) {
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString(kEmailKey, response.result.email);
      pref.setString(kIdKey, response.result.id);
      pref.setString(kUsernameKey, response.result.username);
    }
    this.subjectResponse.sink.add(response);
    this.subjectState.sink.add(FormState.IDLE);
  }

  @override
  void dispose() {
    super.dispose();

    _isVisible.close();
  }
}
