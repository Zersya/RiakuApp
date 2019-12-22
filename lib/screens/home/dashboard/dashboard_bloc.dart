import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:riaku_app/helper/postHelper.dart';
import 'package:riaku_app/models/post.dart';
import 'package:riaku_app/services/post_service.dart';
import 'package:riaku_app/utils/enum.dart';
import 'package:riaku_app/helper/my_response.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class DashboardBloc extends PostHelper {
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

  @override
  Future<Post> likePost(Post post, int index, bool isLike) async {
    _currentList[index] = post;
    _subjectPosts.sink.add(_currentList);

    Post _post = await super.likePost(post, index, isLike);

    return _post;
  }

  Future fetchPost() async {
    MyResponse<Stream<QuerySnapshot>> response = await _servicePost.fetchPost();
    this.subjectResponse.sink.add(response);

    if (response.responseState == ResponseState.SUCCESS) {
      response.result.listen((val) {
        _currentList = val.documents.map((v) => Post.fromMap(v.data)).toList();
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
