import 'package:flutter/material.dart';

import 'screens/catalog_page.dart';
import 'services/movie_service.dart';

void main() => runApp(const MyApp());
const ink = Color(0xFF153D35);
const paper = Color(0xFFF7F6F0);

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.service});
  final MovieService? service;
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Layar Ghibli',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: paper,
      colorScheme: ColorScheme.fromSeed(seedColor: ink, surface: paper),
      appBarTheme: const AppBarTheme(
        backgroundColor: paper,
        foregroundColor: ink,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    ),
    home: CatalogPage(service: service),
  );
}
