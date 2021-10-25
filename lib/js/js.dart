// A conditional import is used to only require a class that accesses the web only dart:js library
// if we're on web. Otherwise it loads a no-op native class. This is required because shared web/native
// code requires services like the chrome extension service that uses dart:js
import 'package:platform_builder/js/js_stub.dart'
    if (dart.library.js) 'package:platform_builder/js/web_js.dart'
    if (dart.library.io) 'package:platform_builder/js/native_js.dart';

class PlatformJS {
  static final JS instance = JS();
}
