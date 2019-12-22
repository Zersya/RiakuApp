import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riaku_app/models/comment.dart';
import 'package:riaku_app/models/post.dart';
import 'package:riaku_app/utils/enum.dart';
import 'package:riaku_app/helper/loc_delegate.dart';
import 'package:riaku_app/helper/my_response.dart';

class PostService {
  final Firestore firestore;

  PostService(this.firestore);
  
  Future<MyResponse> fetchComment(Post post) async {
    try {
      final docRef = firestore.collection('posts').document(post.id);
      docRef.setData(post.toMap());

      Stream<QuerySnapshot> snapshot = firestore
          .collection('comments')
          .where('docRef', isEqualTo: docRef).orderBy('createdAt').snapshots();

      return MyResponse<Stream<QuerySnapshot>>(ResponseState.SUCCESS, snapshot,
          message: LocDelegate.currentLoc.success.successCreate);
    } on SocketException {
      return MyResponse<Stream<QuerySnapshot>>(ResponseState.ERROR, null,
          message: LocDelegate.currentLoc.error.connectionError);
    } on Exception {
      return MyResponse<Stream<QuerySnapshot>>(ResponseState.ERROR, null,
          message: LocDelegate.currentLoc.error.exceptionError);
    }
  }

  Future<MyResponse> commentPost(Comment comment, Post post) async {
    try {
      final commentId = firestore.collection('comments').document().documentID;
      comment.ref = firestore.collection('posts').document(post.id);

      await firestore
          .collection('comments')
          .document(commentId)
          .setData(comment.toMap());

      return MyResponse(ResponseState.SUCCESS, comment,
          message: LocDelegate.currentLoc.success.successCreate);
    } on SocketException {
      return MyResponse(ResponseState.ERROR, null,
          message: LocDelegate.currentLoc.error.connectionError);
    } on Exception {
      return MyResponse(ResponseState.ERROR, null,
          message: LocDelegate.currentLoc.error.exceptionError);
    }
  }

  Future<MyResponse> likePost(Post post) async {
    try {
      await firestore
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

  Future<MyResponse> deletePost(Post post) async {
    try {
      final docRef = firestore.collection('posts').document(post.id);
      docRef.delete();

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
      post.id = firestore.collection('posts').document().documentID;

      await firestore
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
          firestore.collection('posts').orderBy('createdAt').snapshots();

      return MyResponse<Stream<QuerySnapshot>>(ResponseState.SUCCESS, snapshot,
          message: LocDelegate.currentLoc.success.successCreate);
    } on SocketException {
      return MyResponse<Stream<QuerySnapshot>>(ResponseState.ERROR, null,
          message: LocDelegate.currentLoc.error.connectionError);
    } on Exception {
      return MyResponse<Stream<QuerySnapshot>>(ResponseState.ERROR, null,
          message: LocDelegate.currentLoc.error.exceptionError);
    }
  }
}
