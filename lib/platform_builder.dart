library platform_builder;

import 'package:flutter/material.dart';
import 'package:platform_builder/platform.dart';
import 'package:platform_builder/platform_resolver.dart';

export 'package:platform_builder/platform.dart';
export 'package:platform_builder/platform_resolver.dart';

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

  /// A list of supported platforms this widget should check are covered by the provided builders.
  /// Defaults to the supported platform list specified to [Platform].
  final List<Platforms>? supportedPlatforms;

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
    key,
  }) : super(key: key);

  @override
  build(context) {
    final _supportedPlatforms =
        supportedPlatforms ?? Platform.instance.supportedPlatforms;

    final resolver = PlatformResolver<Widget Function(BuildContext context)?>(
      androidResolver: () => androidBuilder,
      iOSResolver: () => iOSBuilder,
      fuschiaResolver: () => fuschiaBuilder,
      windowsResolver: () => windowsBuilder,
      chromeExtensionResolver: () => chromeExtensionBuilder,
      linuxResolver: () => linuxBuilder,
      macOSResolver: () => macOSBuilder,
      webResolver: () => webBuilder,
      nativeResolver: () => nativeBuilder,
      defaultResolver: () => builder,
    );

    // Check that the implementation does not omit any supported platforms
    assert(
      !_supportedPlatforms.contains(Platforms.android) ||
          resolver.android != null,
      'Missing android platform builder',
    );
    assert(
      !_supportedPlatforms.contains(Platforms.iOS) || resolver.iOS != null,
      'Missing iOS platform builder',
    );
    assert(
      !_supportedPlatforms.contains(Platforms.linux) || resolver.linux != null,
      'Missing linux platform builder',
    );
    assert(
      !_supportedPlatforms.contains(Platforms.fuschia) ||
          resolver.fuschia != null,
      'Missing fuschia platform builder',
    );
    assert(
      !_supportedPlatforms.contains(Platforms.macOS) || resolver.macOS != null,
      'Missing macOS platform builder',
    );
    assert(
      !_supportedPlatforms.contains(Platforms.windows) ||
          resolver.windows != null,
      'Missing windows platform builder',
    );
    assert(
      !_supportedPlatforms.contains(Platforms.chromeExtension) ||
          resolver.chromeExtension != null,
      'Missing chrome extension platform builder',
    );

    return resolver.current!(context);
  }
}
