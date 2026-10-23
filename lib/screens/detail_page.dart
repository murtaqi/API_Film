import 'package:flutter/material.dart';

import '../main.dart';
import '../models/movie.dart';
import '../widgets/movie_image.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key, required this.movie});
  final Movie movie;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Detail film')),
    body: SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: MovieImage(url: movie.banner),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'STUDIO GHIBLI  /  KOLEKSI FILM',
                      style: TextStyle(
                        color: ink,
                        letterSpacing: 2,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      movie.title,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: ink,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      movie.originalTitle,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        Chip(label: Text('${movie.year}')),
                        Chip(
                          label: Text('${movie.minutes} menit'),
                          avatar: const Icon(Icons.schedule, size: 18),
                        ),
                        Chip(
                          label: Text('${movie.score}% Rotten Tomatoes'),
                          avatar: const Icon(Icons.star_rounded, size: 18),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Di balik cerita',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 21,
                        color: ink,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _credit('Sutradara', movie.director),
                    _credit('Produser', movie.producer),
                    const Divider(height: 40),
                    const Text(
                      'Sinopsis',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w700,
                        color: ink,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      movie.description.isEmpty
                          ? 'Sinopsis belum tersedia.'
                          : movie.description,
                      style: const TextStyle(fontSize: 16, height: 1.7),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Sinopsis mengikuti bahasa asli dari API (Inggris).\nSumber data: Studio Ghibli API. Skor berasal dari Rotten Tomatoes.',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
  Widget _credit(String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.black54, fontSize: 12),
        ),
        Text(value.isEmpty ? '-' : value, style: const TextStyle(fontSize: 16)),
      ],
    ),
  );
}
