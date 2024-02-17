// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedFormGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs, constant_identifier_names, non_constant_identifier_names,unnecessary_this

import 'package:flutter/material.dart';
import 'package:midgard/models/validators/problem_validators.dart';
import 'package:stacked/stacked.dart';

const bool _autoTextFieldValidation = true;

const String TestScoreValueKey = 'testScore';

final Map<String, TextEditingController> _UpdateTestTileTextEditingControllers =
    {};

final Map<String, FocusNode> _UpdateTestTileFocusNodes = {};

final Map<String, String? Function(String?)?> _UpdateTestTileTextValidations = {
  TestScoreValueKey: ProblemValidators.validateTestScore,
};

mixin $UpdateTestTile {
  TextEditingController get testScoreController =>
      _getFormTextEditingController(TestScoreValueKey);

  FocusNode get testScoreFocusNode => _getFormFocusNode(TestScoreValueKey);

  TextEditingController _getFormTextEditingController(
    String key, {
    String? initialValue,
  }) {
    if (_UpdateTestTileTextEditingControllers.containsKey(key)) {
      return _UpdateTestTileTextEditingControllers[key]!;
    }

    _UpdateTestTileTextEditingControllers[key] =
        TextEditingController(text: initialValue);
    return _UpdateTestTileTextEditingControllers[key]!;
  }

  FocusNode _getFormFocusNode(String key) {
    if (_UpdateTestTileFocusNodes.containsKey(key)) {
      return _UpdateTestTileFocusNodes[key]!;
    }
    _UpdateTestTileFocusNodes[key] = FocusNode();
    return _UpdateTestTileFocusNodes[key]!;
  }

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  void syncFormWithViewModel(FormStateHelper model) {
    testScoreController.addListener(() => _updateFormData(model));

    _updateFormData(model, forceValidate: _autoTextFieldValidation);
  }

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  @Deprecated(
    'Use syncFormWithViewModel instead.'
    'This feature was deprecated after 3.1.0.',
  )
  void listenToFormUpdated(FormViewModel model) {
    testScoreController.addListener(() => _updateFormData(model));

    _updateFormData(model, forceValidate: _autoTextFieldValidation);
  }

  /// Updates the formData on the FormViewModel
  void _updateFormData(FormStateHelper model, {bool forceValidate = false}) {
    model.setData(
      model.formValueMap
        ..addAll({
          TestScoreValueKey: testScoreController.text,
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

    for (var controller in _UpdateTestTileTextEditingControllers.values) {
      controller.dispose();
    }
    for (var focusNode in _UpdateTestTileFocusNodes.values) {
      focusNode.dispose();
    }

    _UpdateTestTileTextEditingControllers.clear();
    _UpdateTestTileFocusNodes.clear();
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

  String? get testScoreValue => this.formValueMap[TestScoreValueKey] as String?;

  set testScoreValue(String? value) {
    this.setData(
      this.formValueMap..addAll({TestScoreValueKey: value}),
    );

    if (_UpdateTestTileTextEditingControllers.containsKey(TestScoreValueKey)) {
      _UpdateTestTileTextEditingControllers[TestScoreValueKey]?.text =
          value ?? '';
    }
  }

  bool get hasTestScore =>
      this.formValueMap.containsKey(TestScoreValueKey) &&
      (testScoreValue?.isNotEmpty ?? false);

  bool get hasTestScoreValidationMessage =>
      this.fieldsValidationMessages[TestScoreValueKey]?.isNotEmpty ?? false;

  String? get testScoreValidationMessage =>
      this.fieldsValidationMessages[TestScoreValueKey];
}

extension Methods on FormStateHelper {
  setTestScoreValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[TestScoreValueKey] = validationMessage;

  /// Clears text input fields on the Form
  void clearForm() {
    testScoreValue = '';
  }

  /// Validates text input fields on the Form
  void validateForm() {
    this.setValidationMessages({
      TestScoreValueKey: getValidationMessage(TestScoreValueKey),
    });
  }
}

/// Returns the validation message for the given key
String? getValidationMessage(String key) {
  final validatorForKey = _UpdateTestTileTextValidations[key];
  if (validatorForKey == null) return null;

  String? validationMessageForKey = validatorForKey(
    _UpdateTestTileTextEditingControllers[key]!.text,
  );

  return validationMessageForKey;
}

/// Updates the fieldsValidationMessages on the FormViewModel
void updateValidationData(FormStateHelper model) =>
    model.setValidationMessages({
      TestScoreValueKey: getValidationMessage(TestScoreValueKey),
    });
