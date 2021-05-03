class Token {
  final String value;

  Token(this.value);

  bool operator ==(other) {
    return other is Token && other.value == this.value;
  }

  @override
  int get hashCode {
    return this.value.hashCode;
  }
}
