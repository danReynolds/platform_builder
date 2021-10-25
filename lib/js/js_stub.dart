import 'package:platform_builder/js/base_js.dart';

class JS implements BaseJs {
  @override
  get context {}

  @override
  get renderer {
    return FlutterRenderer.canvasKit;
  }
}
