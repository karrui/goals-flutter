import 'package:cached_network_image/cached_network_image.dart';
import 'package:clay_containers/widgets/clay_containers.dart';
import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final String imageUrl;
  final double height;
  final double width;

  Avatar({
    @required this.imageUrl,
    this.height = 60.0,
    this.width = 60.0,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        ClayContainer(
          height: height,
          width: width,
          borderRadius: 30,
          color: Theme.of(context).backgroundColor,
          depth: 8,
          spread: 5,
          child: Container(
            height: height,
            width: width,
            alignment: Alignment.center,
            child: CachedNetworkImage(
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
          ),
        ),
      ],
    );
  }
}
