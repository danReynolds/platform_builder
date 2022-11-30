library platform_builder;

import 'package:flutter/material.dart';
import 'package:platform_builder/platform.dart';
import 'package:platform_builder/platform_resolver.dart';

export 'package:platform_builder/platform.dart';
export 'package:platform_builder/platform_resolver.dart';

typedef _Builder = Widget Function(BuildContext context);

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

  _Builder Function()? _builderToResolver(_Builder? builder) {
    if (builder != null) {
      return () => builder;
    }
    return null;
  }

  @override
  build(context) {
    final resolver = PlatformResolver<_Builder>(
      androidResolver: _builderToResolver(androidBuilder),
      iOSResolver: _builderToResolver(iOSBuilder),
      fuschiaResolver: _builderToResolver(fuschiaBuilder),
      windowsResolver: _builderToResolver(windowsBuilder),
      chromeExtensionResolver: _builderToResolver(chromeExtensionBuilder),
      linuxResolver: _builderToResolver(linuxBuilder),
      macOSResolver: _builderToResolver(macOSBuilder),
      webResolver: _builderToResolver(webBuilder),
      nativeResolver: _builderToResolver(nativeBuilder),
      defaultResolver: _builderToResolver(builder),
    );

    return resolver.resolve()(context);
  }
}
