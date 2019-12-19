import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:riaku_app/generated/locale_base.dart';
import 'package:connectivity/connectivity.dart';
import 'package:riaku_app/models/post.dart';
import 'package:riaku_app/screens/post/createPost/createPost_bloc.dart';

class CreatePostScreen extends StatefulWidget {
  CreatePostScreen({Key key, @required this.createPostBloc}) : super(key: key);
  final CreatePostBloc createPostBloc;
  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  TextEditingController _controllerDesc = TextEditingController();
  StreamSubscription _subscription;
  CreatePostBloc _createPostBloc;

  @override
  void initState() {
    super.initState();
    _createPostBloc = widget.createPostBloc;

    _createPostBloc.fetchLocation();

    if (Platform.isAndroid) {
      _subscription = Connectivity()
          .onConnectivityChanged
          .listen((ConnectivityResult result) {
        _createPostBloc.setConnectivity(result);
      });
    } else {
      _createPostBloc.setConnectivity(ConnectivityResult.mobile);
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (Platform.isAndroid) {
      _subscription.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = Localizations.of<LocaleBase>(context, LocaleBase);

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        title: Text(
          loc.post.createPostLabel,
          style: Theme.of(context).textTheme.title,
        ),
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        actions: <Widget>[createPost(loc, context)],
      ),
      body: Container(
        child: FormStatus(
          controllerDesc: _controllerDesc,
          createPostBloc: _createPostBloc,
        ),
      ),
    );
  }

  Widget createPost(LocaleBase loc, BuildContext context) {
    return StreamBuilder<bool>(
        stream: _createPostBloc.isAbletoSend,
        initialData: false,
        builder: (context, snapshot) {
          bool isAbletoSend = snapshot.data;
          return InkWell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  loc.post.sendLabel,
                  style: isAbletoSend
                      ? Theme.of(context).textTheme.subhead
                      : Theme.of(context).textTheme.subtitle,
                ),
              ),
            ),
            onTap: isAbletoSend
                ? () {
                    _createPostBloc.submitPost(_controllerDesc.text, '',
                        DateTime.now().millisecondsSinceEpoch.toString());

                    Post post = Post(
                        _createPostBloc.currentLocation.locality,
                        null,
                        _controllerDesc.text,
                        '',
                        DateTime.now().millisecondsSinceEpoch.toString());
                    Navigator.pop(context, post);
                  }
                : null,
          );
        });
  }
}

class FormStatus extends StatelessWidget {
  const FormStatus(
      {Key key, @required this.controllerDesc, @required this.createPostBloc})
      : super(key: key);

  final controllerDesc;
  final CreatePostBloc createPostBloc;

  @override
  Widget build(BuildContext context) {
    final loc = Localizations.of<LocaleBase>(context, LocaleBase);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://wiki.d-addicts.com/images/thumb/4/4c/IU.jpg/220px-IU.jpg"),
              ),
              SizedBox(width: 16),
              Text(
                'IU',
                style: Theme.of(context).textTheme.subhead,
              )
            ],
          ),
          SizedBox(height: 16),
          Expanded(
            child: TextField(
              controller: controllerDesc,
              onChanged: (val) {
                createPostBloc.setIsNotEmpty(val);
              },
              maxLines: 5,
              maxLength: 720,
              decoration: InputDecoration(
                hintText: loc.post.hintPost,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          SafeArea(
            bottom: true,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: Border(
                      top: BorderSide(
                          color: Theme.of(context).colorScheme.onSurface))),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Icon(Icons.add_a_photo),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
