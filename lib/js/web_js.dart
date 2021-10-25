// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as _js;
import 'package:platform_builder/js/base_js.dart';

class JS implements BaseJs {
  @override
  get context {
    return _js.context;
  }

  @override
  get renderer {
    return _js.context['flutterCanvasKit'] != null
        ? FlutterRenderer.canvasKit
        : FlutterRenderer.html;
  }
}
