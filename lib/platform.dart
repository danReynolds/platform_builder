import 'dart:io' as io;
import 'package:flutter/foundation.dart';
import 'js/base_js.dart';
import 'js/js.dart';

const _chromeExtensionScheme = 'chrome-extension';

enum Platforms {
  android,
  chromeExtension,
  fuschia,
  iOS,
  linux,
  macOS,
  web,
  windows
}

/// A platform utility class that provides helpers for determining the current platform,
/// host platform, renderer and other platform checks.
class Platform {
  static Platform get instance {
    _instance ??= Platform._(
      supportedPlatforms: Platforms.values,
    );
    return _instance!;
  }

  static Platform? _instance;

  Platform._({
    required this.supportedPlatforms,
  });

  final List<Platforms> supportedPlatforms;

  static init({
    List<Platforms>? supportedPlatforms,
  }) {
    _instance = Platform._(
      supportedPlatforms: supportedPlatforms ?? Platforms.values,
    );
  }

  // Platform checks

  bool get isWeb {
    return kIsWeb;
  }

  /// Whether the application's platform is the same as the host platform.
  /// ex.1 If running Flutter web on macOS, the application's platform is web
  /// while the host's platform is macOS so it returns false.
  /// ex.2 If running Flutter for iOS on an iPhone then the application's platform is
  /// iOS and the host's platform is iOS so it returns true.
  bool get isNative {
    return current == currentHost;
  }

  bool get isAndroid {
    // Check that it is not web first since the native Android and iOS
    // checks throw errors on browser platforms
    return !isWeb && io.Platform.isAndroid;
  }

  bool get isIOS {
    // Check that it is not web first since the native Android and iOS
    // checks throw errors on browser platforms
    return !isWeb && io.Platform.isIOS;
  }

  bool get isChromeExtension {
    return isWeb && Uri.base.scheme == _chromeExtensionScheme;
  }

  bool get isFuschia {
    return io.Platform.isFuchsia;
  }

  bool get isMacOS {
    return io.Platform.isMacOS;
  }

  bool get isLinux {
    return io.Platform.isLinux;
  }

  bool get isWindows {
    return io.Platform.isWindows;
  }

  // Current platform checks

  /// The current platform the Flutter application us running on.
  Platforms get current {
    if (isChromeExtension) {
      return Platforms.chromeExtension;
    }

    if (isWeb) {
      return Platforms.web;
    }

    if (isAndroid) {
      return Platforms.android;
    }

    if (isIOS) {
      return Platforms.iOS;
    }

    if (isMacOS) {
      return Platforms.macOS;
    }

    if (isLinux) {
      return Platforms.linux;
    }

    if (isFuschia) {
      return Platforms.fuschia;
    }

    throw 'unsupported platform';
  }

  /// The application's host operating system. In the example of running Flutter web
  /// on an iPhone, the host would be iOS.
  Platforms get currentHost {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return Platforms.android;
      case TargetPlatform.fuchsia:
        return Platforms.fuschia;
      case TargetPlatform.iOS:
        return Platforms.iOS;
      case TargetPlatform.linux:
        return Platforms.linux;
      case TargetPlatform.macOS:
        return Platforms.macOS;
      case TargetPlatform.windows:
        return Platforms.windows;
    }
  }

  // Renderer platform checks

  bool get isCanvasKit {
    return PlatformJS.instance.renderer == FlutterRenderer.canvasKit;
  }

  bool get isHtml {
    return PlatformJS.instance.renderer == FlutterRenderer.html;
  }
}
