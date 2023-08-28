import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

mixin RxObxMixin {
  RxObxStatus? _status;
  Map<String, RxValues> _rxMapValues = {};
  Map<String, Rx<ProviderResponse>> _rxMapProvider = {};
  RxObxStatus? saveStatus;
  BuildContext? context;

  RxObxStatus get status {
    return _status ??= _status = RxObxStatus.empty();
  }

  // Functions

  /// Add RxValue to Map<Rx<dynamic>>>.
  ///
  /// Example:
  ///
  /// addListRxValues(1, id: "cont1");
  ///
  /// or
  ///
  /// RxInt cont = 1.obs;
  ///
  /// addListRxValues(cont, id: "cont1");
  @protected
  void addRxValues(dynamic dynamicValue,
      {required String id, RxObxStatus? status}) {
    Rx<dynamic> rxDynamic =
        dynamicValue is Rx<dynamic> ? dynamicValue : Rx<dynamic>(dynamicValue);
    if (_rxMapValues[id] == null) {
      if (status != null) {
        _rxMapValues[id] = RxValues(rxValue: rxDynamic, rxStatus: status);
      } else {
        _rxMapValues[id] = RxValues(rxValue: rxDynamic);
      }
    }
  }

  /// Add Provider to Rx<ResponseUser>.
  ///
  /// Create provider petition for server or client.
  ///
  /// Get Values
  ///
  /// int? code;
  ///
  /// String? messageError;
  ///
  /// String? messageSuccess;
  ///
  /// Progress progress; { pending, loading, error, success }
  @protected
  void addP({required String id}) {
    if (_rxMapProvider[id] == null) {
      _rxMapProvider[id] = ProviderResponse().obs;
    }
  }

  /// Change value.
  /// Status or NewState
  @protected
  void change(FunctionNewState? newState,
      {required String id, RxObxStatus? status}) {
    dynamic newStateFunction =
        newState != null ? newState(_rxMapValues[id]!.rxValue.value) : null;
    bool _canUpdate = false;
    if (status != null) {
      if (status != _rxMapValues[id]!.rxStatus) {
        _rxMapValues[id]!.rxStatus = status;
        _canUpdate = true;
      }
    }
    if (newStateFunction != _rxMapValues[id]!.rxValue.value) {
      _canUpdate = true;
    }
    if (_canUpdate) {
      refreshRxObx(id, newStateFunction);
    }
  }

  /// Change Provider.
  /// State or NewState
  @protected
  void changeP(int code, {required String id, RxObxStatus? status}) {
    _rxMapProvider[id]!.value = ProviderResponse(code: code, status: status);
  }

  /// Change Status Dialog.
  @protected
  void dialogStatus(
      {int? code, String? title, String? message, RxObxStatus? status}) {
    if (context != null) {
      // Close Loading State
      if (saveStatus != null) {
        if (saveStatus!.isLoading && RxObxStatus.loading().isLoading) {
          saveStatus = null;
          Navigator.pop(context!);
        }
      } else {
        saveStatus = status;
      }
      if (status != null) {
        if (status.isSuccess) {
          // showDialog(
          //     context: context!,
          //     builder: (BuildContext context) {
          //       if (message != null) {
          //   return RichAlertDialog(
          //     alertTitle: richTitle(title!),
          //     alertSubtitle: richSubtitle(message),
          //     alertType: RichAlertType.SUCCESS,
          //   );
          // } else {
          //   return RichAlertDialog(
          //     alertTitle: richTitle(title!),
          //     alertType: RichAlertType.SUCCESS,
          //   );
          // }
          // });
        } else if (status.isLoading) {
          // showDialog(
          //     context: context!,
          //     builder: (BuildContext context) {
          //       return RichAlertDialog(
          //         alertType: RichAlertType.LOADING,
          //       );
          //     });
        } else if (status.isError) {
          // showDialog(
          //     context: context!,
          //     builder: (BuildContext context) {
          //       if (message != null) {
          //         return RichAlertDialog(
          //           alertTitle: richTitle(title!),
          //           alertSubtitle: richSubtitle(message + " Code: $code."),
          //           alertType: RichAlertType.ERROR,
          //         );
          //       } else {
          //         return RichAlertDialog(
          //           alertTitle: richTitle(title!),
          //           alertType: RichAlertType.ERROR,
          //         );
          //       }
          //     });
        }
      }
    } else {
      throw ('''Inicialize context.
  File Controller
  @override
  onInit() {
    /// Save Context For Dialog 
    context = Get.context;
  }''');
    }
  }

  /// Refresh Set New State
  @protected
  void refreshRxObx(String id, dynamic newStateFunction) {
    if (newStateFunction != null) {
      _rxMapValues[id]!.rxValue.value = newStateFunction;
    } else {
      _rxMapValues[id]!.rxValue.refresh();
    }
  }

  /// Get RxValue
  ///
  /// id define to user
  ///
  /// getRxValue(id);
  @protected
  RxValues? getRxValue(String id) {
    if (_rxMapValues[id] != null) {
      return _rxMapValues[id]!;
    } else {
      return null;
    }
  }

  /// Widget Obx
  Widget rxObx(
    WidgetBuilder widget, {
    Widget Function(String? error)? onError,
    required String id,
    Widget? onLoading,
    Widget? onBoolean,
    Widget? onEmpty,
  }) {
    return Obx(() {
      if (_rxMapValues[id] == null) {
        throw ("The id not exits rxValue.");
      }
      dynamic rxValueController = _rxMapValues[id]!.rxValue.value;
      RxObxStatus? rxStatus = _rxMapValues[id]!.rxStatus;
      if (rxStatus != null) {
        if (rxStatus.isLoading) {
          return onLoading ?? const Center(child: CircularProgressIndicator());
        } else if (rxStatus.isError) {
          return onError != null
              ? onError(status.errorMessage)
              : Center(child: Text('A error occurred: ${status.errorMessage}'));
        } else if (rxStatus.isEmpty) {
          return onEmpty != null
              ? onEmpty
              : SizedBox.shrink(); // Also can be widget(null); but is risky
        }
      }
      return widget(rxValueController);
    });
  }

  /// Widget Obx Provider
  Widget rxObxP(
    WidgetBuilder widget, {
    Widget Function(String? error)? onError,
    Widget Function(String? message)? onSuccess,
    required String id,
    Widget? onLoading,
    Widget? onBoolean,
    Widget? onEmpty,
  }) {
    return Obx(() {
      if (_rxMapProvider[id] == null) {
        throw ("The id not exits rxValue.");
      }
      ProviderResponse rxValueController = _rxMapProvider[id]!.value;
      RxObxStatus? rxStatus = rxValueController.status;
      if (rxStatus != null) {
        if (rxStatus.isLoading) {
          return onLoading ?? const Center(child: CircularProgressIndicator());
        } else if (rxStatus.isError) {
          return onError != null
              ? onError(status.errorMessage)
              : Center(child: Text('A error occurred: ${status.errorMessage}'));
        } else if (rxStatus.isEmpty) {
          return onEmpty != null
              ? onEmpty
              : SizedBox.shrink(); // Also can be widget(null); but is risky
        }
      }
      return widget(rxValueController);
    });
  }
}

