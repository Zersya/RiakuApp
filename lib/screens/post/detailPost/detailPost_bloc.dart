import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riaku_app/helper/my_response.dart';
import 'package:riaku_app/helper/postHelper.dart';
import 'package:riaku_app/models/comment.dart';
import 'package:riaku_app/models/post.dart';
import 'package:riaku_app/utils/enum.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class DetailPostBloc extends PostHelper {
  BehaviorSubject<Post> _subjectPost;
  BehaviorSubject<List<Comment>> _subjectComments;

  BehaviorSubject<bool> subjectFocusComment;
  BehaviorSubject<int> subjectCountComment;

  List<Comment> _currentList = List();

  

  DetailPostBloc() {
    _subjectPost = BehaviorSubject<Post>();
    _subjectComments = BehaviorSubject<List<Comment>>();
    subjectFocusComment = BehaviorSubject<bool>();
    subjectCountComment = BehaviorSubject<int>();
  }

  ValueStream<Post> get postStream => _subjectPost.stream;
  ValueStream<List<Comment>> get commentsStream => _subjectComments.stream;
  ValueStream<bool> get focusCommentStream => subjectFocusComment.stream;
  ValueStream<int> get countCommentStrea => subjectCountComment.stream;

  Future submitComment(Comment comment, Post post) async {
    _currentList.add(comment);
    _subjectComments.sink.add(_currentList);
    post.countComment = _currentList.length;
    subjectCountComment.sink.add(post.countComment);

    MyResponse response = await super.servicePost.commentPost(comment, post);
    super.subjectResponse.sink.add(response);
  }

  Future fetchComment(Post post) async {
    MyResponse<Stream<QuerySnapshot>> response =
        await super.servicePost.fetchComment(post);
    super.subjectResponse.sink.add(response);

    if (response.responseState == ResponseState.SUCCESS) {
      response.result.listen((val) {
        _currentList =
            val.documents.map((v) => Comment.fromMap(v.data)).toList();
        _currentList = _currentList.reversed.toList();

        _subjectComments.sink.add(_currentList);
      });
    }
  }

  @override
  Future<Post> likePost(Post post, int index, bool isLike) async {
    _subjectPost.sink.add(post);

    Post _post = await super.likePost(post, index, isLike);

    return _post;
  }

  void dispose() {
    _subjectPost.close();
    _subjectComments.close();
    subjectFocusComment.close();
    subjectCountComment.close();
  }
}
