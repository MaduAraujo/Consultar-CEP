import 'package:flutter_cep/models/cep_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; 

class CepRepository {
  static const baseUrl = 'https://viacep.com.br/ws';
  final http.Client client;

  CepRepository({required this.client});

  Future<CepModel> consultarCep(String cep) async {
    final cleanCep = cep.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanCep.length != 8) {
      throw Exception('CEP inválido');
    }

    final url = Uri.parse('$baseUrl/$cleanCep/json');
    final response = await client.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData.containsKey('erro')) {
        throw Exception('CEP não encontrado');
      }
      return CepModel.fromJson(jsonData);
    } else {
      throw Exception('Erro na requisição');
    }
  }
}