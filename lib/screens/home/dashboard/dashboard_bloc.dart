import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:riaku_app/models/post.dart';
import 'package:riaku_app/models/user.dart';
import 'package:riaku_app/services/post_service.dart';
import 'package:riaku_app/utils/enum.dart';
import 'package:riaku_app/helper/my_response.dart';
import 'package:riaku_app/utils/strKey.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardBloc extends BaseReponseBloc {
  PostService _servicePost;
  BehaviorSubject<List<Post>> _subjectPosts;
  BehaviorSubject<int> _subjectOnUploadIdx;

  List<Post> _currentList;
  int _index;

  DashboardBloc() {
    
    _servicePost = GetIt.I<PostService>();

    _subjectPosts = BehaviorSubject<List<Post>>();
    _subjectOnUploadIdx = BehaviorSubject<int>();

    _currentList = List();

    _index = 0;

    
  }

  @override
  ValueStream<MyResponse> get responseStream => super.responseStream;

  ValueStream<List<Post>> get postsStream => _subjectPosts.stream;

  ValueStream<int> get onUploadIdxStream => _subjectOnUploadIdx.stream;

  void setListData(Post post) {
    _currentList.add(post);
    _currentList = _currentList.reversed.toList();

    _subjectOnUploadIdx.sink.add(_index);
    _subjectPosts.sink.add(_currentList);

    _index = _index + 1;
  }

  void decreaseOnUploadIdx() {
    _index = _index - 1;
    _subjectOnUploadIdx.sink.add(_index);
  }

  Future likePost(Post post, int index, bool isLike) async {
    post.likes = List.from(post.likes);

    if (isLike) {
      post.likes.add(super.user.id);
    } else {
      post.likes.removeWhere((like) => like == super.user.id);
    }
    _currentList[index] = post;
    _subjectPosts.sink.add(_currentList);

    MyResponse response = await _servicePost.likePost(post);
    this.subjectResponse.sink.add(response);
  }

  int yourLike(Post post) {
    int counter = 0;
    post.likes?.forEach((str) {
      if (str == super.user.id) counter = counter + 1;
    });
    return counter;
  }

  Future deletePost(Post post) async {
    MyResponse response = await _servicePost.deletePost(post);
    this.subjectResponse.sink.add(response);
  }

  bool isAble2Delete(Post post) {
    int delayTimeMinute = 10;

    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(int.parse(post.createdAt));

    bool data =
        (dateTime.difference(DateTime.now()).inMinutes.abs() < delayTimeMinute);
    return data;
  }

  Future fetchPost() async {
    MyResponse<Stream<QuerySnapshot>> response = await _servicePost.fetchPost();
    this.subjectResponse.sink.add(response);

    if (response.responseState == ResponseState.SUCCESS) {
      response.result.listen((val) {
        _currentList = val.documents.map((v) => Post.formMap(v.data)).toList();
        _currentList = _currentList.reversed.toList();

        _subjectOnUploadIdx.sink.add(_index);
        _subjectPosts.sink.add(_currentList);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _subjectPosts.close();
    _subjectOnUploadIdx.close();
  }
}
