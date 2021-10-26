library platform_builder;

import 'package:flutter/material.dart';
import 'package:platform_builder/platform.dart';

export 'package:platform_builder/platform.dart';
export 'package:platform_builder/form_factor_builder.dart';

/// Contains all platform builder functions that are available to a given
/// form factor.
class FormFactorDelegate {
  final Widget Function(BuildContext context)? builder;
  final Widget Function(BuildContext context)? nativeBuilder;
  final Widget Function(BuildContext context)? webBuilder;
  final Widget Function(BuildContext context)? androidBuilder;
  final Widget Function(BuildContext context)? iOSBuilder;
  final Widget Function(BuildContext context)? chromeExtensionBuilder;
  final Widget Function(BuildContext context)? linuxBuilder;
  final Widget Function(BuildContext context)? windowsBuilder;
  final Widget Function(BuildContext context)? macOSBuilder;
  final Widget Function(BuildContext context)? fuschiaBuilder;

  FormFactorDelegate({
    this.builder,
    this.nativeBuilder,
    this.webBuilder,
    this.androidBuilder,
    this.iOSBuilder,
    this.chromeExtensionBuilder,
    this.linuxBuilder,
    this.macOSBuilder,
    this.windowsBuilder,
    this.fuschiaBuilder,
  });
}

/// Builds a widget based on the most specific platform builder provided.
/// Ex.
/// If running on Android with [PlatformBuilder.androidBuilder], [PlatformBuilder.builder],
/// and [PlatformBuilder.nativeBuilder] builders provided, the builder precedence order is as follows:
/// - [PlatformBuilder.androidBuilder],
/// - [PlatformBuilder.nativeBuilder]
/// - [PlatformBuilder.builder]
class PlatformBuilder extends StatelessWidget {
  /// Builder for all platforms.
  final Widget Function(BuildContext context)? builder;

  /// Builder for all native platforms defined as platforms where the current platform
  /// is equal to the host platform.
  /// [PlatformService.current] == [PlatformService.currentHost]
  final Widget Function(BuildContext context)? nativeBuilder;

  /// Builder for all web platforms.
  final Widget Function(BuildContext context)? webBuilder;

  /// Builder for the android platform.
  final Widget Function(BuildContext context)? androidBuilder;

  /// Builder for the iOS platform.
  final Widget Function(BuildContext context)? iOSBuilder;

  /// Builder for the chrome extension platform.
  final Widget Function(BuildContext context)? chromeExtensionBuilder;

  /// Builder for the linux platform.
  final Widget Function(BuildContext context)? linuxBuilder;

  /// Builder for the windows platform.
  final Widget Function(BuildContext context)? windowsBuilder;

  /// Builder for the macOS platform.
  final Widget Function(BuildContext context)? macOSBuilder;

  /// Builder for the fuschia platform.
  final Widget Function(BuildContext context)? fuschiaBuilder;

  /// Delegate for declaring platform builders for the mobile form factor.
  final FormFactorDelegate? mobile;

  /// Delegate for declaring platform builders for the desktop form factor.
  final FormFactorDelegate? desktop;

  /// A list of supported platforms this widget should check are covered by the provided builders.
  /// Defaults to the supported platform list specified to [Platform].
  final List<Platforms>? supportedPlatforms;

  FormFactorDelegate? get _formFactorDelegate {
    if (!Platform.instance.isFormFactorEnabled) {
      return null;
    }

    return Platform.instance.isDesktop ? desktop : mobile;
  }

  Widget Function(BuildContext context)? get _androidBuilder {
    return _formFactorDelegate?.androidBuilder ??
        androidBuilder ??
        _nativeBuilder;
  }

  Widget Function(BuildContext context)? get _iOSBuilder {
    return _formFactorDelegate?.iOSBuilder ?? iOSBuilder ?? _nativeBuilder;
  }

  Widget Function(BuildContext context)? get _chromeExtensionBuilder {
    return _formFactorDelegate?.chromeExtensionBuilder ??
        chromeExtensionBuilder ??
        _webBuilder;
  }

  Widget Function(BuildContext context)? get _macOSBuilder {
    return _formFactorDelegate?.macOSBuilder ?? macOSBuilder ?? _nativeBuilder;
  }

  Widget Function(BuildContext context)? get _linuxBuilder {
    return _formFactorDelegate?.linuxBuilder ?? linuxBuilder ?? _nativeBuilder;
  }

  Widget Function(BuildContext context)? get _fuschiaBuilder {
    return _formFactorDelegate?.fuschiaBuilder ??
        fuschiaBuilder ??
        _nativeBuilder;
  }

  Widget Function(BuildContext context)? get _windowsBuilder {
    return _formFactorDelegate?.windowsBuilder ??
        windowsBuilder ??
        _nativeBuilder;
  }

  Widget Function(BuildContext context)? get _nativeBuilder {
    return _formFactorDelegate?.nativeBuilder ?? nativeBuilder ?? _builder;
  }

  Widget Function(BuildContext context)? get _webBuilder {
    return _formFactorDelegate?.webBuilder ?? webBuilder ?? _builder;
  }

  Widget Function(BuildContext context)? get _builder {
    return _formFactorDelegate?.builder ?? builder;
  }

  const PlatformBuilder({
    this.supportedPlatforms,
    this.builder,
    this.webBuilder,
    this.nativeBuilder,
    this.androidBuilder,
    this.windowsBuilder,
    this.iOSBuilder,
    this.chromeExtensionBuilder,
    this.linuxBuilder,
    this.macOSBuilder,
    this.fuschiaBuilder,
    this.mobile,
    this.desktop,
    key,
  }) : super(key: key);

  @override
  build(context) {
    final platform = Platform.instance.current;
    final _supportedPlatforms =
        supportedPlatforms ?? Platform.instance.supportedPlatforms;

    // Check that the implementation does not omit any supported platforms
    assert(
      !_supportedPlatforms.contains(Platforms.android) ||
          _androidBuilder != null,
      'Missing android platform builder',
    );
    assert(
      !_supportedPlatforms.contains(Platforms.iOS) || _iOSBuilder != null,
      'Missing iOS platform builder',
    );
    assert(
      !_supportedPlatforms.contains(Platforms.linux) || _linuxBuilder != null,
      'Missing linux platform builder',
    );
    assert(
      !_supportedPlatforms.contains(Platforms.fuschia) ||
          _fuschiaBuilder != null,
      'Missing fuschia platform builder',
    );
    assert(
      !_supportedPlatforms.contains(Platforms.macOS) || _macOSBuilder != null,
      'Missing macOS platform builder',
    );
    assert(
      !_supportedPlatforms.contains(Platforms.windows) ||
          _windowsBuilder != null,
      'Missing windows platform builder',
    );
    assert(
      !_supportedPlatforms.contains(Platforms.chromeExtension) ||
          _chromeExtensionBuilder != null,
      'Missing chrome extension platform builder',
    );

    switch (platform) {
      case Platforms.android:
        return _androidBuilder!(context);
      case Platforms.iOS:
        return _iOSBuilder!(context);
      case Platforms.windows:
        return _windowsBuilder!(context);
      case Platforms.fuschia:
        return _fuschiaBuilder!(context);
      case Platforms.macOS:
        return _macOSBuilder!(context);
      case Platforms.chromeExtension:
        return _chromeExtensionBuilder!(context);
      case Platforms.linux:
        return _linuxBuilder!(context);
      case Platforms.web:
        return _webBuilder!(context);
    }
  }
}
