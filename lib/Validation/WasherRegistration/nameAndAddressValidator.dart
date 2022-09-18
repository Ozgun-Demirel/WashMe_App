


class NameAndAddressValidatorMixin{

  String? nameValidator(String? value) {
    if (value == null || value.length <2) {
      return "Value mush be bigger than 1 character.";
    }
    return null;
  }

  String? stateValidator(String? value){
    if (value == null || value.length != 2){
      return "State Must be 2 characters.";
    }
    return null;
  }

  String? zipValidator(String? value){
    if (value == null || value.length != 5){
      return "Zip mush be 5 characters.";
    }
    return null;
  }

}