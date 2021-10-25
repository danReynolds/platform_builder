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
  Platform.init(
    supportedPlatforms: [Platforms.android],
  );

  testGoldens(
    'Basic builder',
    (WidgetTester tester) async {
      final builder = GoldenBuilder.column()
        ..addScenario(
          'Basic builder',
          PlatformBuilder(
            builder: (context) => greenTestWidget,
          ),
        );

      await tester.pumpWidgetBuilder(builder.build());
      await screenMatchesGolden(tester, 'basic_builder', customPump: (widget) {
        return widget.pump(Duration.zero);
      });
    },
  );

  testGoldens(
    'Basic platform specific builder',
    (WidgetTester tester) async {
      final builder = GoldenBuilder.column()
        ..addScenario(
          'Basic platform specific builder',
          PlatformBuilder(
            androidBuilder: (context) => greenTestWidget,
          ),
        );

      await tester.pumpWidgetBuilder(builder.build());
      await screenMatchesGolden(tester, 'basic_platform_specific_test',
          customPump: (widget) {
        return widget.pump(Duration.zero);
      });
    },
  );

  testGoldens(
    'Basic form factor specific builder',
    (WidgetTester tester) async {
      final builder = GoldenBuilder.column()
        ..addScenario(
          'Basic form factor specific builder',
          PlatformBuilder(
            desktop: FormFactorDelegate(
              androidBuilder: (context) => greenTestWidget,
            ),
          ),
        );

      await tester.pumpWidgetBuilder(builder.build());
      await screenMatchesGolden(tester, 'basic_form_factor_specific_test',
          customPump: (widget) {
        return widget.pump(Duration.zero);
      });
    },
  );

  testGoldens(
    'Builder specificity test',
    (WidgetTester tester) async {
      final builder = GoldenBuilder.column()
        ..addScenario(
          'Builder specificity test',
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

      await tester.pumpWidgetBuilder(builder.build());
      await screenMatchesGolden(tester, 'builder_specificity_test',
          customPump: (widget) {
        return widget.pump(Duration.zero);
      });
    },
  );
}
