// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedFormGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs, constant_identifier_names, non_constant_identifier_names,unnecessary_this

import 'package:flutter/material.dart';
import 'package:midgard/models/validators/problem_validators.dart';
import 'package:stacked/stacked.dart';

const bool _autoTextFieldValidation = true;

const String NameValueKey = 'name';
const String BriefValueKey = 'brief';
const String DescriptionValueKey = 'description';
const String SourceNameValueKey = 'sourceName';
const String AuthorNameValueKey = 'authorName';
const String TimeLimitValueKey = 'timeLimit';
const String TotalMemoryLimitValueKey = 'totalMemoryLimit';
const String StackMemoryLimitValueKey = 'stackMemoryLimit';

final Map<String, TextEditingController>
    _UpdateProposalDashboardViewTextEditingControllers = {};

final Map<String, FocusNode> _UpdateProposalDashboardViewFocusNodes = {};

final Map<String, String? Function(String?)?>
    _UpdateProposalDashboardViewTextValidations = {
  NameValueKey: ProblemValidators.validateName,
  BriefValueKey: ProblemValidators.validateBrief,
  DescriptionValueKey: ProblemValidators.validateDescription,
  SourceNameValueKey: ProblemValidators.validateSourceName,
  AuthorNameValueKey: ProblemValidators.validateAuthorName,
  TimeLimitValueKey: ProblemValidators.validateTimeLimit,
  TotalMemoryLimitValueKey: ProblemValidators.validateTotalMemoryLimit,
  StackMemoryLimitValueKey: ProblemValidators.validateStackMemoryLimit,
};

