import 'package:flutter/material.dart';
import 'package:platform_builder/form_factor.dart';

class FormFactorChangeListener extends StatefulWidget {
  final Widget child;

  const FormFactorChangeListener({
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  _FormFactorChangeListenerState createState() =>
      _FormFactorChangeListenerState();
}

class _FormFactorChangeListenerState extends State<FormFactorChangeListener> {
  @override
  build(context) {
    return StreamBuilder<FormFactors?>(
      stream: FormFactor.instance.stream,
      builder: (context, formFactorSnap) {
        WidgetsBinding.instance!.addPostFrameCallback((_) {
          // The MediaQuery must be read after building or it doesn't trigger rebuilds
          // when the size changes
          FormFactor.instance.update(MediaQuery.of(context).size);
        });

        if (!formFactorSnap.hasData) {
          return Scaffold(
            body: Container(),
          );
        }

        return widget.child;
      },
    );
  }
}
