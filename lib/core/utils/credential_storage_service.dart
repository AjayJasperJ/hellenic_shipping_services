// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:hellenic_shipping_services/core/utils/logger_service.dart';
// import 'package:hellenic_shipping_services/models/auth_model.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class CredentialStorageService {
//   CredentialStorageService._internal({FlutterSecureStorage? secureStorage})
//     : _secureStorage = secureStorage ?? const FlutterSecureStorage();

//   static final CredentialStorageService instance =
//       CredentialStorageService._internal();

//   final FlutterSecureStorage _secureStorage;
//   Future<void>? _initialization;

//   static const AndroidOptions _androidOptions = AndroidOptions(
//     encryptedSharedPreferences: true,
//     resetOnError: true,
//   );

//   static const IOSOptions _iosOptions = IOSOptions(
//     accountName: 'nercha.credentials',
//   );

//   static const String _credentialKey = 'user_credentials';
//   static const String _installMarkerKey =
//       'credential_storage.installation_marker';

//   Future<void> initialize() {
//     _initialization ??= _bootstrap();
//     return _initialization!;
//   }

//   Future<void> _bootstrap() async {
//     if (kIsWeb || !Platform.isIOS) return;
//     final prefs = await SharedPreferences.getInstance();
//     final hasMarker = prefs.getBool(_installMarkerKey) ?? false;
//     if (!hasMarker) {
//       await _secureStorage.deleteAll(iOptions: _iosOptions);
//       await prefs.setBool(_installMarkerKey, true);
//     }
//   }

//   Future<void> save(LoginResponse credentials) async {
//     await initialize();
//     try {
//       await _secureStorage.write(
//         key: _credentialKey,
//         value: jsonEncode(credentials.toJson()),
//         aOptions: _androidOptions,
//         iOptions: _iosOptions,
//       );
//     } catch (error, stackTrace) {
//       await LoggerService.logger(
//         'Credential storage save failed: $error\n$stackTrace',
//       );
//       rethrow;
//     }
//   }

//   Future<LoginResponse?> read() async {
//     await initialize();
//     try {
//       final stored = await _secureStorage.read(
//         key: _credentialKey,
//         aOptions: _androidOptions,
//         iOptions: _iosOptions,
//       );
//       if (stored == null) return null;
//       return LoginResponse.fromEncodedJson(stored);
//     } on FormatException catch (error, stackTrace) {
//       await LoggerService.logger(
//         'Credential storage corrupted: $error\n$stackTrace',
//       );
//       await clear();
//       return null;
//     } catch (error, stackTrace) {
//       await LoggerService.logger(
//         'Credential storage read failed: $error\n$stackTrace',
//       );
//       rethrow;
//     }
//   }

//   Future<bool> hasCredentials() async {
//     await initialize();
//     return _secureStorage.containsKey(
//       key: _credentialKey,
//       aOptions: _androidOptions,
//       iOptions: _iosOptions,
//     );
//   }

//   Future<void> clear() async {
//     await initialize();
//     try {
//       await _secureStorage.delete(
//         key: _credentialKey,
//         aOptions: _androidOptions,
//         iOptions: _iosOptions,
//       );
//       await _secureStorage.deleteAll(
//         aOptions: _androidOptions,
//         iOptions: _iosOptions,
//       );
//     } catch (error, stackTrace) {
//       await LoggerService.logger(
//         'Credential storage clear failed: $error\n$stackTrace',
//       );
//       rethrow;
//     }
//   }
// }
