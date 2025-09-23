import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/user.dart';

class PessoaRepository {
  Future<List<UserModel>> getPessoas() async {
    final response = await http.get(
      Uri.parse("https://dummyjson.com/users?limit=20"), //
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List users = data['users'];
      return users.map((e) => UserModel.fromJson(e)).toList();
    } else {
      throw Exception('Erro ao carregar usuários');
    }
  }
}
