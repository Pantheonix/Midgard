// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedFormGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs, constant_identifier_names, non_constant_identifier_names,unnecessary_this

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

const bool _autoTextFieldValidation = true;

const String NameValueKey = 'name';
const String EmailValueKey = 'email';
const String FullnameValueKey = 'fullname';
const String BioValueKey = 'bio';

final Map<String, TextEditingController>
    _SingleProfileViewTextEditingControllers = {};

final Map<String, FocusNode> _SingleProfileViewFocusNodes = {};

final Map<String, String? Function(String?)?>
    _SingleProfileViewTextValidations = {
  NameValueKey: null,
  EmailValueKey: null,
  FullnameValueKey: null,
  BioValueKey: null,
};

mixin $SingleProfileView {
  TextEditingController get nameController =>
      _getFormTextEditingController(NameValueKey);
  TextEditingController get emailController =>
      _getFormTextEditingController(EmailValueKey);
  TextEditingController get fullnameController =>
      _getFormTextEditingController(FullnameValueKey);
  TextEditingController get bioController =>
      _getFormTextEditingController(BioValueKey);

  FocusNode get nameFocusNode => _getFormFocusNode(NameValueKey);
  FocusNode get emailFocusNode => _getFormFocusNode(EmailValueKey);
  FocusNode get fullnameFocusNode => _getFormFocusNode(FullnameValueKey);
  FocusNode get bioFocusNode => _getFormFocusNode(BioValueKey);

  TextEditingController _getFormTextEditingController(
    String key, {
    String? initialValue,
  }) {
    if (_SingleProfileViewTextEditingControllers.containsKey(key)) {
      return _SingleProfileViewTextEditingControllers[key]!;
    }

    _SingleProfileViewTextEditingControllers[key] =
        TextEditingController(text: initialValue);
    return _SingleProfileViewTextEditingControllers[key]!;
  }

  FocusNode _getFormFocusNode(String key) {
    if (_SingleProfileViewFocusNodes.containsKey(key)) {
      return _SingleProfileViewFocusNodes[key]!;
    }
    _SingleProfileViewFocusNodes[key] = FocusNode();
    return _SingleProfileViewFocusNodes[key]!;
  }

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  void syncFormWithViewModel(FormStateHelper model) {
    nameController.addListener(() => _updateFormData(model));
    emailController.addListener(() => _updateFormData(model));
    fullnameController.addListener(() => _updateFormData(model));
    bioController.addListener(() => _updateFormData(model));

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
    emailController.addListener(() => _updateFormData(model));
    fullnameController.addListener(() => _updateFormData(model));
    bioController.addListener(() => _updateFormData(model));

    _updateFormData(model, forceValidate: _autoTextFieldValidation);
  }

  /// Updates the formData on the FormViewModel
  void _updateFormData(FormStateHelper model, {bool forceValidate = false}) {
    model.setData(
      model.formValueMap
        ..addAll({
          NameValueKey: nameController.text,
          EmailValueKey: emailController.text,
          FullnameValueKey: fullnameController.text,
          BioValueKey: bioController.text,
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

    for (var controller in _SingleProfileViewTextEditingControllers.values) {
      controller.dispose();
    }
    for (var focusNode in _SingleProfileViewFocusNodes.values) {
      focusNode.dispose();
    }

    _SingleProfileViewTextEditingControllers.clear();
    _SingleProfileViewFocusNodes.clear();
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
  String? get emailValue => this.formValueMap[EmailValueKey] as String?;
  String? get fullnameValue => this.formValueMap[FullnameValueKey] as String?;
  String? get bioValue => this.formValueMap[BioValueKey] as String?;

  set nameValue(String? value) {
    this.setData(
      this.formValueMap..addAll({NameValueKey: value}),
    );

    if (_SingleProfileViewTextEditingControllers.containsKey(NameValueKey)) {
      _SingleProfileViewTextEditingControllers[NameValueKey]?.text =
          value ?? '';
    }
  }

  set emailValue(String? value) {
    this.setData(
      this.formValueMap..addAll({EmailValueKey: value}),
    );

    if (_SingleProfileViewTextEditingControllers.containsKey(EmailValueKey)) {
      _SingleProfileViewTextEditingControllers[EmailValueKey]?.text =
          value ?? '';
    }
  }

  set fullnameValue(String? value) {
    this.setData(
      this.formValueMap..addAll({FullnameValueKey: value}),
    );

    if (_SingleProfileViewTextEditingControllers.containsKey(
        FullnameValueKey)) {
      _SingleProfileViewTextEditingControllers[FullnameValueKey]?.text =
          value ?? '';
    }
  }

  set bioValue(String? value) {
    this.setData(
      this.formValueMap..addAll({BioValueKey: value}),
    );

    if (_SingleProfileViewTextEditingControllers.containsKey(BioValueKey)) {
      _SingleProfileViewTextEditingControllers[BioValueKey]?.text = value ?? '';
    }
  }

  bool get hasName =>
      this.formValueMap.containsKey(NameValueKey) &&
      (nameValue?.isNotEmpty ?? false);
  bool get hasEmail =>
      this.formValueMap.containsKey(EmailValueKey) &&
      (emailValue?.isNotEmpty ?? false);
  bool get hasFullname =>
      this.formValueMap.containsKey(FullnameValueKey) &&
      (fullnameValue?.isNotEmpty ?? false);
  bool get hasBio =>
      this.formValueMap.containsKey(BioValueKey) &&
      (bioValue?.isNotEmpty ?? false);

  bool get hasNameValidationMessage =>
      this.fieldsValidationMessages[NameValueKey]?.isNotEmpty ?? false;
  bool get hasEmailValidationMessage =>
      this.fieldsValidationMessages[EmailValueKey]?.isNotEmpty ?? false;
  bool get hasFullnameValidationMessage =>
      this.fieldsValidationMessages[FullnameValueKey]?.isNotEmpty ?? false;
  bool get hasBioValidationMessage =>
      this.fieldsValidationMessages[BioValueKey]?.isNotEmpty ?? false;

  String? get nameValidationMessage =>
      this.fieldsValidationMessages[NameValueKey];
  String? get emailValidationMessage =>
      this.fieldsValidationMessages[EmailValueKey];
  String? get fullnameValidationMessage =>
      this.fieldsValidationMessages[FullnameValueKey];
  String? get bioValidationMessage =>
      this.fieldsValidationMessages[BioValueKey];
}

extension Methods on FormStateHelper {
  setNameValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[NameValueKey] = validationMessage;
  setEmailValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[EmailValueKey] = validationMessage;
  setFullnameValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[FullnameValueKey] = validationMessage;
  setBioValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[BioValueKey] = validationMessage;

  /// Clears text input fields on the Form
  void clearForm() {
    nameValue = '';
    emailValue = '';
    fullnameValue = '';
    bioValue = '';
  }

  /// Validates text input fields on the Form
  void validateForm() {
    this.setValidationMessages({
      NameValueKey: getValidationMessage(NameValueKey),
      EmailValueKey: getValidationMessage(EmailValueKey),
      FullnameValueKey: getValidationMessage(FullnameValueKey),
      BioValueKey: getValidationMessage(BioValueKey),
    });
  }
}

/// Returns the validation message for the given key
String? getValidationMessage(String key) {
  final validatorForKey = _SingleProfileViewTextValidations[key];
  if (validatorForKey == null) return null;

  String? validationMessageForKey = validatorForKey(
    _SingleProfileViewTextEditingControllers[key]!.text,
  );

  return validationMessageForKey;
}

/// Updates the fieldsValidationMessages on the FormViewModel
void updateValidationData(FormStateHelper model) =>
    model.setValidationMessages({
      NameValueKey: getValidationMessage(NameValueKey),
      EmailValueKey: getValidationMessage(EmailValueKey),
      FullnameValueKey: getValidationMessage(FullnameValueKey),
      BioValueKey: getValidationMessage(BioValueKey),
    });
