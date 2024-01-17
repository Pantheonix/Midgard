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
const String SortByValueKey = 'sortBy';
const String PageValueKey = 'page';
const String LimitValueKey = 'limit';

final Map<String, String> SortByValueToTitleMap = {
  'NameAsc': 'Name Asc',
  'NameDesc': 'Name Desc',
  'EmailAsc': 'Email Asc',
  'EmailDesc': 'Email Desc',
};

final Map<String, TextEditingController> _ProfileViewTextEditingControllers =
    {};

final Map<String, FocusNode> _ProfileViewFocusNodes = {};

final Map<String, String? Function(String?)?> _ProfileViewTextValidations = {
  NameValueKey: null,
  EmailValueKey: null,
  PageValueKey: null,
  LimitValueKey: null,
};

mixin $ProfileView {
  TextEditingController get nameController =>
      _getFormTextEditingController(NameValueKey);
  TextEditingController get emailController =>
      _getFormTextEditingController(EmailValueKey);
  TextEditingController get pageController =>
      _getFormTextEditingController(PageValueKey);
  TextEditingController get limitController =>
      _getFormTextEditingController(LimitValueKey);

  FocusNode get nameFocusNode => _getFormFocusNode(NameValueKey);
  FocusNode get emailFocusNode => _getFormFocusNode(EmailValueKey);
  FocusNode get pageFocusNode => _getFormFocusNode(PageValueKey);
  FocusNode get limitFocusNode => _getFormFocusNode(LimitValueKey);

  TextEditingController _getFormTextEditingController(
    String key, {
    String? initialValue,
  }) {
    if (_ProfileViewTextEditingControllers.containsKey(key)) {
      return _ProfileViewTextEditingControllers[key]!;
    }

    _ProfileViewTextEditingControllers[key] =
        TextEditingController(text: initialValue);
    return _ProfileViewTextEditingControllers[key]!;
  }

  FocusNode _getFormFocusNode(String key) {
    if (_ProfileViewFocusNodes.containsKey(key)) {
      return _ProfileViewFocusNodes[key]!;
    }
    _ProfileViewFocusNodes[key] = FocusNode();
    return _ProfileViewFocusNodes[key]!;
  }

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  void syncFormWithViewModel(FormStateHelper model) {
    nameController.addListener(() => _updateFormData(model));
    emailController.addListener(() => _updateFormData(model));
    pageController.addListener(() => _updateFormData(model));
    limitController.addListener(() => _updateFormData(model));

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
    pageController.addListener(() => _updateFormData(model));
    limitController.addListener(() => _updateFormData(model));

    _updateFormData(model, forceValidate: _autoTextFieldValidation);
  }

  /// Updates the formData on the FormViewModel
  void _updateFormData(FormStateHelper model, {bool forceValidate = false}) {
    model.setData(
      model.formValueMap
        ..addAll({
          NameValueKey: nameController.text,
          EmailValueKey: emailController.text,
          PageValueKey: pageController.text,
          LimitValueKey: limitController.text,
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

    for (var controller in _ProfileViewTextEditingControllers.values) {
      controller.dispose();
    }
    for (var focusNode in _ProfileViewFocusNodes.values) {
      focusNode.dispose();
    }

    _ProfileViewTextEditingControllers.clear();
    _ProfileViewFocusNodes.clear();
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
  String? get sortByValue => this.formValueMap[SortByValueKey] as String?;
  String? get pageValue => this.formValueMap[PageValueKey] as String?;
  String? get limitValue => this.formValueMap[LimitValueKey] as String?;

  set nameValue(String? value) {
    this.setData(
      this.formValueMap..addAll({NameValueKey: value}),
    );

    if (_ProfileViewTextEditingControllers.containsKey(NameValueKey)) {
      _ProfileViewTextEditingControllers[NameValueKey]?.text = value ?? '';
    }
  }

  set emailValue(String? value) {
    this.setData(
      this.formValueMap..addAll({EmailValueKey: value}),
    );

    if (_ProfileViewTextEditingControllers.containsKey(EmailValueKey)) {
      _ProfileViewTextEditingControllers[EmailValueKey]?.text = value ?? '';
    }
  }

  set pageValue(String? value) {
    this.setData(
      this.formValueMap..addAll({PageValueKey: value}),
    );

    if (_ProfileViewTextEditingControllers.containsKey(PageValueKey)) {
      _ProfileViewTextEditingControllers[PageValueKey]?.text = value ?? '';
    }
  }

  set limitValue(String? value) {
    this.setData(
      this.formValueMap..addAll({LimitValueKey: value}),
    );

    if (_ProfileViewTextEditingControllers.containsKey(LimitValueKey)) {
      _ProfileViewTextEditingControllers[LimitValueKey]?.text = value ?? '';
    }
  }

  bool get hasName =>
      this.formValueMap.containsKey(NameValueKey) &&
      (nameValue?.isNotEmpty ?? false);
  bool get hasEmail =>
      this.formValueMap.containsKey(EmailValueKey) &&
      (emailValue?.isNotEmpty ?? false);
  bool get hasSortBy => this.formValueMap.containsKey(SortByValueKey);
  bool get hasPage =>
      this.formValueMap.containsKey(PageValueKey) &&
      (pageValue?.isNotEmpty ?? false);
  bool get hasLimit =>
      this.formValueMap.containsKey(LimitValueKey) &&
      (limitValue?.isNotEmpty ?? false);

  bool get hasNameValidationMessage =>
      this.fieldsValidationMessages[NameValueKey]?.isNotEmpty ?? false;
  bool get hasEmailValidationMessage =>
      this.fieldsValidationMessages[EmailValueKey]?.isNotEmpty ?? false;
  bool get hasSortByValidationMessage =>
      this.fieldsValidationMessages[SortByValueKey]?.isNotEmpty ?? false;
  bool get hasPageValidationMessage =>
      this.fieldsValidationMessages[PageValueKey]?.isNotEmpty ?? false;
  bool get hasLimitValidationMessage =>
      this.fieldsValidationMessages[LimitValueKey]?.isNotEmpty ?? false;

  String? get nameValidationMessage =>
      this.fieldsValidationMessages[NameValueKey];
  String? get emailValidationMessage =>
      this.fieldsValidationMessages[EmailValueKey];
  String? get sortByValidationMessage =>
      this.fieldsValidationMessages[SortByValueKey];
  String? get pageValidationMessage =>
      this.fieldsValidationMessages[PageValueKey];
  String? get limitValidationMessage =>
      this.fieldsValidationMessages[LimitValueKey];
}

extension Methods on FormStateHelper {
  void setSortBy(String sortBy) {
    this.setData(
      this.formValueMap..addAll({SortByValueKey: sortBy}),
    );

    if (_autoTextFieldValidation) {
      this.validateForm();
    }
  }

  setNameValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[NameValueKey] = validationMessage;
  setEmailValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[EmailValueKey] = validationMessage;
  setSortByValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[SortByValueKey] = validationMessage;
  setPageValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[PageValueKey] = validationMessage;
  setLimitValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[LimitValueKey] = validationMessage;

  /// Clears text input fields on the Form
  void clearForm() {
    nameValue = '';
    emailValue = '';
    pageValue = '';
    limitValue = '';
  }

  /// Validates text input fields on the Form
  void validateForm() {
    this.setValidationMessages({
      NameValueKey: getValidationMessage(NameValueKey),
      EmailValueKey: getValidationMessage(EmailValueKey),
      PageValueKey: getValidationMessage(PageValueKey),
      LimitValueKey: getValidationMessage(LimitValueKey),
    });
  }
}

/// Returns the validation message for the given key
String? getValidationMessage(String key) {
  final validatorForKey = _ProfileViewTextValidations[key];
  if (validatorForKey == null) return null;

  String? validationMessageForKey = validatorForKey(
    _ProfileViewTextEditingControllers[key]!.text,
  );

  return validationMessageForKey;
}

/// Updates the fieldsValidationMessages on the FormViewModel
void updateValidationData(FormStateHelper model) =>
    model.setValidationMessages({
      NameValueKey: getValidationMessage(NameValueKey),
      EmailValueKey: getValidationMessage(EmailValueKey),
      PageValueKey: getValidationMessage(PageValueKey),
      LimitValueKey: getValidationMessage(LimitValueKey),
    });
