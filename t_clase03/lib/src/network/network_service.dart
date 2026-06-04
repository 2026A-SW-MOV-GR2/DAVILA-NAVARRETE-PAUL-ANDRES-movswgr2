import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models.dart';

class NetworkService {
  NetworkService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';

  Future<PostModel> fetchPost(int id) async {
    final response = await _client.get(Uri.parse('$_baseUrl/posts/$id'));

    if (response.statusCode != 200) {
      throw Exception('No fue posible obtener el post.');
    }

    return PostModel.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<PostModel> updatePost(PostModel post) async {
    final response = await _client.put(
      Uri.parse('$_baseUrl/posts/${post.id}'),
      headers: const {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(post.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('No fue posible actualizar el post.');
    }

    return PostModel.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }
}
