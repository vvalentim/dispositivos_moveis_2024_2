mixin ValidatorTestEntryDataMixin {
  String? isNotEmpty(String? value, [String? message]) {
    if (value!.isEmpty) {
      return message ?? 'This field is required.';
    }

    return null;
  }

  String? isValidDbmValue(String? value) {
    var amount = double.tryParse(value!) ?? -1;

    if (amount < 0 || amount > 100) {
      return 'Invalid value, must be a number between 0 to 100.';
    }

    return null;
  }

  String? isValidMbpsValue(String? value) {
    var amount = double.tryParse(value!) ?? 0;

    if (amount < 1 || amount > 10000) {
      return 'Invalid value, must be a number between 1 to 10000.';
    }

    return null;
  }

  String? combine(List<String? Function()> validators) {
    for (final cb in validators) {
      final validate = cb();

      if (validate != null) {
        return validate;
      }
    }

    return null;
  }
}
