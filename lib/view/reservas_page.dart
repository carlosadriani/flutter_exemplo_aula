import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ReservasPage extends StatefulWidget {
  const ReservasPage({super.key});

  @override
  State<ReservasPage> createState() => _ReservasPageState();
}

class _ReservasPageState extends State<ReservasPage> {
  String _result = "";
  String? _token;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  /// Carrega token salvo em SharedPreferences
  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _token = prefs.getString("auth_token");
    });
  }

  /// Cria uma reserva (não precisa de token)
  Future<void> createBooking() async {
    const url = "https://restful-booker.herokuapp.com/booking";

    final body = jsonEncode({
      "firstname": "Jim",
      "lastname": "Brown",
      "totalprice": 111,
      "depositpaid": true,
      "bookingdates": {"checkin": "2025-09-08", "checkout": "2025-09-10"},
      "additionalneeds": "Breakfast",
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          _result = "Reserva criada com sucesso: ${response.body}";
        });
      } else {
        setState(() {
          _result = "Erro ao criar reserva: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        _result = "Erro na requisição: $e";
      });
    }
  }

  /// Atualiza reserva usando token (PUT /booking/{id})
  Future<void> updateBooking(int bookingId) async {
    if (_token == null) {
      setState(() {
        _result = "Erro: Token não encontrado. Faça login primeiro.";
      });
      return;
    }

    final url = "https://restful-booker.herokuapp.com/booking/$bookingId";

    final body = jsonEncode({
      "firstname": "UpdatedJim",
      "lastname": "UpdatedBrown",
      "totalprice": 200,
      "depositpaid": false,
      "bookingdates": {"checkin": "2025-09-15", "checkout": "2025-09-20"},
      "additionalneeds": "Dinner",
    });

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Cookie": "token=$_token",
        },
        body: body,
      );

      if (response.statusCode == 200) {
        setState(() {
          _result = "Reserva atualizada com sucesso: ${response.body}";
        });
      } else {
        setState(() {
          _result = "Erro ao atualizar reserva: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        _result = "Erro na requisição: $e";
      });
    }
  }

  /// Lista todas as reservas
  Future<void> listBookings() async {
    const url = "https://restful-booker.herokuapp.com/booking";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          _result = "Lista de reservas:\n${response.body}";
        });
      } else {
        setState(() {
          _result = "Erro ao listar reservas: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        _result = "Erro na requisição: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reservas - Restful Booker")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: createBooking,
              child: const Text("Criar Reserva"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => updateBooking(1), // exemplo com id = 1
              child: const Text("Atualizar Reserva #1"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: listBookings,
              child: const Text("Listar Reservas"),
            ),
            const SizedBox(height: 20),
            Text(_result),
          ],
        ),
      ),
    );
  }
}
