enum FlutterRenderer { canvasKit, html }

abstract class BaseJs {
  get context;
  FlutterRenderer get renderer;
}
