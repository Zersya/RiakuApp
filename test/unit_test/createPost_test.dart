import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/services/local.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mockito/mockito.dart';
import 'package:riaku_app/models/user.dart';
import 'package:riaku_app/screens/post/createPost/createPost_bloc.dart';
import 'package:riaku_app/utils/enum.dart';
import 'package:riaku_app/utils/loc_delegate.dart';
import 'package:riaku_app/utils/locator.dart';
import 'package:riaku_app/utils/my_response.dart';
import 'package:riaku_app/utils/strKey.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockFirestore extends Mock implements Firestore {}

class MockCollectionReference extends Mock implements CollectionReference {}

class MockDocumentReference extends Mock implements DocumentReference {}

class MockDocumentSnapshot extends Mock implements DocumentSnapshot {
  String documentID = '123';
  Map<String, dynamic> data = {
    'id': 'mail@mail.com',
    'username': 'mail-mail',
    'email': 'mail@mail.com'
  };
}

class MockGeolocator extends Mock implements Geolocator {}

class MockGeocoding extends Mock implements LocalGeocoding {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MockFirestore firestore;
  MockGeolocator geolocator;
  MockGeocoding geocoding;

  LocDelegate locDelegate;

  group('UI visible btn', () {
    setUpAll(() {
      locator(firestore, true);
    });

    test('connectivity', () {
      CreatePostBloc bloc = CreatePostBloc();
      bloc.setConnectivity(ConnectivityResult.mobile);

      bool isConnect = bloc.connectivityStream.value;

      expect(isConnect, true);

      bloc.setConnectivity(ConnectivityResult.none);
      isConnect = bloc.connectivityStream.value;

      expect(isConnect, false);

      bloc.setConnectivity(ConnectivityResult.wifi);
      isConnect = bloc.connectivityStream.value;

      expect(isConnect, true);
    });

    test('field not empty', () {
      CreatePostBloc bloc = CreatePostBloc();
      bloc.setIsNotEmpty('');

      bool isNotEmpty = bloc.isNotEmptyStream.value;

      expect(isNotEmpty, false);

      bloc.setIsNotEmpty('wew');
      isNotEmpty = bloc.isNotEmptyStream.value;

      expect(isNotEmpty, true);
    });

    test('able to send', () async {
      CreatePostBloc bloc = CreatePostBloc();
      bloc.setIsNotEmpty('');
      bloc.setConnectivity(ConnectivityResult.wifi);

      bloc.isAbletoSend.listen((val) {
        bool isAble2Send = val;
        expect(isAble2Send, false);
      });
    });
  });

  group('Create Post', () {
    setUpAll(() {
      SharedPreferences.setMockInitialValues({
        kEmailKey: 'mail@mail.com',
        kIdKey: 'mail@mail.com',
        kUsernameKey: 'mail-mail'
      });

      firestore = MockFirestore();
      geolocator = MockGeolocator();
      geocoding = MockGeocoding();

      locator(firestore, true, geoloc: geolocator, geocod: geocoding);

      locDelegate = LocDelegate();
      locDelegate.load(Locale('en'));
    });

    stubDocDocId() {
      MockCollectionReference colRef = MockCollectionReference();
      when(firestore.collection('posts')).thenAnswer((_) => colRef);

      MockDocumentReference docRef = MockDocumentReference();
      when(colRef.document('123')).thenAnswer((_) => docRef);

      when(docRef.documentID).thenAnswer((_) => '123');
    }

    stubCreatePost() {
      MockCollectionReference colRef = MockCollectionReference();
      when(firestore.collection('posts')).thenAnswer((_) => colRef);

      MockDocumentReference docRef = MockDocumentReference();
      when(colRef.document(any)).thenAnswer((_) => docRef);

      when(docRef.setData(any)).thenAnswer((_) => null);
    }

    stubCreatePostErr(response) {
      MockCollectionReference colRef = MockCollectionReference();
      when(firestore.collection('posts')).thenAnswer((_) => colRef);

      MockDocumentReference docRef = MockDocumentReference();
      when(colRef.document(any)).thenAnswer((_) => docRef);

      when(docRef.setData(any)).thenThrow(response);
    }

    stubGeoService() {
      when(geolocator.getLastKnownPosition(
              desiredAccuracy: LocationAccuracy.medium))
          .thenAnswer(
              (_) => Future.value(Position(longitude: 1.0, latitude: 1.0)));
      when(geocoding.findAddressesFromCoordinates(any))
          .thenAnswer((_) => Future.value([Address(locality: 'home')]));
    }

    test('success create', () async {
      CreatePostBloc bloc = CreatePostBloc();
      bloc.user =
          User('mail@mail.com', id: 'mail@mail.com', username: 'mail-mail');

      stubGeoService();
      await bloc.fetchLocation();

      expect(bloc.currentLocation.locality, 'home');

      stubDocDocId();
      stubCreatePost();

      await bloc.submitPost('1234', null, '1234');

      MyResponse response = bloc.subjectResponse.stream.value;

      expect(response.responseState, ResponseState.SUCCESS);
      expect(response.message, LocDelegate.currentLoc.success.successCreate);

      bloc.dispose();
    });

    test('failed create exception', () async {
      CreatePostBloc bloc = CreatePostBloc();

      stubGeoService();
      await bloc.fetchLocation();

      expect(bloc.currentLocation.locality, 'home');

      stubDocDocId();
      stubCreatePostErr(Exception(LocDelegate.currentLoc.error.exceptionError));

      await bloc.submitPost('1234', null, '1234');

      MyResponse response = bloc.subjectResponse.stream.value;

      expect(response.responseState, ResponseState.ERROR);
      expect(response.message, LocDelegate.currentLoc.error.exceptionError);

      bloc.dispose();
    });

    test('failed create socketexception', () async {
      CreatePostBloc bloc = CreatePostBloc();

      stubGeoService();
      await bloc.fetchLocation();

      expect(bloc.currentLocation.locality, 'home');

      stubDocDocId();
      stubCreatePostErr(
          SocketException(LocDelegate.currentLoc.error.connectionError));

      await bloc.submitPost('1234', null, '1234');

      MyResponse response = bloc.subjectResponse.stream.value;

      expect(response.responseState, ResponseState.ERROR);
      expect(response.message, LocDelegate.currentLoc.error.connectionError);

      bloc.dispose();
    });
  });
}
