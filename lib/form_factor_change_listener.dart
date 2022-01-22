import 'package:flutter/material.dart';
import 'package:platform_builder/form_factor_bloc.dart';

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
    return Builder(
      builder: (context) {
        WidgetsBinding.instance!.addPostFrameCallback((_) {
          FormFactorBloc.instance.update(context);
        });

        return widget.child;
      },
    );
  }
}
