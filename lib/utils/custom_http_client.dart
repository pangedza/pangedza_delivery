import 'package:http/http.dart' as http;

/// A [http.BaseClient] that removes headers containing non-ASCII characters.
class CustomHttpClient extends http.BaseClient {
  final http.Client _inner;

  /// Creates a [CustomHttpClient] that proxies requests to [inner].
  /// If [inner] is omitted, a default [http.Client] instance is used.
  CustomHttpClient([http.Client? inner]) : _inner = inner ?? http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.removeWhere((key, value) => !_isAscii(value));
    return _inner.send(request);
  }

  bool _isAscii(String value) => value.codeUnits.every((unit) => unit >= 32 && unit <= 126);
}
