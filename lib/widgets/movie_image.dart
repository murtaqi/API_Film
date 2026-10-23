import 'package:flutter/material.dart';

class MovieImage extends StatelessWidget {
  const MovieImage({super.key, required this.url});
  final String url;
  @override
  Widget build(BuildContext context) => Image.network(
    url,
    width: double.infinity,
    height: double.infinity,
    fit: BoxFit.cover,
    loadingBuilder: (context, child, progress) =>
        progress == null ? child : _placeholder(),
    errorBuilder: (context, error, stackTrace) => _placeholder(),
    excludeFromSemantics: true,
  );
  Widget _placeholder() => const ColoredBox(
    color: Color(0xFFDDE6DB),
    child: Center(
      child: Icon(Icons.movie_outlined, size: 40, color: Color(0xFF527264)),
    ),
  );
}
