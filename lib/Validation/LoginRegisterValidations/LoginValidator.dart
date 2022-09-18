


class UserValidationMixin{

  String? validateEmail(String value) {
    if (value.isEmpty || !value.contains("@")) {
      return "Please enter a valid email address";
    }
    return null;
  }

  String? validatePassword(String value){
    if(value.length < 8){
      return "Please enter a valid password which at least 8 characters";
    }
  }
}