import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/produto.dart';
import '../utils/constants.dart';

class ProductRepository {
  final url = '$baseURLApi/products';

  Future<List<Produto>> getProducts() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List products = data['products'];
      return products.map((e) => Produto.fromJson(e)).toList();
    } else {
      throw Exception('Erro ao carregar produtos');
    }
  }
}
