import 'dart:convert';

import 'package:flutter/foundation.dart';

const int _kDefaultIsolateThreshold = 32 * 1024; // ~32 KB

/// Decodes a JSON string, offloading to a background isolate only when the
/// payload is large enough to benefit from parallelism.
///
/// For smaller payloads, decoding happens synchronously on the calling isolate
/// to avoid the overhead of spawning and communicating with an isolate.
/// The returned value mirrors `jsonDecode`, so it can be a `Map`, `List`, or
/// primitive type depending on the input payload.
Future<dynamic> decodeJsonInIsolate(
  String source, {
  int minPayloadLength = _kDefaultIsolateThreshold,
}) async {
  if (source.length < minPayloadLength) {
    return jsonDecode(source);
  }
  return compute<String, dynamic>(_decodeJson, source);
}

dynamic _decodeJson(String source) => jsonDecode(source);
