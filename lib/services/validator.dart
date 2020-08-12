class Validator {
  static String description(String value) {
    if (value != null) {
      if (value.trim().isEmpty) return 'Ops, a descrição não foi preenchido';
      if (value.trim().length < 1) return 'Mínimo de 1 caracteres';
    }
    return null;
  }

  static String data(String value) {
    if (value != null) {
      if (value.trim().isEmpty) return 'Ops, data não foi preenchida';
    }
    return null;
  }

  static String studentAmount(String value) {
    if (value != null) {
      if (value.trim().isEmpty)
        return 'A quantidade de aluno não foi preenchida';
    }
    return null;
  }
  static String email(String value) {
    if (value != null) {
      if (value.trim().isEmpty) return 'Ops, o e-mail não foi preenchido';
      if (!RegExp(
          r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
          .hasMatch(value)) {
        return "Ops, email inválido";
      }
    }
    return null;
  }
}
