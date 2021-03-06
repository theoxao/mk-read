import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mk/common/commons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PostImageView extends StatefulWidget {
  final List<String> images;
  final int _currentIndex;

  PostImageView(this.images, this._currentIndex);

  @override
  _PostImageViewState createState() => _PostImageViewState(_currentIndex);
}

class _PostImageViewState extends State<PostImageView> {
  var _currentIndex;

  _PostImageViewState(this._currentIndex);

  @override
  Widget build(BuildContext context) {
    print(_currentIndex);
    return Container(
      child: Hero(
        tag: widget.images[_currentIndex],
        child: CachedNetworkImage(
          imageUrl: widget.images[_currentIndex],
          placeholder: (context, url) {
            return SpinKitThreeBounce(
              color: primaryColor,
              size: primaryTextSize,
            );
          },
        ),
      ),
    );
  }
}
