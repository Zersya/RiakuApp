import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:riaku_app/models/post.dart';
import 'package:riaku_app/models/user.dart';
import 'package:riaku_app/services/post_service.dart';
import 'package:riaku_app/utils/enum.dart';
import 'package:riaku_app/utils/my_response.dart';
import 'package:riaku_app/utils/strKey.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardBloc extends BaseReponseBloc {
  PostService _servicePost;
  BehaviorSubject<List<Post>> _subjectPosts;
  BehaviorSubject<int> _subjectOnUploadIdx;
  BehaviorSubject<User> _subjectUser;

  List<Post> _currentList;
  int _index;

  User _user;

  DashboardBloc() {
    _servicePost = GetIt.I<PostService>();

    _subjectPosts = BehaviorSubject<List<Post>>();
    _subjectOnUploadIdx = BehaviorSubject<int>();
    _subjectUser = BehaviorSubject<User>();

    _currentList = List();

    _index = 0;
  }

  @override
  ValueStream<MyResponse> get responseStream => super.responseStream;

  ValueStream<List<Post>> get postsStream => _subjectPosts.stream;

  ValueStream<int> get onUploadIdxStream => _subjectOnUploadIdx.stream;

  ValueStream<User> get userStream => _subjectUser.stream;

  User get user => _user;

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

  Future likePost(Post post) async {
    post.likes = List.from(post.likes);
    post.likes.add(_user.id);
    _currentList.firstWhere((val) {
      if (val.id == post.id) val.likes = post.likes;
      return val.id == post.id;
    });
    _subjectPosts.sink.add(_currentList);
    
    MyResponse response = await _servicePost.likePost(post);
    this.subjectResponse.sink.add(response);
  }

  int yourLike(Post post) {
    int counter = 0;
    post.likes?.forEach((str) {
      if (str == _user.id) counter = counter + 1;
    });
    return counter;
  }

  Future fetchData() async {
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

  Future<User> fetchUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String email = pref.getString(kEmailKey);
    String id = pref.getString(kIdKey);
    String username = pref.getString(kUsernameKey);

    _user = User(email, id: id, username: username);
    _subjectUser.sink.add(_user);

    return _user;
  }

  @override
  void dispose() {
    super.dispose();
    _subjectPosts.close();
    _subjectOnUploadIdx.close();
    _subjectUser.close();
  }
}
