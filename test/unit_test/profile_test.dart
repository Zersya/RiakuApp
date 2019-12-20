import 'package:flutter_test/flutter_test.dart';
import 'package:riaku_app/models/user.dart';
import 'package:riaku_app/screens/profile/profile_bloc.dart';
import 'package:riaku_app/utils/strKey.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() {
    SharedPreferences.setMockInitialValues({
      kEmailKey: 'mail@mail.com',
      kIdKey: 'mail@mail.com',
      kUsernameKey: 'mail-mail'
    });
  });

  group('Profile', () {
    test('fetch success', () async {
      ProfileBloc bloc = ProfileBloc();

      await bloc.fetchUser();

      User user = bloc.userStream.stream.value;

      expect(user, isNotNull);
      expect(user.id, 'mail@mail.com');

      bloc.dispose();
    });

    test('logout', () async {
      ProfileBloc bloc = ProfileBloc();

      await bloc.fetchUser();

      User user = bloc.userStream.stream.value;

      expect(user, isNotNull);

      await bloc.logout();

      user = bloc.userStream.stream.value;

      expect(user, isNull);

      bloc.dispose();
    });
  });
}
