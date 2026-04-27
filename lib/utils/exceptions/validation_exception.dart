/// Custom exception for handling validation errors from the API.
class ValidationException implements Exception {
  /// A map containing the validation errors, where the key is the field name
  /// and the value is a list of error messages for that field.
  final Map<String, dynamic> errors;

  ValidationException(this.errors);
}
