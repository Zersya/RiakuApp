import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class LocaleBase {
  Map<String, dynamic> _data;
  String _path;
  Future<void> load(String path) async {
    _path = path;
    final strJson = await rootBundle.loadString(path);
    _data = jsonDecode(strJson);
    initAll();
  }
  
  Map<String, String> getData(String group) {
    return Map<String, String>.from(_data[group]);
  }

  String getPath() => _path;

  Localeauth _auth;
  Localeauth get auth => _auth;
  Localecommon _common;
  Localecommon get common => _common;
  Localedashboard _dashboard;
  Localedashboard get dashboard => _dashboard;
  Localeerror _error;
  Localeerror get error => _error;
  Localehome _home;
  Localehome get home => _home;
  Localepost _post;
  Localepost get post => _post;
  Localesuccess _success;
  Localesuccess get success => _success;

  void initAll() {
    _auth = Localeauth(Map<String, String>.from(_data['auth']));
    _common = Localecommon(Map<String, String>.from(_data['common']));
    _dashboard = Localedashboard(Map<String, String>.from(_data['dashboard']));
    _error = Localeerror(Map<String, String>.from(_data['error']));
    _home = Localehome(Map<String, String>.from(_data['home']));
    _post = Localepost(Map<String, String>.from(_data['post']));
    _success = Localesuccess(Map<String, String>.from(_data['success']));
  }
}

class Localeauth {
  final Map<String, String> _data;
  Localeauth(this._data);

  String get forgotPassword => _data["forgotPassword"];
  String get login => _data["login"];
  String get register => _data["register"];
}
class Localecommon {
  final Map<String, String> _data;
  Localecommon(this._data);

  String get back => _data["back"];
  String get uploading => _data["uploading"];
  String get delete => _data["delete"];
  String get emptyPosts => _data["emptyPosts"];
}
class Localedashboard {
  final Map<String, String> _data;
  Localedashboard(this._data);

  String get dashboard => _data["dashboard"];
  String get likesLabel => _data["likesLabel"];
  String get commentsLabel => _data["commentsLabel"];
}
class Localeerror {
  final Map<String, String> _data;
  Localeerror(this._data);

  String get exceptionError => _data["exceptionError"];
  String get connectionError => _data["connectionError"];
  String get emailRegisteredError => _data["emailRegisteredError"];
  String get emailEmpty => _data["emailEmpty"];
  String get passwordEmpty => _data["passwordEmpty"];
  String get passwordMin => _data["passwordMin"];
  String get emailValid => _data["emailValid"];
}
class Localehome {
  final Map<String, String> _data;
  Localehome(this._data);

  String get home => _data["home"];
  String get toAccount => _data["toAccount"];
  String get toNotification => _data["toNotification"];
  String get toClass => _data["toClass"];
  String get toSetting => _data["toSetting"];
  String get toVerify => _data["toVerify"];
  String get toAdd => _data["toAdd"];
}
class Localepost {
  final Map<String, String> _data;
  Localepost(this._data);

  String get createPostLabel => _data["createPostLabel"];
  String get hintPost => _data["hintPost"];
  String get sendLabel => _data["sendLabel"];
  String get noCommentLabel => _data["noCommentLabel"];
  String get hintWriteComment => _data["hintWriteComment"];
  String get addComentLabel => _data["addComentLabel"];
}
class Localesuccess {
  final Map<String, String> _data;
  Localesuccess(this._data);

  String get successCreate => _data["successCreate"];
  String get successLogin => _data["successLogin"];
}
