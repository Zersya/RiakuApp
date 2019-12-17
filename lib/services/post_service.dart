import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riaku_app/models/post.dart';
import 'package:riaku_app/utils/enum.dart';
import 'package:riaku_app/utils/loc_delegate.dart';
import 'package:riaku_app/utils/my_response.dart';

class PostService {
  Firestore _firestore = Firestore.instance;

  Future<MyResponse> createPost(Post post) async {
    try {
      await _firestore
          .collection('posts')
          .document()
          .setData(post.toMap());

      return MyResponse(ResponseState.SUCCESS, post,
          message: LocDelegate.currentLoc.success.successCreate);
    } on SocketException {
      return MyResponse(ResponseState.ERROR, null,
          message: LocDelegate.currentLoc.error.connectionError);
    } on Exception {
      return MyResponse(ResponseState.ERROR, null,
          message: LocDelegate.currentLoc.error.exceptionError);
    }
  }

  Future<MyResponse> fetchPost() async {
    try {
      Stream<QuerySnapshot> snapshot =
          _firestore.collection('posts').orderBy('createdAt').snapshots();

      return MyResponse<Stream<QuerySnapshot>>(ResponseState.SUCCESS, snapshot,
          message: LocDelegate.currentLoc.success.successCreate);
    } on SocketException {
      return MyResponse(ResponseState.ERROR, null,
          message: LocDelegate.currentLoc.error.connectionError);
    } on Exception {
      return MyResponse(ResponseState.ERROR, null,
          message: LocDelegate.currentLoc.error.exceptionError);
    }
  }
}
