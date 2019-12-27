import 'package:riaku_app/utils/strKey.dart';

String generateAvatar(String key) {
  String url =  kAdorableAvatarURL + key + kAdorableAvatarURL_End;
  return url;
}
