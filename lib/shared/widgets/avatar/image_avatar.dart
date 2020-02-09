import 'dart:io';

import 'package:flutter/material.dart';

import 'avatar.dart';

class ImageAvatar extends StatelessWidget {
  final File image;
  final double height;
  final double width;

  ImageAvatar({
    @required this.image,
    this.height = 60.0,
    this.width = 60.0,
  });

  @override
  Widget build(BuildContext context) {
    return Avatar(
      height: height,
      width: width,
      child: Container(
        height: height * 0.9,
        width: width * 0.9,
        decoration: new BoxDecoration(
            shape: BoxShape.circle,
            image: new DecorationImage(
                fit: BoxFit.contain, image: FileImage(image))),
      ),
    );
  }
}
