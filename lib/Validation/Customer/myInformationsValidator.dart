

class MyInformationsValidationMixin{

  String? validateFullName(String value) {
    if (value.length < 2) {
      return "Please enter a name with at least 2 digits";
    }
    return null;
  }

  String? validateSurname(String value){
    if(value.length < 2){
      return "Please enter a surname with at least 2 digits";
    }
    return null;
  }

  String? validatePhoneNumber(String value) {
    if (value.length < 10) {
      return "Please enter a valid phone number with 10 digits";
    }
    return null;
  }

  String? validateEmail(String value) {
    if (!value.contains("@") || !value.contains("mail")) {
      return "Please enter a real e-mail address.";
    }
    return null;
  }
}