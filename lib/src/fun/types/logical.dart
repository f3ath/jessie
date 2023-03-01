/// The logical type which is used in logical expressions
/// and existence test expressions.
class Logical {
  const Logical(this.asBool);

  /// The bool representation of this value.
  final bool asBool;

  Logical and(Logical other) => Logical(asBool && other.asBool);

  Logical or(Logical other) => Logical(asBool || other.asBool);

  Logical not() => Logical(!asBool);
}
