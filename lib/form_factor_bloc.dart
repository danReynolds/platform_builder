import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

enum FormFactors { mobile, tablet, desktop }

class FormFactorBreakpoints {
  final int? mobile;
  final int? tablet;

  FormFactorBreakpoints({
    this.mobile,
    this.tablet,
  });
}

class FormFactorBloc {
  FormFactorBloc._();

  static final instance = FormFactorBloc._();

  final _subject = BehaviorSubject<FormFactors?>();

  FormFactorBreakpoints? breakpoints;
  bool isInitialized = false;

  void init(FormFactorBreakpoints? breakpoints) {
    isInitialized = true;
    this.breakpoints = breakpoints;
  }

  FormFactors? get value {
    return _subject.valueOrNull;
  }

  Stream<FormFactors?> get stream {
    return _subject.stream;
  }

  FormFactors? _getFormFactor(BuildContext? context) {
    if (context == null || breakpoints == null) {
      return null;
    }

    final width = MediaQuery.of(context).size.width;

    if (breakpoints!.mobile != null && width < breakpoints!.mobile!) {
      return FormFactors.mobile;
    } else if (breakpoints!.tablet != null && width < breakpoints!.tablet!) {
      return FormFactors.tablet;
    } else {
      return FormFactors.desktop;
    }
  }

  void update(BuildContext context) {
    final updatedFormFactor = _getFormFactor(context);

    if (updatedFormFactor != value) {
      _subject.add(value);
    }
  }
}
