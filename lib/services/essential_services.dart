import 'package:hellenic_shipping_services/core/constants/uri_manager.dart';
import 'package:hellenic_shipping_services/core/utils/api_services.dart';
import 'package:http/http.dart' as http;

class EssentialServices {
  static ApiService service = ApiService();

  static Future<http.Response> getleaveBalance() async {
    final response = await service.get(UriManager.leavebalance, withAuth: true);
    return response;
  }

  static Future<http.Response> gettaskHistory() async {
    final response = await service.get(UriManager.taskhistory, withAuth: true);
    return response;
  }

  static Future<http.Response> deletetaskHistory(String id) async {
    final response = await service.delete(
      "${UriManager.workentries}$id/",
      withAuth: true,
    );
    return response;
  }

  static Future<http.Response> edittaskHistory(
    String id, {
    required String description,
    required String startTime,
    required String endTime,
  }) async {
    final response = await service.put(
      "${UriManager.workentries}$id/",
      withAuth: true,
      body: {
        'description': description,
        'start_time': startTime,
        'end_time': endTime,
      },
    );
    return response;
  }
}
