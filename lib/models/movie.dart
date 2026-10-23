class Movie {
  const Movie({
    required this.id,
    required this.title,
    required this.originalTitle,
    required this.description,
    required this.director,
    required this.producer,
    required this.year,
    required this.minutes,
    required this.score,
    required this.image,
    required this.banner,
  });
  final String id,
      title,
      originalTitle,
      description,
      director,
      producer,
      image,
      banner;
  final int year, minutes, score;

  factory Movie.fromJson(Map<String, dynamic> json) {
    String value(String key) => json[key]?.toString().trim() ?? '';
    if (value('id').isEmpty || value('title').isEmpty) {
      throw const FormatException('Film tidak memiliki ID atau judul.');
    }
    return Movie(
      id: value('id'),
      title: value('title'),
      originalTitle: value('original_title'),
      description: value('description'),
      director: value('director'),
      producer: value('producer'),
      year: int.tryParse(value('release_date')) ?? 0,
      minutes: int.tryParse(value('running_time')) ?? 0,
      score: int.tryParse(value('rt_score')) ?? 0,
      image: value('image'),
      banner: value('movie_banner'),
    );
  }
}
