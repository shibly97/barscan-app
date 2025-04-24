import 'package:shared_preferences/shared_preferences.dart';

class CustomerSession {
  static Future<void> saveSession(String id, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('customerId', id);
    await prefs.setString('customerEmail', email);
  }

  static Future<String?> getCustomerId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('customerId');
  }

  static Future<String?> getCustomerEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('customerEmail');
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
