// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedFormGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs, constant_identifier_names, non_constant_identifier_names,unnecessary_this

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

const bool _autoTextFieldValidation = true;

const String LtScoreValueKey = 'ltScore';
const String GtScoreValueKey = 'gtScore';
const String LtExecutionTimeValueKey = 'ltExecutionTime';
const String GtExecutionTimeValueKey = 'gtExecutionTime';
const String LtMemoryUsageValueKey = 'ltMemoryUsage';
const String GtMemoryUsageValueKey = 'gtMemoryUsage';

final Map<String, TextEditingController>
    _SubmissionsViewTextEditingControllers = {};

final Map<String, FocusNode> _SubmissionsViewFocusNodes = {};

final Map<String, String? Function(String?)?> _SubmissionsViewTextValidations =
    {
  LtScoreValueKey: null,
  GtScoreValueKey: null,
  LtExecutionTimeValueKey: null,
  GtExecutionTimeValueKey: null,
  LtMemoryUsageValueKey: null,
  GtMemoryUsageValueKey: null,
};

mixin $SubmissionsView {
  TextEditingController get ltScoreController =>
      _getFormTextEditingController(LtScoreValueKey);
  TextEditingController get gtScoreController =>
      _getFormTextEditingController(GtScoreValueKey);
  TextEditingController get ltExecutionTimeController =>
      _getFormTextEditingController(LtExecutionTimeValueKey);
  TextEditingController get gtExecutionTimeController =>
      _getFormTextEditingController(GtExecutionTimeValueKey);
  TextEditingController get ltMemoryUsageController =>
      _getFormTextEditingController(LtMemoryUsageValueKey);
  TextEditingController get gtMemoryUsageController =>
      _getFormTextEditingController(GtMemoryUsageValueKey);

  FocusNode get ltScoreFocusNode => _getFormFocusNode(LtScoreValueKey);
  FocusNode get gtScoreFocusNode => _getFormFocusNode(GtScoreValueKey);
  FocusNode get ltExecutionTimeFocusNode =>
      _getFormFocusNode(LtExecutionTimeValueKey);
  FocusNode get gtExecutionTimeFocusNode =>
      _getFormFocusNode(GtExecutionTimeValueKey);
  FocusNode get ltMemoryUsageFocusNode =>
      _getFormFocusNode(LtMemoryUsageValueKey);
  FocusNode get gtMemoryUsageFocusNode =>
      _getFormFocusNode(GtMemoryUsageValueKey);

  TextEditingController _getFormTextEditingController(
    String key, {
    String? initialValue,
  }) {
    if (_SubmissionsViewTextEditingControllers.containsKey(key)) {
      return _SubmissionsViewTextEditingControllers[key]!;
    }

    _SubmissionsViewTextEditingControllers[key] =
        TextEditingController(text: initialValue);
    return _SubmissionsViewTextEditingControllers[key]!;
  }

  FocusNode _getFormFocusNode(String key) {
    if (_SubmissionsViewFocusNodes.containsKey(key)) {
      return _SubmissionsViewFocusNodes[key]!;
    }
    _SubmissionsViewFocusNodes[key] = FocusNode();
    return _SubmissionsViewFocusNodes[key]!;
  }

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  void syncFormWithViewModel(FormStateHelper model) {
    ltScoreController.addListener(() => _updateFormData(model));
    gtScoreController.addListener(() => _updateFormData(model));
    ltExecutionTimeController.addListener(() => _updateFormData(model));
    gtExecutionTimeController.addListener(() => _updateFormData(model));
    ltMemoryUsageController.addListener(() => _updateFormData(model));
    gtMemoryUsageController.addListener(() => _updateFormData(model));

    _updateFormData(model, forceValidate: _autoTextFieldValidation);
  }

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  @Deprecated(
    'Use syncFormWithViewModel instead.'
    'This feature was deprecated after 3.1.0.',
  )
  void listenToFormUpdated(FormViewModel model) {
    ltScoreController.addListener(() => _updateFormData(model));
    gtScoreController.addListener(() => _updateFormData(model));
    ltExecutionTimeController.addListener(() => _updateFormData(model));
    gtExecutionTimeController.addListener(() => _updateFormData(model));
    ltMemoryUsageController.addListener(() => _updateFormData(model));
    gtMemoryUsageController.addListener(() => _updateFormData(model));

    _updateFormData(model, forceValidate: _autoTextFieldValidation);
  }

  /// Updates the formData on the FormViewModel
  void _updateFormData(FormStateHelper model, {bool forceValidate = false}) {
    model.setData(
      model.formValueMap
        ..addAll({
          LtScoreValueKey: ltScoreController.text,
          GtScoreValueKey: gtScoreController.text,
          LtExecutionTimeValueKey: ltExecutionTimeController.text,
          GtExecutionTimeValueKey: gtExecutionTimeController.text,
          LtMemoryUsageValueKey: ltMemoryUsageController.text,
          GtMemoryUsageValueKey: gtMemoryUsageController.text,
        }),
    );

    if (_autoTextFieldValidation || forceValidate) {
      updateValidationData(model);
    }
  }

  bool validateFormFields(FormViewModel model) {
    _updateFormData(model, forceValidate: true);
    return model.isFormValid;
  }

  /// Calls dispose on all the generated controllers and focus nodes
  void disposeForm() {
    // The dispose function for a TextEditingController sets all listeners to null

    for (var controller in _SubmissionsViewTextEditingControllers.values) {
      controller.dispose();
    }
    for (var focusNode in _SubmissionsViewFocusNodes.values) {
      focusNode.dispose();
    }

    _SubmissionsViewTextEditingControllers.clear();
    _SubmissionsViewFocusNodes.clear();
  }
}

