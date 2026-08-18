class NumberController {
  int value = -1;

  void set({String? value}) {
    int? val = int.tryParse(value.toString());
    this.value = val ?? -1;
  }

  String? getValue() {
    if (value == -1) {
      return null;
    } else {
      return value.toString().trim();
    }
  }

  void clear() {
    value = -1;
  }
}
