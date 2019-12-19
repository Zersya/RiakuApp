import 'package:faker/faker.dart';
import 'package:riaku_app/models/user.dart';
import 'package:riaku_app/services/auth_service.dart';
import 'package:riaku_app/utils/enum.dart';
import 'package:riaku_app/utils/my_response.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class RegisterBloc extends BaseReponseBloc<FormState> {
  AuthService _authService;
  BehaviorSubject<User> _subjectUser;

  RegisterBloc() {
    _authService = AuthService();
    _subjectUser = BehaviorSubject<User>();
  }

  @override
  ValueStream<MyResponse> get responseStream => super.responseStream;

  ValueStream<User> get userStream => _subjectUser.stream;

  void registerUser(User user) async {
    this.subjectState.sink.add(FormState.LOADING);

    Faker faker = Faker();
    user.username = faker.internet.userName();

    MyResponse response = await _authService.createUser(user);
    _subjectUser.sink.add(user);
    this.subjectResponse.sink.add(response);
    this.subjectState.sink.add(FormState.IDLE);
  }

  @override
  void dispose() {
    super.dispose();
    _subjectUser.close();
  }
}