extension ValueProperties on FormStateHelper {
  bool get hasAnyValidationMessage => this
      .fieldsValidationMessages
      .values
      .any((validation) => validation != null);

  bool get isFormValid {
    if (!_autoTextFieldValidation) this.validateForm();

    return !hasAnyValidationMessage;
  }

  String? get ltScoreValue => this.formValueMap[LtScoreValueKey] as String?;
  String? get gtScoreValue => this.formValueMap[GtScoreValueKey] as String?;
  String? get ltExecutionTimeValue =>
      this.formValueMap[LtExecutionTimeValueKey] as String?;
  String? get gtExecutionTimeValue =>
      this.formValueMap[GtExecutionTimeValueKey] as String?;
  String? get ltMemoryUsageValue =>
      this.formValueMap[LtMemoryUsageValueKey] as String?;
  String? get gtMemoryUsageValue =>
      this.formValueMap[GtMemoryUsageValueKey] as String?;

  set ltScoreValue(String? value) {
    this.setData(
      this.formValueMap..addAll({LtScoreValueKey: value}),
    );

    if (_SubmissionsViewTextEditingControllers.containsKey(LtScoreValueKey)) {
      _SubmissionsViewTextEditingControllers[LtScoreValueKey]?.text =
          value ?? '';
    }
  }

  set gtScoreValue(String? value) {
    this.setData(
      this.formValueMap..addAll({GtScoreValueKey: value}),
    );

    if (_SubmissionsViewTextEditingControllers.containsKey(GtScoreValueKey)) {
      _SubmissionsViewTextEditingControllers[GtScoreValueKey]?.text =
          value ?? '';
    }
  }

  set ltExecutionTimeValue(String? value) {
    this.setData(
      this.formValueMap..addAll({LtExecutionTimeValueKey: value}),
    );

    if (_SubmissionsViewTextEditingControllers.containsKey(
        LtExecutionTimeValueKey)) {
      _SubmissionsViewTextEditingControllers[LtExecutionTimeValueKey]?.text =
          value ?? '';
    }
  }

  set gtExecutionTimeValue(String? value) {
    this.setData(
      this.formValueMap..addAll({GtExecutionTimeValueKey: value}),
    );

    if (_SubmissionsViewTextEditingControllers.containsKey(
        GtExecutionTimeValueKey)) {
      _SubmissionsViewTextEditingControllers[GtExecutionTimeValueKey]?.text =
          value ?? '';
    }
  }

  set ltMemoryUsageValue(String? value) {
    this.setData(
      this.formValueMap..addAll({LtMemoryUsageValueKey: value}),
    );

    if (_SubmissionsViewTextEditingControllers.containsKey(
        LtMemoryUsageValueKey)) {
      _SubmissionsViewTextEditingControllers[LtMemoryUsageValueKey]?.text =
          value ?? '';
    }
  }

  set gtMemoryUsageValue(String? value) {
    this.setData(
      this.formValueMap..addAll({GtMemoryUsageValueKey: value}),
    );

    if (_SubmissionsViewTextEditingControllers.containsKey(
        GtMemoryUsageValueKey)) {
      _SubmissionsViewTextEditingControllers[GtMemoryUsageValueKey]?.text =
          value ?? '';
    }
  }

  bool get hasLtScore =>
      this.formValueMap.containsKey(LtScoreValueKey) &&
      (ltScoreValue?.isNotEmpty ?? false);
  bool get hasGtScore =>
      this.formValueMap.containsKey(GtScoreValueKey) &&
      (gtScoreValue?.isNotEmpty ?? false);
  bool get hasLtExecutionTime =>
      this.formValueMap.containsKey(LtExecutionTimeValueKey) &&
      (ltExecutionTimeValue?.isNotEmpty ?? false);
  bool get hasGtExecutionTime =>
      this.formValueMap.containsKey(GtExecutionTimeValueKey) &&
      (gtExecutionTimeValue?.isNotEmpty ?? false);
  bool get hasLtMemoryUsage =>
      this.formValueMap.containsKey(LtMemoryUsageValueKey) &&
      (ltMemoryUsageValue?.isNotEmpty ?? false);
  bool get hasGtMemoryUsage =>
      this.formValueMap.containsKey(GtMemoryUsageValueKey) &&
      (gtMemoryUsageValue?.isNotEmpty ?? false);

