import 'package:flutter/material.dart';
import 'package:platform_builder/form_factor.dart';

class FormFactorProvider extends StatefulWidget {
  final Widget child;

  const FormFactorProvider({
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  _FormFactorProviderState createState() => _FormFactorProviderState();
}

class _FormFactorProviderState extends State<FormFactorProvider> {
  @override
  build(context) {
    return StreamBuilder<FormFactors?>(
      stream: FormFactor.instance.stream,
      builder: (context, formFactorSnap) {
        WidgetsBinding.instance!.addPostFrameCallback((_) {
          // The MediaQuery InheritedWidget `of` API must be read in this widget
          // so that it knows to rebuild this widget whenever the MediaQuery value
          // (such as the dimensions of the screen) change.
          MediaQuery.of(context);
          FormFactor.instance.update();
        });

        // Delay building the subtree until a form factor has been determined since
        // any descendant widgets dependent on the form factor cannot be built yet.
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
