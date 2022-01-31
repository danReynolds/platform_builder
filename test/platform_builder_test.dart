import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
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
    supportedPlatforms: [Platforms.macOS],
    override: null,
  );

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
        macOSBuilder: (context) => greenTestWidget,
      ));
      await screenMatchesGolden(tester, 'basic_platform_specific_test',
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
          macOSBuilder: (context) => greenTestWidget,
          nativeBuilder: (context) => redTestWidget,
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
        supportedPlatforms: [Platforms.macOS, Platforms.iOS],
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
}
