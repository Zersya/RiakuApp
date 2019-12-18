import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:riaku_app/utils/loc_delegate.dart';
import 'package:riaku_app/utils/router.dart';
import 'package:timeago/timeago.dart' as timeago;

void main() {
  timeago.setLocaleMessages('id', timeago.IdMessages());
  timeago.setLocaleMessages('en', timeago.EnMessages());


  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final ColorScheme _colorSchemeLight = ColorScheme.light(
    primary: const Color(0xffd32f2f),
    primaryVariant: const Color(0xffff6659),
    secondary: const Color(0xffff8f00),
    secondaryVariant: const Color(0xffffc046),
    surface: Colors.black45,
    background: Colors.white,
    error: const Color(0xffb00020),
    onPrimary: Colors.white,
    onSecondary: Colors.grey[300],
    onSurface: Colors.grey[300],
    onBackground: Colors.black,
    onError: Colors.white,
    brightness: Brightness.light,
  );

  static final TextTheme _textTheme = TextTheme(
    headline: GoogleFonts.roboto(fontSize: 32, fontWeight: FontWeight.bold),
    title: GoogleFonts.varelaRound(
        fontSize: 21,
        fontWeight: FontWeight.bold,
        textStyle: TextStyle(color: _colorSchemeLight.primary)),
    subhead: GoogleFonts.varelaRound(fontSize: 16, fontWeight: FontWeight.bold),
    subtitle:
        GoogleFonts.varelaRound(textStyle: TextStyle(color: Colors.grey[500])),
    body1: GoogleFonts.varelaRound(fontSize: 16),
    body2: GoogleFonts.roboto(
        fontSize: 16, textStyle: TextStyle(color: _colorSchemeLight.onSurface)),
    overline:
        GoogleFonts.varelaRound(textStyle: TextStyle(color: Colors.grey[500])),
    button: GoogleFonts.lato(
        fontSize: 14,
        textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
  );

  final ThemeData _themeData = ThemeData(
    colorScheme: _colorSchemeLight,
    primaryColor: _colorSchemeLight.primary,
    accentColor: _colorSchemeLight.secondary,
    backgroundColor: _colorSchemeLight.background,
    textTheme: _textTheme,
    buttonTheme: ButtonThemeData(
        textTheme: ButtonTextTheme.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
    inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4))),
    cardTheme: CardTheme(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),
    iconTheme: IconThemeData(
      color: _colorSchemeLight.surface,
    ),
    bottomSheetTheme: BottomSheetThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      localizationsDelegates: [
        const LocDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [const Locale('en'), const Locale('id')],
      theme: _themeData,
      onGenerateRoute: Router.generateRoute,
      initialRoute: Router.kRouteHome,
    );
  }
}
