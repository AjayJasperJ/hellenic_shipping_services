import 'package:flutter/material.dart';
import 'package:hellenic_shipping_services/core/network/managers/offline_sync_manager.dart';
import 'package:hellenic_shipping_services/core/network/utils/connectivity_service.dart';
import 'package:hellenic_shipping_services/core/network/utils/logger_services.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('api_cache');
  await Hive.openBox('offline_queue');
  await LoggerService.init();
  LoggerService.initGlobalErrorHandling();
  await ConnectivityService().init();
  OfflineSyncManager().init();
  debugPrint("[Bootstrap] Initialization complete.");
}
