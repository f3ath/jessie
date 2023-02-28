/// Logical type.
class Logical {
  const Logical(this.asBool);

  final bool asBool;

  Logical and(Logical other) => Logical(asBool && other.asBool);

  Logical or(Logical other) => Logical(asBool || other.asBool);

  Logical not() => Logical(!asBool);
}
