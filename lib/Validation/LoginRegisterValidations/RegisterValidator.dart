
List exclamationPoints = [
  "!",
  ",",
  ".",
];

class RegisterValidationMixin {
  String? validateName(String value) {
    if (value.length < 2) {
      return "Please enter a valid name";
    }
    return null;
  }

  String? validateLastName(String value) {
    if (value.length < 2) {
      return "Please enter a valid last name";
    }
    return null;
  }

  String? validateEmail(String value) {
    if (value.isEmpty || !value.contains("@")) {
      return "Please enter a valid email.";
    }
    return null;
  }

  String? validatePassword(String value) {
    if (value.length < 8) {
      return "Please enter a valid password.";
    }
    return null;
  }

  String? validateRePassword({String? password, String? rePassword}) {
    if (password == rePassword) {
      return null;
    }
    return "Passwords do not match.";
  }
}
