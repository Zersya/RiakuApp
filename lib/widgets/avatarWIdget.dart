import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:riaku_app/utils/funcCommon.dart';

class AvatarWidget extends StatelessWidget {
  const AvatarWidget({
    Key key, this.radius, this.url,
  }) : super(key: key);
  final double radius;
  final String url;
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.grey[200],
      radius: radius,
          child: SvgPicture.network(
            generateAvatar(url),
            width: 100,
            placeholderBuilder: (BuildContext context) => Container(
                padding: const EdgeInsets.all(16.0),
                child: const CircularProgressIndicator()),
          ),
        );
  }
}