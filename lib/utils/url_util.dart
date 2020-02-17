import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlUtil {
  static launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw PlatformException(
          code: "Error", message: 'Could not launch $url', details: null);
    }
  }
}
