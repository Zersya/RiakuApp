import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoder/services/local.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:riaku_app/services/auth_service.dart';
import 'package:riaku_app/services/geo_service.dart';
import 'package:riaku_app/services/post_service.dart';

GetIt getIt = GetIt.instance;

void locator(Firestore firestore, bool isTest,
    {FirebaseAuth auth, Geolocator geoloc, LocalGeocoding geocod}) {
      
  if (isTest) {
    getIt.reset();
  }

  getIt.registerLazySingleton<AuthService>(() => AuthService(firestore, auth));
  getIt.registerLazySingleton<PostService>(() => PostService(firestore));
  getIt.registerLazySingleton<GeoService>(() => GeoService(geoloc, geocod));
}