  bool get hasLtScoreValidationMessage =>
      this.fieldsValidationMessages[LtScoreValueKey]?.isNotEmpty ?? false;
  bool get hasGtScoreValidationMessage =>
      this.fieldsValidationMessages[GtScoreValueKey]?.isNotEmpty ?? false;
  bool get hasLtExecutionTimeValidationMessage =>
      this.fieldsValidationMessages[LtExecutionTimeValueKey]?.isNotEmpty ??
      false;
  bool get hasGtExecutionTimeValidationMessage =>
      this.fieldsValidationMessages[GtExecutionTimeValueKey]?.isNotEmpty ??
      false;
  bool get hasLtMemoryUsageValidationMessage =>
      this.fieldsValidationMessages[LtMemoryUsageValueKey]?.isNotEmpty ?? false;
  bool get hasGtMemoryUsageValidationMessage =>
      this.fieldsValidationMessages[GtMemoryUsageValueKey]?.isNotEmpty ?? false;

  String? get ltScoreValidationMessage =>
      this.fieldsValidationMessages[LtScoreValueKey];
  String? get gtScoreValidationMessage =>
      this.fieldsValidationMessages[GtScoreValueKey];
  String? get ltExecutionTimeValidationMessage =>
      this.fieldsValidationMessages[LtExecutionTimeValueKey];
  String? get gtExecutionTimeValidationMessage =>
      this.fieldsValidationMessages[GtExecutionTimeValueKey];
  String? get ltMemoryUsageValidationMessage =>
      this.fieldsValidationMessages[LtMemoryUsageValueKey];
  String? get gtMemoryUsageValidationMessage =>
      this.fieldsValidationMessages[GtMemoryUsageValueKey];
}

extension Methods on FormStateHelper {
  setLtScoreValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[LtScoreValueKey] = validationMessage;
  setGtScoreValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[GtScoreValueKey] = validationMessage;
  setLtExecutionTimeValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[LtExecutionTimeValueKey] =
          validationMessage;
  setGtExecutionTimeValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[GtExecutionTimeValueKey] =
          validationMessage;
  setLtMemoryUsageValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[LtMemoryUsageValueKey] = validationMessage;
  setGtMemoryUsageValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[GtMemoryUsageValueKey] = validationMessage;

  /// Clears text input fields on the Form
  void clearForm() {
    ltScoreValue = '';
    gtScoreValue = '';
    ltExecutionTimeValue = '';
    gtExecutionTimeValue = '';
    ltMemoryUsageValue = '';
    gtMemoryUsageValue = '';
  }

  /// Validates text input fields on the Form
  void validateForm() {
    this.setValidationMessages({
      LtScoreValueKey: getValidationMessage(LtScoreValueKey),
      GtScoreValueKey: getValidationMessage(GtScoreValueKey),
      LtExecutionTimeValueKey: getValidationMessage(LtExecutionTimeValueKey),
      GtExecutionTimeValueKey: getValidationMessage(GtExecutionTimeValueKey),
      LtMemoryUsageValueKey: getValidationMessage(LtMemoryUsageValueKey),
      GtMemoryUsageValueKey: getValidationMessage(GtMemoryUsageValueKey),
    });
  }
}

/// Returns the validation message for the given key
String? getValidationMessage(String key) {
  final validatorForKey = _SubmissionsViewTextValidations[key];
  if (validatorForKey == null) return null;

  String? validationMessageForKey = validatorForKey(
    _SubmissionsViewTextEditingControllers[key]!.text,
  );

  return validationMessageForKey;
}

/// Updates the fieldsValidationMessages on the FormViewModel
void updateValidationData(FormStateHelper model) =>
    model.setValidationMessages({
      LtScoreValueKey: getValidationMessage(LtScoreValueKey),
      GtScoreValueKey: getValidationMessage(GtScoreValueKey),
      LtExecutionTimeValueKey: getValidationMessage(LtExecutionTimeValueKey),
      GtExecutionTimeValueKey: getValidationMessage(GtExecutionTimeValueKey),
      LtMemoryUsageValueKey: getValidationMessage(LtMemoryUsageValueKey),
      GtMemoryUsageValueKey: getValidationMessage(GtMemoryUsageValueKey),
    });
