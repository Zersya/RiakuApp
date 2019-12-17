import 'package:flutter/material.dart';
import 'package:riaku_app/generated/locale_base.dart';

class ItemPost extends StatelessWidget {
  const ItemPost(
      {Key key,
      @required this.username,
      @required this.profileImage,
      @required this.imgStatus,
      @required this.description,
      @required this.timestamp,
      @required this.isUpload})
      : super(key: key);

  final String username;
  final String imgStatus;
  final String description;
  final String timestamp;
  final String profileImage;
  final bool isUpload;

  @override
  Widget build(BuildContext context) {
    final loc = Localizations.of<LocaleBase>(context, LocaleBase);

    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (isUpload)
            Container(
              padding: EdgeInsets.all(8.0),
              width: double.infinity,
              decoration:
                  BoxDecoration(color: Theme.of(context).colorScheme.surface),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                          width: 16.0,
                          height: 16.0,
                          child: CircularProgressIndicator()),
                      SizedBox(
                        width: 16.0,
                      ),
                      Text(loc.common.uploading,
                          style: Theme.of(context).textTheme.body2)
                    ],
                  )),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: NetworkImage(
                      this.profileImage),
                ),
                Expanded(
                  child: ListTile(
                    title: Text(
                      this.username,
                      style: Theme.of(context).textTheme.subhead,
                    ),
                    subtitle: Text(
                      '10 Menit',
                      style: Theme.of(context).textTheme.subtitle,
                    ),
                  ),
                )
              ],
            ),
          ),
          if (imgStatus.isNotEmpty)
            Image.network(
              this.imgStatus,
              fit: BoxFit.cover,
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Text(
              description,
              style: Theme.of(context).textTheme.body1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '100 ${loc.dashboard.likesLabel}',
                  style: Theme.of(context).textTheme.overline,
                ),
                Text('100 ${loc.dashboard.commentsLabel}',
                    style: Theme.of(context).textTheme.overline)
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                border: Border(
                    top: BorderSide(
                        color: Theme.of(context).colorScheme.onSurface))),
            child: Row(
              children: <Widget>[
                Expanded(
                    flex: 1,
                    child: Icon(
                      Icons.thumb_up,
                    )),
                Expanded(
                    flex: 1,
                    child: Icon(
                      Icons.comment,
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
