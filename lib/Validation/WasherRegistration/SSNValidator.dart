

// CURRENTLY NOT BEING USED

class SSNValidatorMixin{

  String? validateSSN(String? value) {
    if (value == null || value.length <8) {
      return "Enter a valid Social Security Number";
    }
    return null;
  }
}