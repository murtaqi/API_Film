import 'package:flutter/material.dart';

import '../main.dart';
import '../models/movie.dart';
import '../services/movie_service.dart';
import '../widgets/movie_image.dart';
import 'detail_page.dart';

enum MovieSort { score, newest, title }

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key, this.service});
  final MovieService? service;
  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  late final MovieService _service;
  late Future<List<Movie>> _movies;
  final _search = TextEditingController();
  String? _director;
  MovieSort _sort = MovieSort.score;

  @override
  void initState() {
    super.initState();
    _service = widget.service ?? MovieService();
    _movies = _service.fetchMovies();
  }

  @override
  void dispose() {
    _search.dispose();
    if (widget.service == null) _service.close();
    super.dispose();
  }

  Future<void> _reload() async {
    final next = _service.fetchMovies();
    setState(() {
      _movies = next;
    });
    try {
      await next;
    } catch (_) {
      /* FutureBuilder menampilkan kegagalan. */
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Row(
        children: [
          Icon(Icons.filter_vintage_outlined),
          SizedBox(width: 10),
          Flexible(
            child: Text(
              'layar ghibli',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: -1),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: _reload,
          tooltip: 'Muat ulang film',
          icon: const Icon(Icons.refresh),
        ),
        const SizedBox(width: 8),
      ],
    ),
    body: FutureBuilder<List<Movie>>(
      future: _movies,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 20),
                Text('Menyiapkan dunia penuh imajinasi...'),
              ],
            ),
          );
        }
        if (snapshot.hasError) {
          return _message(
            Icons.cloud_off_outlined,
            'Film belum bisa dimuat',
            '${snapshot.error}',
            action: 'Coba lagi',
            onAction: _reload,
          );
        }
        final movies = snapshot.data ?? [];
        if (movies.isEmpty) {
          return _message(
            Icons.movie_outlined,
            'Koleksi masih kosong',
            'API belum mengirimkan data film.',
            action: 'Muat ulang',
            onAction: _reload,
          );
        }
        return _catalog(movies);
      },
    ),
  );

  Widget _catalog(List<Movie> movies) {
    final directors =
        movies
            .map((m) => m.director)
            .where((d) => d.isNotEmpty)
            .toSet()
            .toList()
          ..sort();
    final selectedDirector = directors.contains(_director) ? _director : null;
    final query = _search.text.trim().toLowerCase();
    final filtered = movies
        .where(
          (m) =>
              (selectedDirector == null || m.director == selectedDirector) &&
              ('${m.title} ${m.originalTitle} ${m.director}'
                  .toLowerCase()
                  .contains(query)),
        )
        .toList();
    filtered.sort((a, b) {
      final comparison = switch (_sort) {
        MovieSort.score => b.score.compareTo(a.score),
        MovieSort.newest => b.year.compareTo(a.year),
        MovieSort.title => a.title.compareTo(b.title),
      };
      return comparison == 0 ? a.title.compareTo(b.title) : comparison;
    });
    return RefreshIndicator(
      onRefresh: _reload,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth.clamp(0.0, 1100.0);
          final columns = width >= 900
              ? 4
              : width >= 600
              ? 3
              : 2;
          return CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1100),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: ink,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'SEBUAH PERJALANAN SINEMA',
                                  style: TextStyle(
                                    fontSize: 10,
                                    letterSpacing: 2.3,
                                    color: Color(0xFFCDDBA2),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 14),
                                const Text(
                                  'Cerita kecil.\nImajinasi tanpa batas.',
                                  style: TextStyle(
                                    fontSize: 32,
                                    height: 1.15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  'Temukan keajaiban di setiap film Studio Ghibli.',
                                  style: TextStyle(
                                    color: Color(0xFFD5E0D7),
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  '${movies.length} FILM  /  ${directors.length} SUTRADARA',
                                  style: const TextStyle(
                                    color: Color(0xFFCDDBA2),
                                    letterSpacing: 1.5,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          TextField(
                            controller: _search,
                            onChanged: (_) => setState(() {}),
                            decoration: InputDecoration(
                              hintText: 'Cari judul atau sutradara...',
                              prefixIcon: const Icon(Icons.search),
                              suffixIcon: query.isEmpty
                                  ? null
                                  : IconButton(
                                      tooltip: 'Hapus pencarian',
                                      onPressed: () => setState(_search.clear),
                                      icon: const Icon(Icons.close),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          DropdownButtonFormField<String>(
                            key: ValueKey(selectedDirector),
                            initialValue: selectedDirector,
                            isExpanded: true,
                            decoration: const InputDecoration(
                              labelText: 'Sutradara',
                              prefixIcon: Icon(Icons.tune),
                            ),
                            items: [
                              const DropdownMenuItem<String>(
                                value: null,
                                child: Text('Semua sutradara'),
                              ),
                              ...directors.map(
                                (d) =>
                                    DropdownMenuItem(value: d, child: Text(d)),
                              ),
                            ],
                            onChanged: (value) =>
                                setState(() => _director = value),
                          ),
                          const SizedBox(height: 22),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Koleksi film · ${filtered.length}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    color: ink,
                                  ),
                                ),
                              ),
                              PopupMenuButton<MovieSort>(
                                tooltip: 'Urutkan film',
                                initialValue: _sort,
                                onSelected: (value) =>
                                    setState(() => _sort = value),
                                itemBuilder: (context) => const [
                                  PopupMenuItem(
                                    value: MovieSort.score,
                                    child: Text('Skor tertinggi'),
                                  ),
                                  PopupMenuItem(
                                    value: MovieSort.newest,
                                    child: Text('Tahun terbaru'),
                                  ),
                                  PopupMenuItem(
                                    value: MovieSort.title,
                                    child: Text('Judul A–Z'),
                                  ),
                                ],
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  child: Row(
                                    children: [
                                      Text(switch (_sort) {
                                        MovieSort.score => 'Skor',
                                        MovieSort.newest => 'Terbaru',
                                        MovieSort.title => 'A–Z',
                                      }, style: const TextStyle(color: ink)),
                                      const Icon(
                                        Icons.keyboard_arrow_down,
                                        color: ink,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (filtered.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        const Icon(Icons.search_off, size: 40, color: ink),
                        const SizedBox(height: 12),
                        const Text('Film tidak ditemukan'),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () => setState(() {
                            _search.clear();
                            _director = null;
                          }),
                          child: const Text('Reset pencarian & filter'),
                        ),
                      ],
                    ),
                  ),
                ),
              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  ((constraints.maxWidth - width) / 2) + 20,
                  0,
                  ((constraints.maxWidth - width) / 2) + 20,
                  24,
                ),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    mainAxisExtent:
                        ((width - 40 - (columns - 1) * 16) / columns) * 1.4 +
                        112 * MediaQuery.textScalerOf(context).scale(1),
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _card(filtered[index]),
                    childCount: filtered.length,
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 28),
                  child: Text(
                    'Data: Studio Ghibli API · Skor: Rotten Tomatoes\nKatalog mengikuti koleksi yang tersedia dari penyedia API.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 11,
                      height: 1.6,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _card(Movie movie) => Card(
    margin: EdgeInsets.zero,
    elevation: 0,
    color: Colors.white,
    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute<void>(builder: (_) => DetailPage(movie: movie)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                MovieImage(url: movie.image),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: ink,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '★ ${movie.score}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    height: 1.25,
                    color: ink,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${movie.year}  ·  ${movie.minutes} menit',
                  style: const TextStyle(fontSize: 11, color: Colors.black54),
                ),
                const SizedBox(height: 4),
                Text(
                  movie.director,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  Widget _message(
    IconData icon,
    String title,
    String message, {
    required String action,
    required VoidCallback onAction,
  }) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 64, color: ink),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: onAction,
            icon: const Icon(Icons.refresh),
            label: Text(action),
          ),
        ],
      ),
    ),
  );
}
