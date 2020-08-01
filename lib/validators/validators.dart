import 'package:form_field_validator/form_field_validator.dart';
import 'package:validators/validators.dart';
import 'package:validators/sanitizers.dart';

class PriceValidator extends TextFieldValidator {
  // pass the error text to the super constructor
  PriceValidator({String errorText = 'Enter a valid price'}) : super(errorText);

  // return false if you want the validator to return error
  // message when the value is empty.
  @override
  bool get ignoreEmptyValues => true;

  @override
  bool isValid(String value) {
    // return true if the value is valid according the your condition\
    return toFloat(value) > 0;
  }
}

class UrlValidator extends TextFieldValidator {
  // pass the error text to the super constructor
  UrlValidator({String errorText = 'Enter a valid url'}) : super(errorText);

  // return false if you want the validator to return error
  // message when the value is empty.
  @override
  bool get ignoreEmptyValues => true;

  @override
  bool isValid(String value) {
    // return true if the value is valid according the your condition\
    return isURL(value);
  }
}
