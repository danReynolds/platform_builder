import 'package:flutter/material.dart';
import 'package:platform_builder/platform_builder.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  initState() {
    super.initState();

    Platform.init(supportedPlatforms: {
      Platforms.web,
      Platforms.android,
      Platforms.iOS,
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: PlatformBuilder(
            webBuilder: (_context) => const Text('You are on web!'),
            iOSBuilder: (_context) => const Text('You are on iOS!'),
            androidBuilder: (_context) => const Text('You are on Android!'),
          ),
        ),
      ),
    );
  }
}
