import 'dart:convert';
import 'package:barscan/Utils/API/API.dart';
import 'package:http/http.dart' as http;

Future<List<dynamic>> fetchCategories() async {
  final response = await http.get(Uri.parse(getCategoryByStatus + '/Active'));
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load categories');
  }
}

Future<List<dynamic>> fetchProducts({String? categoryId, String? query}) async {
  final uri = Uri.parse(getProductSearch).replace(queryParameters: {
    if (categoryId != null && categoryId != 'All') 'category_id': categoryId,
    if (query != null && query.isNotEmpty) 'query': query,
  });

  final response = await http.get(uri);
  if (response.statusCode == 200) {
    return jsonDecode(response.body)['products'];
  } else {
    throw Exception('Failed to load products');
  }
}