mixin $UpdateProposalDashboardView {
  TextEditingController get nameController =>
      _getFormTextEditingController(NameValueKey);
  TextEditingController get briefController =>
      _getFormTextEditingController(BriefValueKey);
  TextEditingController get descriptionController =>
      _getFormTextEditingController(DescriptionValueKey);
  TextEditingController get sourceNameController =>
      _getFormTextEditingController(SourceNameValueKey);
  TextEditingController get authorNameController =>
      _getFormTextEditingController(AuthorNameValueKey);
  TextEditingController get timeLimitController =>
      _getFormTextEditingController(TimeLimitValueKey);
  TextEditingController get totalMemoryLimitController =>
      _getFormTextEditingController(TotalMemoryLimitValueKey);
  TextEditingController get stackMemoryLimitController =>
      _getFormTextEditingController(StackMemoryLimitValueKey);

  FocusNode get nameFocusNode => _getFormFocusNode(NameValueKey);
  FocusNode get briefFocusNode => _getFormFocusNode(BriefValueKey);
  FocusNode get descriptionFocusNode => _getFormFocusNode(DescriptionValueKey);
  FocusNode get sourceNameFocusNode => _getFormFocusNode(SourceNameValueKey);
  FocusNode get authorNameFocusNode => _getFormFocusNode(AuthorNameValueKey);
  FocusNode get timeLimitFocusNode => _getFormFocusNode(TimeLimitValueKey);
  FocusNode get totalMemoryLimitFocusNode =>
      _getFormFocusNode(TotalMemoryLimitValueKey);
  FocusNode get stackMemoryLimitFocusNode =>
      _getFormFocusNode(StackMemoryLimitValueKey);

  TextEditingController _getFormTextEditingController(
    String key, {
    String? initialValue,
  }) {
    if (_UpdateProposalDashboardViewTextEditingControllers.containsKey(key)) {
      return _UpdateProposalDashboardViewTextEditingControllers[key]!;
    }

    _UpdateProposalDashboardViewTextEditingControllers[key] =
        TextEditingController(text: initialValue);
    return _UpdateProposalDashboardViewTextEditingControllers[key]!;
  }

  FocusNode _getFormFocusNode(String key) {
    if (_UpdateProposalDashboardViewFocusNodes.containsKey(key)) {
      return _UpdateProposalDashboardViewFocusNodes[key]!;
    }
    _UpdateProposalDashboardViewFocusNodes[key] = FocusNode();
    return _UpdateProposalDashboardViewFocusNodes[key]!;
  }

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  void syncFormWithViewModel(FormStateHelper model) {
    nameController.addListener(() => _updateFormData(model));
    briefController.addListener(() => _updateFormData(model));
    descriptionController.addListener(() => _updateFormData(model));
    sourceNameController.addListener(() => _updateFormData(model));
    authorNameController.addListener(() => _updateFormData(model));
    timeLimitController.addListener(() => _updateFormData(model));
    totalMemoryLimitController.addListener(() => _updateFormData(model));
    stackMemoryLimitController.addListener(() => _updateFormData(model));

    _updateFormData(model, forceValidate: _autoTextFieldValidation);
  }

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  @Deprecated(
    'Use syncFormWithViewModel instead.'
    'This feature was deprecated after 3.1.0.',
  )
  void listenToFormUpdated(FormViewModel model) {
    nameController.addListener(() => _updateFormData(model));
    briefController.addListener(() => _updateFormData(model));
    descriptionController.addListener(() => _updateFormData(model));
    sourceNameController.addListener(() => _updateFormData(model));
    authorNameController.addListener(() => _updateFormData(model));
    timeLimitController.addListener(() => _updateFormData(model));
    totalMemoryLimitController.addListener(() => _updateFormData(model));
    stackMemoryLimitController.addListener(() => _updateFormData(model));

    _updateFormData(model, forceValidate: _autoTextFieldValidation);
  }

  /// Updates the formData on the FormViewModel
  void _updateFormData(FormStateHelper model, {bool forceValidate = false}) {
    model.setData(
      model.formValueMap
        ..addAll({
          NameValueKey: nameController.text,
          BriefValueKey: briefController.text,
          DescriptionValueKey: descriptionController.text,
          SourceNameValueKey: sourceNameController.text,
          AuthorNameValueKey: authorNameController.text,
          TimeLimitValueKey: timeLimitController.text,
          TotalMemoryLimitValueKey: totalMemoryLimitController.text,
          StackMemoryLimitValueKey: stackMemoryLimitController.text,
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

    for (var controller
        in _UpdateProposalDashboardViewTextEditingControllers.values) {
      controller.dispose();
    }
    for (var focusNode in _UpdateProposalDashboardViewFocusNodes.values) {
      focusNode.dispose();
    }

    _UpdateProposalDashboardViewTextEditingControllers.clear();
    _UpdateProposalDashboardViewFocusNodes.clear();
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

  String? get nameValue => this.formValueMap[NameValueKey] as String?;
  String? get briefValue => this.formValueMap[BriefValueKey] as String?;
  String? get descriptionValue =>
      this.formValueMap[DescriptionValueKey] as String?;
  String? get sourceNameValue =>
      this.formValueMap[SourceNameValueKey] as String?;
  String? get authorNameValue =>
      this.formValueMap[AuthorNameValueKey] as String?;
  String? get timeLimitValue => this.formValueMap[TimeLimitValueKey] as String?;
  String? get totalMemoryLimitValue =>
      this.formValueMap[TotalMemoryLimitValueKey] as String?;
  String? get stackMemoryLimitValue =>
      this.formValueMap[StackMemoryLimitValueKey] as String?;

  set nameValue(String? value) {
    this.setData(
      this.formValueMap..addAll({NameValueKey: value}),
    );

    if (_UpdateProposalDashboardViewTextEditingControllers.containsKey(
        NameValueKey)) {
      _UpdateProposalDashboardViewTextEditingControllers[NameValueKey]?.text =
          value ?? '';
    }
  }

  set briefValue(String? value) {
    this.setData(
      this.formValueMap..addAll({BriefValueKey: value}),
    );

    if (_UpdateProposalDashboardViewTextEditingControllers.containsKey(
        BriefValueKey)) {
      _UpdateProposalDashboardViewTextEditingControllers[BriefValueKey]?.text =
          value ?? '';
    }
  }

  set descriptionValue(String? value) {
    this.setData(
      this.formValueMap..addAll({DescriptionValueKey: value}),
    );

    if (_UpdateProposalDashboardViewTextEditingControllers.containsKey(
        DescriptionValueKey)) {
      _UpdateProposalDashboardViewTextEditingControllers[DescriptionValueKey]
          ?.text = value ?? '';
    }
  }

  set sourceNameValue(String? value) {
    this.setData(
      this.formValueMap..addAll({SourceNameValueKey: value}),
    );

    if (_UpdateProposalDashboardViewTextEditingControllers.containsKey(
        SourceNameValueKey)) {
      _UpdateProposalDashboardViewTextEditingControllers[SourceNameValueKey]
          ?.text = value ?? '';
    }
  }

  set authorNameValue(String? value) {
    this.setData(
      this.formValueMap..addAll({AuthorNameValueKey: value}),
    );

    if (_UpdateProposalDashboardViewTextEditingControllers.containsKey(
        AuthorNameValueKey)) {
      _UpdateProposalDashboardViewTextEditingControllers[AuthorNameValueKey]
          ?.text = value ?? '';
    }
  }

  set timeLimitValue(String? value) {
    this.setData(
      this.formValueMap..addAll({TimeLimitValueKey: value}),
    );

    if (_UpdateProposalDashboardViewTextEditingControllers.containsKey(
        TimeLimitValueKey)) {
      _UpdateProposalDashboardViewTextEditingControllers[TimeLimitValueKey]
          ?.text = value ?? '';
    }
  }

  set totalMemoryLimitValue(String? value) {
    this.setData(
      this.formValueMap..addAll({TotalMemoryLimitValueKey: value}),
    );

    if (_UpdateProposalDashboardViewTextEditingControllers.containsKey(
        TotalMemoryLimitValueKey)) {
      _UpdateProposalDashboardViewTextEditingControllers[
              TotalMemoryLimitValueKey]
          ?.text = value ?? '';
    }
  }

  set stackMemoryLimitValue(String? value) {
    this.setData(
      this.formValueMap..addAll({StackMemoryLimitValueKey: value}),
    );

    if (_UpdateProposalDashboardViewTextEditingControllers.containsKey(
        StackMemoryLimitValueKey)) {
      _UpdateProposalDashboardViewTextEditingControllers[
              StackMemoryLimitValueKey]
          ?.text = value ?? '';
    }
  }

  bool get hasName =>
      this.formValueMap.containsKey(NameValueKey) &&
      (nameValue?.isNotEmpty ?? false);
  bool get hasBrief =>
      this.formValueMap.containsKey(BriefValueKey) &&
      (briefValue?.isNotEmpty ?? false);
  bool get hasDescription =>
      this.formValueMap.containsKey(DescriptionValueKey) &&
      (descriptionValue?.isNotEmpty ?? false);
  bool get hasSourceName =>
      this.formValueMap.containsKey(SourceNameValueKey) &&
      (sourceNameValue?.isNotEmpty ?? false);
  bool get hasAuthorName =>
      this.formValueMap.containsKey(AuthorNameValueKey) &&
      (authorNameValue?.isNotEmpty ?? false);
  bool get hasTimeLimit =>
      this.formValueMap.containsKey(TimeLimitValueKey) &&
      (timeLimitValue?.isNotEmpty ?? false);
  bool get hasTotalMemoryLimit =>
      this.formValueMap.containsKey(TotalMemoryLimitValueKey) &&
      (totalMemoryLimitValue?.isNotEmpty ?? false);
  bool get hasStackMemoryLimit =>
      this.formValueMap.containsKey(StackMemoryLimitValueKey) &&
      (stackMemoryLimitValue?.isNotEmpty ?? false);

  bool get hasNameValidationMessage =>
      this.fieldsValidationMessages[NameValueKey]?.isNotEmpty ?? false;
  bool get hasBriefValidationMessage =>
      this.fieldsValidationMessages[BriefValueKey]?.isNotEmpty ?? false;
  bool get hasDescriptionValidationMessage =>
      this.fieldsValidationMessages[DescriptionValueKey]?.isNotEmpty ?? false;
  bool get hasSourceNameValidationMessage =>
      this.fieldsValidationMessages[SourceNameValueKey]?.isNotEmpty ?? false;
  bool get hasAuthorNameValidationMessage =>
      this.fieldsValidationMessages[AuthorNameValueKey]?.isNotEmpty ?? false;
  bool get hasTimeLimitValidationMessage =>
      this.fieldsValidationMessages[TimeLimitValueKey]?.isNotEmpty ?? false;
  bool get hasTotalMemoryLimitValidationMessage =>
      this.fieldsValidationMessages[TotalMemoryLimitValueKey]?.isNotEmpty ??
      false;
  bool get hasStackMemoryLimitValidationMessage =>
      this.fieldsValidationMessages[StackMemoryLimitValueKey]?.isNotEmpty ??
      false;

  String? get nameValidationMessage =>
      this.fieldsValidationMessages[NameValueKey];
  String? get briefValidationMessage =>
      this.fieldsValidationMessages[BriefValueKey];
  String? get descriptionValidationMessage =>
      this.fieldsValidationMessages[DescriptionValueKey];
  String? get sourceNameValidationMessage =>
      this.fieldsValidationMessages[SourceNameValueKey];
  String? get authorNameValidationMessage =>
      this.fieldsValidationMessages[AuthorNameValueKey];
  String? get timeLimitValidationMessage =>
      this.fieldsValidationMessages[TimeLimitValueKey];
  String? get totalMemoryLimitValidationMessage =>
      this.fieldsValidationMessages[TotalMemoryLimitValueKey];
  String? get stackMemoryLimitValidationMessage =>
      this.fieldsValidationMessages[StackMemoryLimitValueKey];
}

extension Methods on FormStateHelper {
  setNameValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[NameValueKey] = validationMessage;
  setBriefValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[BriefValueKey] = validationMessage;
  setDescriptionValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[DescriptionValueKey] = validationMessage;
  setSourceNameValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[SourceNameValueKey] = validationMessage;
  setAuthorNameValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[AuthorNameValueKey] = validationMessage;
  setTimeLimitValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[TimeLimitValueKey] = validationMessage;
  setTotalMemoryLimitValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[TotalMemoryLimitValueKey] =
          validationMessage;
  setStackMemoryLimitValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[StackMemoryLimitValueKey] =
          validationMessage;

  /// Clears text input fields on the Form
  void clearForm() {
    nameValue = '';
    briefValue = '';
    descriptionValue = '';
    sourceNameValue = '';
    authorNameValue = '';
    timeLimitValue = '';
    totalMemoryLimitValue = '';
    stackMemoryLimitValue = '';
  }

  /// Validates text input fields on the Form
  void validateForm() {
    this.setValidationMessages({
      NameValueKey: getValidationMessage(NameValueKey),
      BriefValueKey: getValidationMessage(BriefValueKey),
      DescriptionValueKey: getValidationMessage(DescriptionValueKey),
      SourceNameValueKey: getValidationMessage(SourceNameValueKey),
      AuthorNameValueKey: getValidationMessage(AuthorNameValueKey),
      TimeLimitValueKey: getValidationMessage(TimeLimitValueKey),
      TotalMemoryLimitValueKey: getValidationMessage(TotalMemoryLimitValueKey),
      StackMemoryLimitValueKey: getValidationMessage(StackMemoryLimitValueKey),
    });
  }
}

/// Returns the validation message for the given key
String? getValidationMessage(String key) {
  final validatorForKey = _UpdateProposalDashboardViewTextValidations[key];
  if (validatorForKey == null) return null;

  String? validationMessageForKey = validatorForKey(
    _UpdateProposalDashboardViewTextEditingControllers[key]!.text,
  );

  return validationMessageForKey;
}

/// Updates the fieldsValidationMessages on the FormViewModel
void updateValidationData(FormStateHelper model) =>
    model.setValidationMessages({
      NameValueKey: getValidationMessage(NameValueKey),
      BriefValueKey: getValidationMessage(BriefValueKey),
      DescriptionValueKey: getValidationMessage(DescriptionValueKey),
      SourceNameValueKey: getValidationMessage(SourceNameValueKey),
      AuthorNameValueKey: getValidationMessage(AuthorNameValueKey),
      TimeLimitValueKey: getValidationMessage(TimeLimitValueKey),
      TotalMemoryLimitValueKey: getValidationMessage(TotalMemoryLimitValueKey),
      StackMemoryLimitValueKey: getValidationMessage(StackMemoryLimitValueKey),
    });