typedef FunctionNewState<T> = dynamic Function(T state);

typedef WidgetBuilder<T> = Widget Function(T state);

class RxValues {
  RxObxStatus? rxStatus;
  Rx<dynamic> rxValue;
  RxValues({required this.rxValue, this.rxStatus});
}

class RxObxStatus {
  final bool isLoading;
  final bool isError;
  final bool isSuccess;
  final bool isEmpty;
  final bool isLoadingMore;
  final String? errorMessage;
  final String? successMessage;

  RxObxStatus._({
    this.isEmpty = false,
    this.isLoading = false,
    this.isError = false,
    this.isSuccess = false,
    this.errorMessage,
    this.successMessage,
    this.isLoadingMore = false,
  });

  factory RxObxStatus.loading() {
    return RxObxStatus._(isLoading: true);
  }

  factory RxObxStatus.loadingMore() {
    return RxObxStatus._(isSuccess: true, isLoadingMore: true);
  }

  factory RxObxStatus.success() {
    return RxObxStatus._(isSuccess: true);
  }
  factory RxObxStatus.successMessage(String? message) {
    return RxObxStatus._(isSuccess: true, successMessage: message);
  }

  factory RxObxStatus.error([String? message]) {
    return RxObxStatus._(isError: true, errorMessage: message);
  }

  factory RxObxStatus.empty() {
    return RxObxStatus._(isEmpty: true);
  }
}

class ProviderResponse {
  int? code;
  RxObxStatus? status;
  ProviderResponse({
    this.code,
    this.status,
  });
}
