import 'package:flutter/material.dart';
import 'package:riaku_app/screens/auth/auth_screen.dart';
import 'package:riaku_app/screens/auth/login/login_screen.dart';
import 'package:riaku_app/screens/auth/register/register_screen.dart';
import 'package:riaku_app/screens/post/createPost/createPost_screen.dart';
import 'package:riaku_app/screens/home/home_screen.dart';
import 'package:riaku_app/screens/splash/splash_screen.dart';

class Router {
  static const kRouteSplash = '/splash';
  static const kRouteHome = '/home';
  static const kRouteAddPost = '/home/addStatus';
  static const kRouteRegister = '/register';
  static const kRouteLogin = '/login';
  static const kRouteAuth = '/auth';


  static Route<dynamic> generateRoute(RouteSettings settings) {
    print(settings.name);
    switch (settings.name) {
      case kRouteSplash:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case kRouteAuth:
        return MaterialPageRoute(builder: (_) => AuthScreen());
      case kRouteRegister:
        return MaterialPageRoute(builder: (_) => RegisterScreen());
      case kRouteLogin:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case kRouteHome:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case kRouteAddPost:
        return MaterialPageRoute(
            builder: (_) => CreatePostScreen(
                  createPostBloc: settings.arguments,
                ));
      default:
        return MaterialPageRoute(builder: (_) => HomeScreen());
    }
  }
}
