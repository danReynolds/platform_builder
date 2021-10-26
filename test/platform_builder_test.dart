import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:platform_builder/platform.dart';
import 'package:platform_builder/platform_builder.dart';

final greenTestWidget = Container(
  height: 50,
  width: 50,
  color: Colors.green,
);

final redTestWidget = Container(
  height: 50,
  width: 50,
  color: Colors.red,
);

void main() {
  /// Disable the ErrorWidget red box so that assertion errors being tested are the only errors generated during testing.
  /// Without this, the red error box can cause overflow errors that supercede the assertion failure.
  ErrorWidget.builder = (FlutterErrorDetails details) => Container();

  Platform.init(
    supportedPlatforms: [Platforms.android],
  );
  Platform.instance.isTestOverride = true;

  testGoldens(
    'Basic builder',
    (WidgetTester tester) async {
      await tester.pumpWidget(PlatformBuilder(
        builder: (context) => greenTestWidget,
      ));
      await screenMatchesGolden(tester, 'basic_builder', customPump: (widget) {
        return widget.pump(Duration.zero);
      });
    },
  );

  testGoldens(
    'Basic platform specific builder',
    (WidgetTester tester) async {
      await tester.pumpWidget(PlatformBuilder(
        androidBuilder: (context) => greenTestWidget,
      ));
      await screenMatchesGolden(tester, 'basic_platform_specific_test',
          customPump: (widget) {
        return widget.pump(Duration.zero);
      });
    },
  );

  testGoldens(
    'Basic form factor specific builder',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        PlatformBuilder(
          desktop: FormFactorDelegate(
            androidBuilder: (context) => greenTestWidget,
          ),
        ),
      );
      await screenMatchesGolden(tester, 'basic_form_factor_specific_test',
          customPump: (widget) {
        return widget.pump(Duration.zero);
      });
    },
  );

  testGoldens(
    'Chooses the most specific builder',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        PlatformBuilder(
          androidBuilder: (context) => redTestWidget,
          desktop: FormFactorDelegate(
            builder: (context) => redTestWidget,
            nativeBuilder: (context) => redTestWidget,
            androidBuilder: (context) => greenTestWidget,
          ),
          mobile: FormFactorDelegate(
            androidBuilder: (context) => redTestWidget,
          ),
        ),
      );
      await screenMatchesGolden(tester, 'builder_specificity_test',
          customPump: (widget) {
        return widget.pump(Duration.zero);
      });
    },
  );

  testWidgets(
    'Assertion thrown with missing builders',
    (WidgetTester tester) async {
      Platform.init(
        supportedPlatforms: [Platforms.android, Platforms.iOS],
      );

      await tester.pumpWidget(PlatformBuilder(
        androidBuilder: (context) => redTestWidget,
      ));

      expect(
        tester.takeException(),
        isInstanceOf<AssertionError>(),
      );
    },
  );

  testGoldens('desktop builder', (WidgetTester tester) async {
    final key = GlobalKey<NavigatorState>();

    Platform.init(
      supportedPlatforms: [Platforms.android],
      // The default test environment size is 800x600
      desktopBreakpoint: 400,
      navigatorKey: key,
    );

    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: key,
        home: PlatformBuilder(
          desktop: FormFactorDelegate(
            builder: (context) => greenTestWidget,
          ),
        ),
      ),
    );

    await screenMatchesGolden(tester, 'desktop_builder_test',
        customPump: (widget) {
      return widget.pump(Duration.zero);
    });
  });

  testGoldens('mobile builder', (WidgetTester tester) async {
    final key = GlobalKey<NavigatorState>();

    Platform.init(
      supportedPlatforms: [Platforms.android],
      // The default test environment size is 800x600
      desktopBreakpoint: 1000,
      navigatorKey: key,
    );

    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: key,
        home: PlatformBuilder(
          mobile: FormFactorDelegate(
            builder: (context) => greenTestWidget,
          ),
        ),
      ),
    );

    await screenMatchesGolden(tester, 'mobile_builder_test',
        customPump: (widget) {
      return widget.pump(Duration.zero);
    });
  });

  // Add tests for making sure that it throws errors if supported platforms are left unspecified
}
