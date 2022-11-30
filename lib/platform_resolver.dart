import 'package:platform_builder/platform_builder.dart';

// A class that determines the value to resolve given the provided resolvers
// and platform precedence.
class PlatformResolver<T> {
  final T Function()? nativeResolver;
  final T Function()? androidResolver;
  final T Function()? iOSResolver;
  final T Function()? chromeExtensionResolver;
  final T Function()? fuschiaResolver;
  final T Function()? linuxResolver;
  final T Function()? macOSResolver;
  final T Function()? webResolver;
  final T Function()? windowsResolver;
  final T Function()? defaultResolver;

  PlatformResolver({
    this.nativeResolver,
    this.androidResolver,
    this.iOSResolver,
    this.chromeExtensionResolver,
    this.fuschiaResolver,
    this.linuxResolver,
    this.macOSResolver,
    this.webResolver,
    this.windowsResolver,
    this.defaultResolver,
    Set<Platforms>? supportedPlatforms,
  }) {
    supportedPlatforms ??= Platform.instance.supportedPlatforms;

    if (supportedPlatforms.contains(Platforms.android)) {
      assert(_android != null, 'Missing android resolver');
    }
    if (supportedPlatforms.contains(Platforms.chromeExtension)) {
      assert(_chromeExtension != null, 'Missing chrome extension resolver');
    }
    if (supportedPlatforms.contains(Platforms.fuschia)) {
      assert(_fuschia != null, 'Missing fuschia resolver');
    }
    if (supportedPlatforms.contains(Platforms.iOS)) {
      assert(_iOS != null, 'Missing iOS resolver');
    }
    if (supportedPlatforms.contains(Platforms.linux)) {
      assert(_linux != null, 'Missing linux resolver');
    }
    if (supportedPlatforms.contains(Platforms.macOS)) {
      assert(_macOS != null, 'Missing macOS resolver');
    }
    if (supportedPlatforms.contains(Platforms.web)) {
      assert(_web != null, 'Missing web resolver');
    }
    if (supportedPlatforms.contains(Platforms.windows)) {
      assert(_windows != null, 'Missing windows resolver');
    }
  }

  static T current<T>({
    T Function()? nativeResolver,
    T Function()? androidResolver,
    T Function()? iOSResolver,
    T Function()? chromeExtensionResolver,
    T Function()? fuschiaResolver,
    T Function()? linuxResolver,
    T Function()? macOSResolver,
    T Function()? webResolver,
    T Function()? windowsResolver,
    T Function()? defaultResolver,
  }) {
    return PlatformResolver(
      nativeResolver: nativeResolver,
      androidResolver: androidResolver,
      iOSResolver: iOSResolver,
      chromeExtensionResolver: chromeExtensionResolver,
      fuschiaResolver: fuschiaResolver,
      linuxResolver: linuxResolver,
      macOSResolver: macOSResolver,
      webResolver: webResolver,
      windowsResolver: windowsResolver,
      defaultResolver: defaultResolver,
    ).resolve();
  }

  /// Resolves the value for the given platform by precedence, defaulting to the current platform.
  T resolve([Platforms? platform]) {
    switch (platform ?? Platform.instance.current) {
      case Platforms.android:
        return android;
      case Platforms.iOS:
        return iOS;
      case Platforms.windows:
        return windows;
      case Platforms.fuschia:
        return fuschia;
      case Platforms.macOS:
        return macOS;
      case Platforms.chromeExtension:
        return chromeExtension;
      case Platforms.linux:
        return linux;
      case Platforms.web:
        return web;
    }
  }

  T Function()? get _android {
    return androidResolver ?? _native;
  }

  T get android {
    return _android!();
  }

  T Function()? get _iOS {
    return iOSResolver ?? _native;
  }

  T get iOS {
    return _iOS!();
  }

  T Function()? get _windows {
    return windowsResolver ?? _native;
  }

  T get windows {
    return _windows!();
  }

  T Function()? get _fuschia {
    return fuschiaResolver ?? _native;
  }

  T get fuschia {
    return _fuschia!();
  }

  T Function()? get _macOS {
    return macOSResolver ?? _native;
  }

  T get macOS {
    return _macOS!();
  }

  T Function()? get _chromeExtension {
    return chromeExtensionResolver ?? _web;
  }

  T get chromeExtension {
    return _chromeExtension!();
  }

  T Function()? get _linux {
    return linuxResolver ?? _native;
  }

  T get linux {
    return _linux!();
  }

  T get web {
    return _web!();
  }

  T Function()? get _web {
    return webResolver ?? defaultResolver;
  }

  T Function()? get _native {
    return nativeResolver ?? defaultResolver;
  }

  T get native {
    return _native!();
  }
}
