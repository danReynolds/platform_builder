import 'dart:io' as io;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'js/base_js.dart';
import 'js/js.dart';

const _chromeExtensionScheme = 'chrome-extension';
const defaultDesktopFormFactorBreakpoint = 760;

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

class Platform {
  static Platform get instance {
    _instance ??= Platform._(
      supportedPlatforms: Platforms.values,
    );
    return _instance!;
  }

  static Platform? _instance;

  Platform._({
    this.desktopBreakpoint,
    this.navigatorKey,
    required this.supportedPlatforms,
  });

  final int? desktopBreakpoint;
  final GlobalKey<NavigatorState>? navigatorKey;
  final List<Platforms> supportedPlatforms;

  static init({
    int? desktopBreakpoint,
    GlobalKey<NavigatorState>? navigatorKey,
    List<Platforms>? supportedPlatforms,
  }) {
    _instance = Platform._(
      desktopBreakpoint: desktopBreakpoint,
      navigatorKey: navigatorKey,
      supportedPlatforms: supportedPlatforms ?? Platforms.values,
    );
  }

  double get _screenWidth {
    final _navigatorKey = navigatorKey;

    if (_navigatorKey == null) {
      throw 'uninitialized navigatorKey.';
    }

    final context = _navigatorKey.currentContext;

    if (context == null) {
      throw 'no BuildContext for navigatorKey';
    }

    return MediaQuery.of(context).size.width;
  }

  bool get isFormFactorEnabled {
    if (_isTest) {
      return true;
    }

    return navigatorKey != null;
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

  // Form factor checks

  bool get isDesktop {
    if (_isTest) {
      return true;
    }

    return _screenWidth >= defaultDesktopFormFactorBreakpoint;
  }

  bool get isMobile {
    if (_isTest) {
      return false;
    }

    return _screenWidth < defaultDesktopFormFactorBreakpoint;
  }

  // Current platform checks

  Platforms get current {
    if (_isTest) {
      return Platforms.android;
    }

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

  /// The host platform that the application is running on. For example if running
  /// the web framework an iPhone, the host would be iOS. If running the Android
  /// framework, the host would be Android.
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

  // Test environment check

  bool get _isTest {
    return io.Platform.environment.containsKey('FLUTTER_TEST');
  }
}
