# Platform Builder

A Flutter library for performing platform checks and building widgets based on platform and form factor.

## Platform checks

```dart
import 'package:platform_builder/platform_builder.dart';

if (Platform.instance.isAndroid) {
  print('android');
} else if (Platform.instance.isWeb) {
  print('web');
}
```

## Platform builders

```dart
import 'package:platform_builder/platform_builder.dart';

class MyWidget extends StatelessWidget {
  @override
  build(context) {
    return PlatformBuilder(
      androidBuilder: (context) => Icon(Icons.android),
      iOSBuilder: (context) => Icon(Icons.apple),
    ),
  }
}
```

## Platforms

The libray provides builders for the following platforms:

* android
* iOS
* macOS
* linux
* fuschia
* windows
* web
* chrome extension

By default all platforms are enabled and the `PlatformBuilder` will throw an error if you forget to include an implementation for one of the supported platforms. To specify
your preferred platforms, call the [Platform.init](https://pub.dev/documentation/platform_builder/latest/platform/Platform/init.html) to initialize the `Platform` singleton
with the list of your application's supported platforms:

```dart
import 'package:platform_builder/platform_builder.dart';

Platform.init(
  supportedPlatforms: [
    Platforms.iOS,
    Platforms.android,
    Platforms.web,
  ]
);
```

If a particular `PlatformBuilder` needs to override the global supported platforms, such as during active development, you can pass an override to the widget:

```dart
import 'package:platform_builder/platform_builder.dart';

class MyWidget extends StatelessWidget {
  @override
  build(context) {
    return PlatformBuilder(
      supportedPlatforms: [Platforms.iOS, Platforms.android],
      androidBuilder: (context) => Icon(Icons.android),
      iOSBuilder: (context) => Icon(Icons.apple),
    ),
  }
}
```

## Form Factors

There are additional helpers for the following form factors:

* desktop
* mobile

To enable the form factors, call [Platform.init](https://pub.dev/documentation/platform_builder/latest/platform/Platform/init.html) with the following options:

```dart
import 'package:platform_builder/platform_builder.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Platform.init(
  /// The breakpoint at which the width of the application should be considered
  /// the desktop form factor.
  desktopBreakpoint: 760,
  /// A global navigator key used to access the current screen size.
  navigatorKey: navigatorKey,
);

class MyApp extends StatelessWidget {
  @override
  build(context) {
    return MaterialApp(
      home: Home(),
      /// Pass the same `navigatorKey` to the root of your app.
      navigatorKey: navigatorKey,
    );
  }
}
```

You can then make form factor checks throughout your application:

```dart
import 'package:platform_builder/platform_builder.dart';

if (Platform.instance.isDesktop) {
  print('desktop');
} else if (Platform.instance.isMobile) {
  print('mobile');
}
```

The `PlatformBuilder` supports specifying separate platform implementations by form factor:

```dart
import 'package:platform_builder/platform_builder.dart';

class MyWidget extends StatelessWidget {
  @override
  build(context) {
    return PlatformBuilder(
      mobile: FormFactorDelegate(
        androidBuilder: (context) {...},
        iOSBuilder: (context) {...},
      ),
      desktop: FormFactorDelegate(
        builder: (context) {...},
      ),
    ),
  }
}
```

If all you need is a different builder for each form factor, there is a [FormFactorBuilder]() widget for building a separate mobile vs desktop implementation:

```dart
import 'package:platform_builder/platform_builder.dart';

class MyWidget extends StatelessWidget {
  @override
  build(context) {
    return FormFactorBuilder(
      mobile: (context) {...},
      desktop: (context) {...}
    ),
  }
}
```

## Builder precedence

The precedence of builders is based on specificity. More specific builders take precedence over broader ones as shown below:

```dart
import 'package:platform_builder/platform_builder.dart';

class MyWidget extends StatelessWidget {
  @override
  build(context) {
    return PlatformBuilder(
      builder: (context) {...},
      webBuilder: (context) {...},
      mobile: FormFactorDelegate(
        webBuilder: (context) {...},
      ),
    ),
  }
}
```

In this example on a web platform, all three builders are applicable, but the precedence would be:

* mobile->webBuilder
* webBuilder
* builder

## FAQs

* **Q**: Don't we already have a way to check the current Platform?
* **A** Yes! But the [Platform](https://api.flutter.dev/flutter/dart-io/Platform-class.html) library from `dart:io` has some quirks like the fact that calling native platforms like `Platform.instance.isIOS` on web throws an exception. In this lib we add guards for that as well expanding the platform helpers to include other helpful platform utilities like the following:

  - [Platform.instance.current](https://pub.dev/documentation/platform_builder/latest/platform/Platform/current.html): The current Flutter application platform.
  - [Platform.instance.currentHost](https://pub.dev/documentation/platform_builder/latest/platform/Platform/currentHost.html): The application's host operating system.
  - [Platform.instance.isCanvasKit](https://pub.dev/documentation/platform_builder/latest/platform/Platform/isCanvasKit.html): Whether the application is using the `CanvasKit` renderer.
  - [Platform.instance.isHtml](https://pub.dev/documentation/platform_builder/latest/platform/Platform/isHtml.html): Whether the application is using the `HTML` renderer.

* **Q**: Why a `PlatformBuilder`? Can't we just use if/else clauses in our build functions?
* **A**: You definitely can! Here are some things we think a builder widget can help with:
  - It organizes branching your build functions by platform in a consistent way
  - It throws a runtime error if you forget to add a builder for one of your specified supported platforms so that you can catch that mistake in development
  - It abstracts having to repeat yourself with frequent platform checks throughout your application.

## Tell us what you need

Something missing? Let us know what additional platform utilities would be helpful for your workflow.