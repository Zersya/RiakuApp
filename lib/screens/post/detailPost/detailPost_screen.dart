import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:riaku_app/generated/locale_base.dart';
import 'package:riaku_app/models/comment.dart';
import 'package:riaku_app/models/post.dart';
import 'package:riaku_app/models/user.dart';
import 'package:riaku_app/screens/post/detailPost/detailPost_bloc.dart';
import 'package:riaku_app/utils/funcCommon.dart';
import 'package:riaku_app/widgets/itemPost.dart';
import 'package:timeago/timeago.dart' as timeago;

class DetailPostScreen extends StatefulWidget {
  DetailPostScreen({Key key, this.post}) : super(key: key);

  final Post post;

  @override
  _DetailPostScreenState createState() => _DetailPostScreenState();
}

class _DetailPostScreenState extends State<DetailPostScreen> {
  final DetailPostBloc _detailPostBloc = DetailPostBloc();
  TextEditingController _controller = TextEditingController();
  FocusNode _node = FocusNode();

  @override
  void initState() {
    super.initState();
    _detailPostBloc.fetchComment(widget.post);
  }

  @override
  Widget build(BuildContext context) {
    final loc = Localizations.of<LocaleBase>(context, LocaleBase);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              StreamBuilder<User>(
                  stream: _detailPostBloc.userStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData)
                      return Provider.value(
                        value: _detailPostBloc,
                        child: StreamBuilder<Post>(
                            stream: _detailPostBloc.postStream,
                            initialData: widget.post,
                            builder: (context, snapshot) {
                              return StreamBuilder<int>(
                                  stream: _detailPostBloc.countCommentStrea,
                                  initialData: 0,
                                  builder: (context, snapshot) {
                                    return ItemPost(
                                      postHelper: _detailPostBloc,
                                      post: widget.post,
                                      index: 0,
                                      isUpload: false,
                                    );
                                  });
                            }),
                      );
                    return Center(child: CircularProgressIndicator());
                  }),
              StreamBuilder<List<Comment>>(
                stream: _detailPostBloc.commentsStream,
                initialData: List(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    List<Comment> currentList = snapshot.data;
                    if (currentList.isEmpty) {
                      return Center(
                        child: Text(loc.post.noCommentLabel),
                      );
                    }
                    return ListView.separated(
                      shrinkWrap: true,
                      itemCount: currentList.length,
                      separatorBuilder: (context, index) {
                        return Container(
                          height: 2,
                          color: Theme.of(context).colorScheme.surface,
                        );
                      },
                      itemBuilder: (context, index) {
                        return Column(
                          children: <Widget>[
                            ListTile(
                              isThreeLine: true,
                              leading: CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(
                                    generateAvatar(currentList[index].user.id)),
                              ),
                              title: Text(
                                currentList[index].user.username,
                              ),
                              subtitle: Text(
                                currentList[index].message,
                              ),
                              trailing: Text(
                                timeago.format(
                                        DateTime.fromMillisecondsSinceEpoch(
                                            int.parse(
                                                currentList[index].createdAt)),
                                        locale: Locale.cachedLocaleString) ??
                                    '-',
                                style: Theme.of(context).textTheme.subtitle,
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
              )
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    maxLines: 2,
                    maxLength: 120,
                    controller: _controller,
                    focusNode: _node,
                    onTap: () {
                      _detailPostBloc.subjectFocusComment.add(true);
                    },
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(8.0),
                        fillColor: Colors.red,
                        hintText: loc.post.hintWriteComment,
                        border: UnderlineInputBorder()),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  StreamBuilder<bool>(
                      stream: _detailPostBloc.focusCommentStream,
                      initialData: false,
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data)
                          return Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: EdgeInsets.only(right: 8.0),
                              child: FlatButton(
                                child: Text(loc.post.addComentLabel),
                                onPressed: _addComment,
                              ),
                            ),
                          );
                        return SizedBox();
                      })
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _addComment() {
    _detailPostBloc.subjectFocusComment.sink.add(false);
    FocusScope.of(context).unfocus();
    Comment comment = Comment(_detailPostBloc.user,
        DateTime.now().millisecondsSinceEpoch.toString(), _controller.text);
    _controller.text = '';

    _detailPostBloc.submitComment(comment, widget.post);
  }
}
