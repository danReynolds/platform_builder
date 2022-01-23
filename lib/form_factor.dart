import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

enum FormFactors { mobile, tablet, desktop }

class FormFactorBreakpoints {
  final int? tablet;
  final int? desktop;

  FormFactorBreakpoints({
    this.tablet,
    this.desktop,
  });
}

class FormFactor {
  FormFactor._();

  final _subject = BehaviorSubject<FormFactors?>();
  late FormFactorBreakpoints breakpoints;

  static final instance = FormFactor._();

  static void init({
    required FormFactorBreakpoints breakpoints,
  }) {
    instance.breakpoints = breakpoints;
  }

  FormFactors? _formFactor(Size size) {
    final width = size.width;

    if (breakpoints.desktop != null && width >= breakpoints.desktop!) {
      return FormFactors.desktop;
    } else if (breakpoints.tablet != null && width >= breakpoints.tablet!) {
      return FormFactors.tablet;
    }
    return FormFactors.mobile;
  }

  void update(Size size) {
    final updatedFormFactor = instance._formFactor(size);

    if (updatedFormFactor != instance._subject.valueOrNull) {
      _subject.add(updatedFormFactor);
    }
  }

  Stream<FormFactors?> get stream {
    return _subject.stream;
  }

  bool get isMobile {
    return _subject.value == FormFactors.mobile;
  }

  bool get isTablet {
    return _subject.value == FormFactors.tablet;
  }

  bool get isDesktop {
    return _subject.value == FormFactors.desktop;
  }
}
