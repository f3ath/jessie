T Function(R r) to<T, R>(T value) => (R r) => value;

bool isNotNull(dynamic value) => value != null;

T last<T>(List<T> values) => values.last;

T Function(List<T> values) lastWhere<T>(bool Function(T value) predicate) =>
    (List<T> values) => values.lastWhere(predicate);
