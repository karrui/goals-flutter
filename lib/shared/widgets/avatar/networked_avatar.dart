import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'avatar.dart';

class NetworkedAvatar extends StatelessWidget {
  final String imageUrl;
  final double height;
  final double width;
  final bool isLoading;

  NetworkedAvatar({
    @required this.imageUrl,
    this.height = 60.0,
    this.width = 60.0,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Avatar(
      height: height,
      width: width,
      child: isLoading
          ? CircularProgressIndicator()
          : CachedNetworkImage(
              imageUrl: imageUrl,
              imageBuilder: (context, imageProvider) => Container(
                height: height * 0.9,
                width: width * 0.9,
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  image: new DecorationImage(
                      fit: BoxFit.contain, image: imageProvider),
                ),
              ),
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
    );
  }
}
