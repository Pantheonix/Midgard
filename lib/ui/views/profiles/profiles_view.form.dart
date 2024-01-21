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
const String PageSizeValueKey = 'pageSize';

final Map<String, String> SortByValueToTitleMap = {
  'NameAsc': 'Name Asc',
  'NameDesc': 'Name Desc',
  'EmailAsc': 'Email Asc',
  'EmailDesc': 'Email Desc',
};

final Map<String, TextEditingController> _ProfilesViewTextEditingControllers =
    {};

final Map<String, FocusNode> _ProfilesViewFocusNodes = {};

final Map<String, String? Function(String?)?> _ProfilesViewTextValidations = {
  NameValueKey: null,
  EmailValueKey: null,
  PageValueKey: null,
  PageSizeValueKey: null,
};

mixin $ProfilesView {
  TextEditingController get nameController =>
      _getFormTextEditingController(NameValueKey);
  TextEditingController get emailController =>
      _getFormTextEditingController(EmailValueKey);
  TextEditingController get pageController =>
      _getFormTextEditingController(PageValueKey);
  TextEditingController get pageSizeController =>
      _getFormTextEditingController(PageSizeValueKey);

  FocusNode get nameFocusNode => _getFormFocusNode(NameValueKey);
  FocusNode get emailFocusNode => _getFormFocusNode(EmailValueKey);
  FocusNode get pageFocusNode => _getFormFocusNode(PageValueKey);
  FocusNode get pageSizeFocusNode => _getFormFocusNode(PageSizeValueKey);

  TextEditingController _getFormTextEditingController(
    String key, {
    String? initialValue,
  }) {
    if (_ProfilesViewTextEditingControllers.containsKey(key)) {
      return _ProfilesViewTextEditingControllers[key]!;
    }

    _ProfilesViewTextEditingControllers[key] =
        TextEditingController(text: initialValue);
    return _ProfilesViewTextEditingControllers[key]!;
  }

  FocusNode _getFormFocusNode(String key) {
    if (_ProfilesViewFocusNodes.containsKey(key)) {
      return _ProfilesViewFocusNodes[key]!;
    }
    _ProfilesViewFocusNodes[key] = FocusNode();
    return _ProfilesViewFocusNodes[key]!;
  }

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  void syncFormWithViewModel(FormStateHelper model) {
    nameController.addListener(() => _updateFormData(model));
    emailController.addListener(() => _updateFormData(model));
    pageController.addListener(() => _updateFormData(model));
    pageSizeController.addListener(() => _updateFormData(model));

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
    pageSizeController.addListener(() => _updateFormData(model));

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
          PageSizeValueKey: pageSizeController.text,
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

    for (var controller in _ProfilesViewTextEditingControllers.values) {
      controller.dispose();
    }
    for (var focusNode in _ProfilesViewFocusNodes.values) {
      focusNode.dispose();
    }

    _ProfilesViewTextEditingControllers.clear();
    _ProfilesViewFocusNodes.clear();
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
  String? get pageSizeValue => this.formValueMap[PageSizeValueKey] as String?;

  set nameValue(String? value) {
    this.setData(
      this.formValueMap..addAll({NameValueKey: value}),
    );

    if (_ProfilesViewTextEditingControllers.containsKey(NameValueKey)) {
      _ProfilesViewTextEditingControllers[NameValueKey]?.text = value ?? '';
    }
  }

  set emailValue(String? value) {
    this.setData(
      this.formValueMap..addAll({EmailValueKey: value}),
    );

    if (_ProfilesViewTextEditingControllers.containsKey(EmailValueKey)) {
      _ProfilesViewTextEditingControllers[EmailValueKey]?.text = value ?? '';
    }
  }

  set pageValue(String? value) {
    this.setData(
      this.formValueMap..addAll({PageValueKey: value}),
    );

    if (_ProfilesViewTextEditingControllers.containsKey(PageValueKey)) {
      _ProfilesViewTextEditingControllers[PageValueKey]?.text = value ?? '';
    }
  }

  set pageSizeValue(String? value) {
    this.setData(
      this.formValueMap..addAll({PageSizeValueKey: value}),
    );

    if (_ProfilesViewTextEditingControllers.containsKey(PageSizeValueKey)) {
      _ProfilesViewTextEditingControllers[PageSizeValueKey]?.text = value ?? '';
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
  bool get hasPageSize =>
      this.formValueMap.containsKey(PageSizeValueKey) &&
      (pageSizeValue?.isNotEmpty ?? false);

  bool get hasNameValidationMessage =>
      this.fieldsValidationMessages[NameValueKey]?.isNotEmpty ?? false;
  bool get hasEmailValidationMessage =>
      this.fieldsValidationMessages[EmailValueKey]?.isNotEmpty ?? false;
  bool get hasSortByValidationMessage =>
      this.fieldsValidationMessages[SortByValueKey]?.isNotEmpty ?? false;
  bool get hasPageValidationMessage =>
      this.fieldsValidationMessages[PageValueKey]?.isNotEmpty ?? false;
  bool get hasPageSizeValidationMessage =>
      this.fieldsValidationMessages[PageSizeValueKey]?.isNotEmpty ?? false;

  String? get nameValidationMessage =>
      this.fieldsValidationMessages[NameValueKey];
  String? get emailValidationMessage =>
      this.fieldsValidationMessages[EmailValueKey];
  String? get sortByValidationMessage =>
      this.fieldsValidationMessages[SortByValueKey];
  String? get pageValidationMessage =>
      this.fieldsValidationMessages[PageValueKey];
  String? get pageSizeValidationMessage =>
      this.fieldsValidationMessages[PageSizeValueKey];
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
  setPageSizeValidationMessage(String? validationMessage) =>
      this.fieldsValidationMessages[PageSizeValueKey] = validationMessage;

  /// Clears text input fields on the Form
  void clearForm() {
    nameValue = '';
    emailValue = '';
    pageValue = '';
    pageSizeValue = '';
  }

  /// Validates text input fields on the Form
  void validateForm() {
    this.setValidationMessages({
      NameValueKey: getValidationMessage(NameValueKey),
      EmailValueKey: getValidationMessage(EmailValueKey),
      PageValueKey: getValidationMessage(PageValueKey),
      PageSizeValueKey: getValidationMessage(PageSizeValueKey),
    });
  }
}

/// Returns the validation message for the given key
String? getValidationMessage(String key) {
  final validatorForKey = _ProfilesViewTextValidations[key];
  if (validatorForKey == null) return null;

  String? validationMessageForKey = validatorForKey(
    _ProfilesViewTextEditingControllers[key]!.text,
  );

  return validationMessageForKey;
}

/// Updates the fieldsValidationMessages on the FormViewModel
void updateValidationData(FormStateHelper model) =>
    model.setValidationMessages({
      NameValueKey: getValidationMessage(NameValueKey),
      EmailValueKey: getValidationMessage(EmailValueKey),
      PageValueKey: getValidationMessage(PageValueKey),
      PageSizeValueKey: getValidationMessage(PageSizeValueKey),
    });
