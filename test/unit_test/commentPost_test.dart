import 'dart:io';
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:riaku_app/helper/loc_delegate.dart';
import 'package:riaku_app/helper/locator.dart';
import 'package:riaku_app/helper/my_response.dart';
import 'package:riaku_app/models/comment.dart';
import 'package:riaku_app/models/post.dart';
import 'package:riaku_app/models/user.dart';
import 'package:riaku_app/screens/post/detailPost/detailPost_bloc.dart';
import 'package:riaku_app/utils/enum.dart';
import 'package:riaku_app/utils/strKey.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'mock.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MockFirestore firestore;
  MockQuery query;
  MockValStream snapshots;
  MockDocumentReference docRef;

  LocDelegate locDelegate;
  Post post;
  Comment comment;

  setUpAll(() {
    SharedPreferences.setMockInitialValues({
      kEmailKey: 'mail@mail.com',
      kIdKey: 'mail@mail.com',
      kUsernameKey: 'mail-mail'
    });

    firestore = MockFirestore();
    query = MockQuery();
    snapshots = MockValStream();
    docRef = MockDocumentReference();

    locator(firestore, true);

    locDelegate = LocDelegate();
    locDelegate.load(Locale('en'));

    post = Post('home', User('mail@mail.com', id: 'mail@mail.com'), 'desc',
        null, DateTime.now().millisecondsSinceEpoch.toString(),
        likes: ['mail@mail.com', 'mail@mail.com']);

    comment = Comment(User('mail@mail.com', id: 'mail@mail.com'),
        DateTime.now().millisecondsSinceEpoch.toString(), 'message');
  });

  group('UI Test', () {
    test('your post likes', () async {
      DetailPostBloc bloc = DetailPostBloc();
      await bloc.fetchUser();

      int counter = bloc.yourLike(post);

      expect(counter, 2);

      // bloc.dispose();
    });
  });

  group('Post Comment', () {
    stubDocComments() {
      MockCollectionReference colRef = MockCollectionReference();
      when(firestore.collection('posts')).thenAnswer((_) => colRef);
      when(colRef.document(any)).thenAnswer((_) => docRef);
      when(docRef.collection('comments')).thenAnswer((_) => colRef);
      when(colRef.document(any)).thenAnswer((_) => docRef);
    }

    stubDocPosts() {
      MockCollectionReference colRef = MockCollectionReference();
      when(firestore.collection('posts')).thenAnswer((_) => colRef);
      when(colRef.document(any)).thenAnswer((_) => docRef);
    }

    stubDocCommentsErr(response) {
      MockCollectionReference colRef = MockCollectionReference();
      when(firestore.collection('posts')).thenAnswer((_) => colRef);
      when(colRef.document(any)).thenAnswer((_) => docRef);
      when(docRef.collection('comments')).thenAnswer((_) => colRef);
      when(colRef.document(any)).thenThrow(response);
    }

    test('success create', () async {
      DetailPostBloc bloc = DetailPostBloc();

      stubDocComments();
      stubDocPosts();
      await bloc.submitComment(comment, post);

      MyResponse response = bloc.subjectResponse.stream.value;

      expect(response.responseState, ResponseState.SUCCESS);
      expect(response.message, LocDelegate.currentLoc.success.successCreate);

      bloc.dispose();
    });

    test('exception', () async {
      DetailPostBloc bloc = DetailPostBloc();

      stubDocCommentsErr(
          Exception(LocDelegate.currentLoc.error.exceptionError));

      await bloc.submitComment(comment, post);

      MyResponse response = bloc.subjectResponse.stream.value;

      expect(response.responseState, ResponseState.ERROR);
      expect(response.message, LocDelegate.currentLoc.error.exceptionError);

      bloc.dispose();
    });

    test('socketexception', () async {
      DetailPostBloc bloc = DetailPostBloc();

      stubDocCommentsErr(
          SocketException(LocDelegate.currentLoc.error.connectionError));

      await bloc.submitComment(comment, post);

      MyResponse response = bloc.subjectResponse.stream.value;

      expect(response.responseState, ResponseState.ERROR);
      expect(response.message, LocDelegate.currentLoc.error.connectionError);

      bloc.dispose();
    });
  });

  group('Fetch Comment', () {
   
    stubDocComments() {
      MockCollectionReference colRef = MockCollectionReference();
      when(firestore.collection('posts')).thenAnswer((_) => colRef);

      when(colRef.document(any)).thenAnswer((_) => docRef);

      when(docRef.collection('comments')).thenAnswer((_) => colRef);

      when(colRef
            .orderBy('createdAt',
                descending: true))
          .thenAnswer((_) => query);

      when(query.snapshots()).thenAnswer((_) => snapshots);
    }

    stubDocCommentsErr(response) {
      MockCollectionReference colRef = MockCollectionReference();
      when(firestore.collection('posts')).thenAnswer((_) => colRef);

      when(colRef.document(any)).thenAnswer((_) => docRef);

      when(docRef.collection('comments')).thenAnswer((_) => colRef);

      when(colRef
            .orderBy('createdAt',
                descending: true))
          .thenAnswer((_) => query);

      when(query.snapshots()).thenThrow(response);
    }

    test('success', () async {
      DetailPostBloc bloc = DetailPostBloc();
      await bloc.fetchUser();
      User user = bloc.userStream.value;

      expect(user, isNotNull);
      expect(user.id, 'mail@mail.com');

      stubDocComments();

      await bloc.fetchComment(post);

      MyResponse response = bloc.subjectResponse.stream.value;
      expect(response.responseState, ResponseState.SUCCESS);
      expect(response.message, LocDelegate.currentLoc.success.successCreate);

      bloc.dispose();
    });

    test('exception', () async {
      DetailPostBloc bloc = DetailPostBloc();
      await bloc.fetchUser();
      User user = bloc.userStream.value;

      expect(user, isNotNull);
      expect(user.id, 'mail@mail.com');

      stubDocCommentsErr(Exception(LocDelegate.currentLoc.error.exceptionError));

      await bloc.fetchComment(post);

      MyResponse response = bloc.subjectResponse.stream.value;

      expect(response.responseState, ResponseState.ERROR);
      expect(response.message, LocDelegate.currentLoc.error.exceptionError);

      bloc.dispose();
    });

    test('socketexception', () async {
      DetailPostBloc bloc = DetailPostBloc();
      await bloc.fetchUser();
      User user = bloc.userStream.value;

      expect(user, isNotNull);
      expect(user.id, 'mail@mail.com');

      stubDocCommentsErr(
          SocketException(LocDelegate.currentLoc.error.connectionError));

      await bloc.fetchComment(post);

      MyResponse response = bloc.subjectResponse.stream.value;

      expect(response.responseState, ResponseState.ERROR);
      expect(response.message, LocDelegate.currentLoc.error.connectionError);

      bloc.dispose();
    });
  });
}
