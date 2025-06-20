import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

// Supabase keys
const String supabaseUrl = 'https://ldncamguwbrpoouphewl.supabase.co';
const String supabaseAnonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxkbmNhbWd1d2JycG9vdXBoZXdsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTA0MjI0MzksImV4cCI6MjA2NTk5ODQzOX0.tLQJugzPRJJhduarE2pbHS_ov1bnmklsWoyaiNS3Wk8';

// clolors that we use in our app
const titleColor = Color(0xFF010F07);
const primaryColor = Color(0xFFffc8dd);
const accentColor = Color(0xFFcddafd);
const bodyTextColor = Color(0xFF868686);
const inputColor = Color(0xFFFBFBFB);

const double defaultPadding = 16;
const Duration kDefaultDuration = Duration(milliseconds: 250);

const TextStyle kButtonTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 14,
  fontWeight: FontWeight.bold,
);

const EdgeInsets kTextFieldPadding = EdgeInsets.symmetric(
  horizontal: defaultPadding,
  vertical: defaultPadding,
);

// Text Field Decoration
const OutlineInputBorder kDefaultOutlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(6)),
  borderSide: BorderSide(
    color: Color(0xFFF3F2F2),
  ),
);

const InputDecoration otpInputDecoration = InputDecoration(
  contentPadding: EdgeInsets.zero,
  counterText: "",
  errorStyle: TextStyle(height: 0),
);

const kErrorBorderSide = BorderSide(color: Colors.red, width: 1);

// Validator
final passwordValidator = MultiValidator([
  RequiredValidator(errorText: 'Пароль обязателен'),
  MinLengthValidator(8, errorText: 'Пароль должен быть не менее 8 символов'),
  PatternValidator(r'(?=.*?[#?!@$%^&*-/])',
      errorText: 'Пароль должен содержать специальный символ')
]);

final emailValidator = MultiValidator([
  RequiredValidator(errorText: 'Email обязателен'),
  EmailValidator(errorText: 'Введите корректный адрес email')
]);

final requiredValidator =
    RequiredValidator(errorText: 'Поле обязательно для заполнения');
final matchValidator = MatchValidator(errorText: 'Пароли не совпадают');

final phoneNumberValidator = MinLengthValidator(10,
    errorText: 'Номер телефона должен содержать минимум 10 цифр');

// Common Text
final Center kOrText = Center(
    child: Text('Или', style: TextStyle(color: titleColor.withOpacity(0.7))));
