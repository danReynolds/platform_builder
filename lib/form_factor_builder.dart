import 'package:flutter/material.dart';
import 'package:platform_builder/platform_builder.dart';

class FormFactorBuilder extends StatelessWidget {
  final Widget Function(BuildContext context) mobileBuilder;
  final Widget Function(BuildContext context) desktopBuilder;

  const FormFactorBuilder({
    required this.mobileBuilder,
    required this.desktopBuilder,
    key,
  }) : super(key: key);

  @override
  build(context) {
    return PlatformBuilder(
      mobile: FormFactorDelegate(
        builder: mobileBuilder,
      ),
      desktop: FormFactorDelegate(
        builder: desktopBuilder,
      ),
    );
  }
}
