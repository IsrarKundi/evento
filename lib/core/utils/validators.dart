import 'package:event_connect/core/extensions/validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ValidationService {
  //private constructor
  ValidationService._privateConstructor();

  //singleton instance variable
  static ValidationService? _instance;

  //This code ensures that the singleton instance is created only when it's accessed for the first time.
  //Subsequent calls to ValidationService.instance will return the same instance that was created before.

  //getter to access the singleton instance
  static ValidationService get instance {
    _instance ??= ValidationService._privateConstructor();
    return _instance!;
  }

  //empty validator
  String? emptyValidator(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.fieldRequired;
    }
    return null;
  }

  String? dateSelectValidator(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.pleaseSelectDate;
    }
    return null;
  }

  //email validator
  String? emailValidator(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.pleaseEnterEmail;
    } else if (value.isValidEmail() == false) {
      return AppLocalizations.of(context)!.invalidEmail;
    } else {
      return null;
    }
  }

  String? puffValidator({String? value, required int maximumPuff, required BuildContext context}) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.pleaseEnterPuffs;
    } else if (double.parse(value) > maximumPuff) {
      return AppLocalizations.of(context)!.maximumRequired;
    } else {
      return null;
    }
  }

  //username validator
  String? userNameValidator(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.pleaseEnterUsername;
    } else if (value.isValidUsername() == false) {
      return AppLocalizations.of(context)!.invalidUsername;
    } else {
      return null;
    }
  }

  //password validator
  String? validatePassword(String? password, BuildContext context) {
    if (password == null || password.isEmpty) {
      return AppLocalizations.of(context)!.passwordRequired;
    }

    if (password.length < 8) {
      return AppLocalizations.of(context)!.passwordMinLength;
    }

    // if (password.isUpperCase() == false) {
    //   return AppLocalizations.of(context)!.passwordUppercase;
    // }
    //
    // if (password.isLowerCase() == false) {
    //   return AppLocalizations.of(context)!.passwordLowercase;
    // }
    //
    // if (password.isContainDigit() == false) {
    //   return AppLocalizations.of(context)!.passwordDigit;
    // }
    //
    // if (password.isContainSpecialCharacter() == false) {
    //   return AppLocalizations.of(context)!.passwordSpecialChar;
    // }

    return null; // Return null if the password is valid
  }

  //password match function
  String? validateMatchPassword(String value, String password, BuildContext context) {
    if (value.isEmpty) {
      return AppLocalizations.of(context)!.pleaseEnterPasswordAgain;
    } else if (value != password) {
      return AppLocalizations.of(context)!.passwordsDoNotMatch;
    }
    return null;
  }
}
