import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/instance_manager.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get_state_manager/src/simple/list_notifier.dart';

// import 'package:get../../../instance_manager.dart';
// import '../../get_state_manager.dart';
// import '../simple/list_notifier.dart';

mixin PruebaMixin<T> on ListNotifierMixin {
  T? _value;
  RxPruebaStatus? _status;

  bool _isNullOrEmpty(dynamic val) {
    if (val == null) return true;
    var result = false;
    if (val is Iterable) {
      result = val.isEmpty;
    } else if (val is String) {
      result = val.isEmpty;
    } else if (val is Map) {
      result = val.isEmpty;
    }
    return result;
  }

  void _fillEmptyStatus() {
    _status = _isNullOrEmpty(_value)
        ? RxPruebaStatus.loading()
        : RxPruebaStatus.success();
  }

  RxPruebaStatus get status {
    notifyChildrens();
    return _status ??= _status = RxPruebaStatus.loading();
  }

  T? get state => value;

  @protected
  T? get value {
    notifyChildrens();
    return _value;
  }

  @protected
  set value(T? newValue) {
    if (_value == newValue) return;
    _value = newValue;
    refresh();
  }

  void change(T? newState, {RxPruebaStatus? status}) {
    var _canUpdate = false;
    if (status != null) {
      _status = status;
      _canUpdate = true;
    }
    if (newState != _value) {
      _value = newState;
      _canUpdate = true;
    }
    if (_canUpdate) {
      refresh();
    }
  }

  void append(Future<T> Function() body(), {String? errorMessage}) {
    final compute = body();
    compute().then((newValue) {
      change(newValue, status: RxPruebaStatus.success());
    }, onError: (err) {
      change(state,
          status: RxPruebaStatus.error(errorMessage ?? err.toString()));
    });
  }
}

class ValuePrueba<T> extends ListNotifier
    with PruebaMixin<T>
    implements ValueListenable<T?> {
  ValuePrueba(T val) {
    _value = val;
    _fillEmptyStatus();
  }

  @override
  T? get value {
    notifyChildrens();
    return _value;
  }

  @override
  set value(T? newValue) {
    if (_value == newValue) return;
    _value = newValue;
    refresh();
  }

  T? call([T? v]) {
    if (v != null) {
      value = v;
    }
    return value;
  }

  void update(void fn(T? value)) {
    fn(value);
    refresh();
  }

  @override
  String toString() => value.toString();

  dynamic toJson() => (value as dynamic)?.toJson();
}

extension ReactiveT<T> on T {
  ValuePrueba<T> get reactive => ValuePrueba<T>(this);
}

typedef Condition = bool Function();

abstract class GetNotifier<T> extends ValuePrueba<T> with GetLifeCycleBase {
  GetNotifier(T initial) : super(initial) {
    $configureLifeCycle();
  }

  @override
  @mustCallSuper
  void onInit() {
    super.onInit();
    ambiguate(SchedulerBinding.instance)
        ?.addPostFrameCallback((_) => onReady());
  }
}

extension StateExt<T> on PruebaMixin<T> {
  Widget obx(
    NotifierBuilder<T?> widget, {
    Widget Function(String? error)? onError,
    Widget? onLoading,
    Widget? onEmpty,
  }) {
    return SimpleBuilder(builder: (_) {
      if (status.isLoading) {
        return onLoading ?? const Center(child: CircularProgressIndicator());
      } else if (status.isError) {
        return onError != null
            ? onError(status.errorMessage)
            : Center(child: Text('A error occurred: ${status.errorMessage}'));
      } else if (status.isEmpty) {
        return onEmpty != null
            ? onEmpty
            : SizedBox.shrink(); // Also can be widget(null); but is risky
      }
      return widget(value);
    });
  }
}

class RxPruebaStatus {
  final bool isLoading;
  final bool isError;
  final bool isSuccess;
  final bool isEmpty;
  final bool isLoadingMore;
  final String? errorMessage;

  RxPruebaStatus._({
    this.isEmpty = false,
    this.isLoading = false,
    this.isError = false,
    this.isSuccess = false,
    this.errorMessage,
    this.isLoadingMore = false,
  });

  factory RxPruebaStatus.loading() {
    return RxPruebaStatus._(isLoading: true);
  }

  factory RxPruebaStatus.loadingMore() {
    return RxPruebaStatus._(isSuccess: true, isLoadingMore: true);
  }

  factory RxPruebaStatus.success() {
    return RxPruebaStatus._(isSuccess: true);
  }

  factory RxPruebaStatus.error([String? message]) {
    return RxPruebaStatus._(isError: true, errorMessage: message);
  }

  factory RxPruebaStatus.empty() {
    return RxPruebaStatus._(isEmpty: true);
  }
}

typedef NotifierBuilder<T> = Widget Function(T state);
