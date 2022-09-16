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
  });

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

  T get android {
    return androidResolver?.call() ?? native;
  }

  T get iOS {
    return iOSResolver?.call() ?? native;
  }

  T get windows {
    return windowsResolver?.call() ?? native;
  }

  T get fuschia {
    return fuschiaResolver?.call() ?? native;
  }

  T get macOS {
    return macOSResolver?.call() ?? native;
  }

  T get chromeExtension {
    return chromeExtensionResolver?.call() ?? web;
  }

  T get linux {
    return linuxResolver?.call() ?? native;
  }

  T get web {
    final resolver = webResolver?.call() ?? defaultResolver?.call();
    assert(resolver != null, 'Missing web resolver');
    return resolver!;
  }

  T get native {
    final resolver = nativeResolver?.call() ?? defaultResolver?.call();
    assert(resolver != null, 'Missing native resolver');
    return resolver!;
  }
}
