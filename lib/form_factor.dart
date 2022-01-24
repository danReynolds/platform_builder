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

  FormFactors? _prevFormFactor;

  final _subject = BehaviorSubject<FormFactors?>.seeded(FormFactors.desktop);
  late FormFactorBreakpoints breakpoints;
  late GlobalKey<NavigatorState> navigatorKey;

  static final instance = FormFactor._();

  static void init({
    required FormFactorBreakpoints breakpoints,
    required GlobalKey<NavigatorState> navigatorKey,
  }) {
    instance.breakpoints = breakpoints;
    instance.navigatorKey = navigatorKey;
  }

  FormFactors get _formFactor {
    final width = MediaQuery.of(navigatorKey.currentContext!).size.width;

    if (breakpoints.desktop != null && width >= breakpoints.desktop!) {
      return FormFactors.desktop;
    } else if (breakpoints.tablet != null && width >= breakpoints.tablet!) {
      return FormFactors.tablet;
    }
    return FormFactors.mobile;
  }

  void update() {
    final updatedFormFactor = _formFactor;
    if (updatedFormFactor != instance._subject.valueOrNull) {
      _subject.add(updatedFormFactor);
    }
  }

  FormFactors? get value {
    return _subject.valueOrNull;
  }

  Stream<FormFactors?> get stream {
    return _subject.stream;
  }

  Stream<List<FormFactors?>> get changes {
    return _subject.stream
        .map((formFactor) => [formFactor, _prevFormFactor])
        .doOnData((formFactor) {
      _prevFormFactor = formFactor.first;
    });
  }

  bool get isMobile {
    return _formFactor == FormFactors.mobile;
  }

  bool get isTablet {
    return _formFactor == FormFactors.tablet;
  }

  bool get isDesktop {
    return _formFactor == FormFactors.desktop;
  }
}
