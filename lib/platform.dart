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
      supportedPlatforms: Platforms.values.toSet(),
    );
    return _instance!;
  }

  static Platform? _instance;

  Platforms? override;
  Platforms? overrideHost;

  Platform._({
    required this.supportedPlatforms,
    this.override,
    this.overrideHost,
  });

  final Set<Platforms> supportedPlatforms;

  static init({
    Set<Platforms>? supportedPlatforms,
    Platforms? override,
    Platforms? overrideHost,
  }) {
    _instance = Platform._(
      supportedPlatforms: supportedPlatforms ?? Platforms.values.toSet(),
      override: override,
      overrideHost: overrideHost,
    );
  }

  // Internal platform checks

  bool get _isWeb {
    return kIsWeb;
  }

  bool get _isAndroid {
    // Check that it is not web first since the native Android and iOS
    // checks throw errors on browser platforms
    return !_isWeb && io.Platform.isAndroid;
  }

  bool get _isIOS {
    // Check that it is not web first since the native Android and iOS
    // checks throw errors on browser platforms
    return !_isWeb && io.Platform.isIOS;
  }

  bool get _isChromeExtension {
    return _isWeb && Uri.base.scheme == _chromeExtensionScheme;
  }

  bool get _isFuschia {
    return io.Platform.isFuchsia;
  }

  bool get _isMacOS {
    return io.Platform.isMacOS;
  }

  bool get _isLinux {
    return io.Platform.isLinux;
  }

  bool get _isWindows {
    return io.Platform.isWindows;
  }

  // Public platform checks

  /// Whether the application's platform is the same as the host platform.
  /// ex.1 If running Flutter web on macOS, the application's platform is web
  /// while the host's platform is macOS so it returns false.
  /// ex.2 If running Flutter for iOS on an iPhone then the application's platform is
  /// iOS and the host's platform is iOS so it returns true.
  bool get isNative {
    return current == currentHost;
  }

  bool get isWeb =>
      current == Platforms.web || current == Platforms.chromeExtension;

  bool get isAndroid => current == Platforms.android;
  bool get isIOS => current == Platforms.iOS;
  bool get isChromeExtension => current == Platforms.chromeExtension;
  bool get isFuschia => current == Platforms.fuschia;
  bool get isMacOS => current == Platforms.macOS;
  bool get isLinux => current == Platforms.linux;
  bool get isWindows => current == Platforms.windows;

  // Current platform checks

  /// The current platform the Flutter application us running on.
  Platforms get current {
    // Return the override for the current platform if present.
    if (override != null) {
      return override!;
    }

    if (_isChromeExtension) {
      return Platforms.chromeExtension;
    }

    if (_isWeb) {
      return Platforms.web;
    }

    if (_isAndroid) {
      return Platforms.android;
    }

    if (_isIOS) {
      return Platforms.iOS;
    }

    if (_isMacOS) {
      return Platforms.macOS;
    }

    if (_isLinux) {
      return Platforms.linux;
    }

    if (_isFuschia) {
      return Platforms.fuschia;
    }

    if (_isWindows) {
      return Platforms.windows;
    }

    throw 'unsupported platform';
  }

  /// The application's host operating system. In the example of running Flutter web
  /// on an iPhone, the host would be iOS.
  Platforms get currentHost {
    if (overrideHost != null) {
      return overrideHost!;
    }

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
