import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riaku_app/models/post.dart';
import 'package:riaku_app/models/user.dart';
import 'package:riaku_app/services/post_service.dart';
import 'package:riaku_app/utils/my_response.dart';
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

  User _user;

  DashboardBloc() {
    _servicePost = PostService();

    _subjectPosts = BehaviorSubject<List<Post>>();
    _subjectOnUploadIdx = BehaviorSubject<int>();

    _currentList = List();

    _index = 0;
  }

  @override
  ValueStream<MyResponse> get responseStream => super.responseStream;

  ValueStream<List<Post>> get postsStream => _subjectPosts.stream;

  ValueStream<int> get onUploadIdxStream => _subjectOnUploadIdx.stream;

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

  void fetchData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String email = pref.getString(kEmailKey);
    String id = pref.getString(kIdKey);
    String username = pref.getString(kUsernameKey);

    _user = User(email, id: id, username: username);
   
    MyResponse<Stream<QuerySnapshot>> response = await _servicePost.fetchPost();
    response.result.listen((val) {
      _currentList = val.documents.map((v) => Post.formMap(v.data)).toList();
      _currentList = _currentList.reversed.toList();

      _subjectOnUploadIdx.sink.add(_index);
      _subjectPosts.sink.add(_currentList);
      this.subjectResponse.sink.add(response);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _subjectPosts.close();
    _subjectOnUploadIdx.close();
  }
}
