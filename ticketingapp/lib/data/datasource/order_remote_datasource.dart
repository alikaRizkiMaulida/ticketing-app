import 'package:ticketingapp/core/constants/variable.dart';
import 'package:ticketingapp/data/datasource/auth_local_datasource.dart';
import 'package:ticketingapp/data/model/request/order_request_model.dart';
import 'package:http/http.dart' as http;
class OrderRemoteDatasource {
  Future<bool> sendOrder(OrderRequestModel orderRequest) async {
  try {
    print('Sending request to: ${Variable.baseUrl}/api/api-orders');
    final authData = await AuthLocalDatasource().getAuthData();
    final response = await http.post(
      Uri.parse('${Variable.baseUrl}/api/api-orders'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${authData.token}',
      },
      body: orderRequest.toJson(),
    );

    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      print('Error response: ${response.body}');
      return false;
    }
  } catch (e, stackTrace) {
    print('Network error: $e');
    print('Stack trace: $stackTrace');
    return false;
  }
}
}