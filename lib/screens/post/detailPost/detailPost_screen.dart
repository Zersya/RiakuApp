import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:riaku_app/helper/my_response.dart';
import 'package:riaku_app/models/post.dart';
import 'package:riaku_app/models/user.dart';
import 'package:riaku_app/screens/post/detailPost/detailPost_bloc.dart';
import 'package:riaku_app/widgets/itemPost.dart';

class DetailPostScreen extends StatefulWidget {
  DetailPostScreen({Key key, this.post}) : super(key: key);

  final Post post;

  @override
  _DetailPostScreenState createState() => _DetailPostScreenState();
}

class _DetailPostScreenState extends State<DetailPostScreen> {
  final DetailPostBloc _detailPostBloc = DetailPostBloc();

  @override
  void initState() { 
    super.initState();
    _detailPostBloc.fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: StreamBuilder<User>(
          stream: _detailPostBloc.userStream,
          builder: (context, snapshot) {
            if (snapshot.hasData)
              return Provider.value(
                value: _detailPostBloc,
                child: StreamBuilder<Post>(
                  stream: _detailPostBloc.postStream,
                  initialData: widget.post,
                  builder: (context, snapshot) {
                    return ItemPost(
                      postHelper: _detailPostBloc,
                      post: widget.post,
                      index: 0,
                      isUpload: false,
                    );
                  }
                ),
              );
            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
