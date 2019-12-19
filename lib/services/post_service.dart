import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Riaku/models/post.dart';
import 'package:Riaku/utils/enum.dart';
import 'package:Riaku/utils/loc_delegate.dart';
import 'package:Riaku/utils/my_response.dart';

class PostService {
  Firestore _firestore = Firestore.instance;

  Future<MyResponse> likePost(Post post) async {
    try {
      
      await _firestore
          .collection('posts')
          .document(post.id)
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

  Future<MyResponse> createPost(Post post) async {
    try {
      post.id = _firestore.collection('posts').document().documentID;

      await _firestore
          .collection('posts')
          .document(post.id)
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
