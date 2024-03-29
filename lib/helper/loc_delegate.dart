import 'package:flutter/material.dart';
import 'package:riaku_app/generated/locale_base.dart';

class LocDelegate extends LocalizationsDelegate<LocaleBase> {
  const LocDelegate();
  static LocaleBase currentLoc;

  final idMap = const {'en': 'locales/EN_US.json', 'id': 'locales/IN_ID.json'};

  @override
  bool isSupported(Locale locale) => ['en', 'id'].contains(locale.languageCode);

  @override
  Future<LocaleBase> load(Locale locale) async {
    var lang = 'en';
    if (isSupported(locale)) lang = locale.languageCode;
    final loc = LocaleBase();
    await loc.load(idMap[lang]);
    currentLoc = loc;
    return loc;
  }

  @override
  bool shouldReload(LocDelegate old) => false;
}