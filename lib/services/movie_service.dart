import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/movie.dart';

class MovieApiException implements Exception {
  const MovieApiException(this.message);
  final String message;
  @override
  String toString() => message;
}

class MovieService {
  MovieService({http.Client? client}) : _client = client ?? http.Client();
  final http.Client _client;
  static final endpoint = Uri.https('ghibliapi.vercel.app', '/films');

  Future<List<Movie>> fetchMovies() async {
    try {
      final response = await _client
          .get(endpoint)
          .timeout(const Duration(seconds: 20));
      if (response.statusCode != 200) {
        throw MovieApiException(
          'Server mengembalikan status ${response.statusCode}. Coba lagi nanti.',
        );
      }
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      if (data is! List) {
        throw const FormatException('Respons bukan daftar film.');
      }
      return data.map((item) {
        if (item is! Map<String, dynamic>) {
          throw const FormatException('Data film tidak valid.');
        }
        return Movie.fromJson(item);
      }).toList();
    } on TimeoutException {
      throw const MovieApiException(
        'Waktu tunggu habis. Periksa koneksi internet Anda.',
      );
    } on FormatException {
      throw const MovieApiException(
        'Data film tidak dapat diproses. Silakan coba lagi.',
      );
    } on http.ClientException {
      throw const MovieApiException(
        'Tidak dapat terhubung. Periksa koneksi internet Anda.',
      );
    }
  }

  void close() => _client.close();
}
