# Layar Ghibli

Aplikasi katalog film Studio Ghibli untuk UTS Pemrograman Mobile. Dibuat oleh **Muhammad Murtaqi Yahya (240605110115)**, Teknik Informatika, Fakultas Sains dan Teknologi, Universitas Islam Negeri Maulana Malik Ibrahim Malang.

## Deskripsi

Aplikasi Flutter mengambil data film secara dinamis melalui HTTP dari [Studio Ghibli API](https://ghibliapi.vercel.app/films). Tidak memerlukan API key. Koleksi mengikuti data penyedia API, bukan katalog seluruh film terkini. Antarmuka berbahasa Indonesia; judul dan sinopsis mengikuti bahasa sumber API.

## Fitur

- Katalog dengan poster, judul, tahun, durasi, sutradara, dan skor Rotten Tomatoes.
- Pencarian judul asli/judul Inggris atau sutradara, tanpa membedakan kapital.
- Filter sutradara berdasarkan data API.
- Urutan skor tertinggi, tahun terbaru, atau judul A-Z.
- Halaman detail: banner, judul asli, tahun, durasi, skor, produser, sutradara, sinopsis.
- `FutureBuilder` dengan loading, sukses, error, data kosong, dan hasil pencarian kosong.
- Tombol coba lagi, muat ulang, dan pull-to-refresh. Gambar gagal memiliki placeholder.
- Grid responsif dan dukungan ukuran teks sistem.

## Teknologi

Flutter 3.47.2, Dart 3.13.2, Material 3, `http ^1.6.0`, `flutter_test`, `flutter_lints`. Permintaan memiliki batas waktu 20 detik dan pemeriksaan status HTTP. JSON UTF-8 dikonversi menjadi `Movie`. Tidak ada data film statis pada aplikasi produksi.

## Menjalankan

1. Instal Flutter dan Android SDK, lalu jalankan `flutter doctor`.
2. Buka folder proyek ini dan jalankan:

```sh
flutter pub get
flutter devices
flutter run -d <ID_PERANGKAT_ANDROID>
```

Aktifkan emulator Android atau hubungkan ponsel dengan USB debugging. Gunakan koneksi internet untuk data dan poster. Izin INTERNET sudah terpasang di manifest utama sehingga berlaku pada build Android.

```sh
flutter analyze
flutter test
flutter build apk --debug
```

APK hasil build: `build/app/outputs/flutter-apk/app-debug.apk`. APK ini untuk demonstrasi/pengujian, ditandatangani dengan debug key. Untuk APK rilis: konfigurasi signing sesuai kebutuhan, lalu `flutter build apk --release`.

## Struktur

```text
lib/
  main.dart                  # entry point, tema, dependency injection
  models/movie.dart          # model dan konversi JSON
  services/movie_service.dart # HTTP, status, parsing, timeout, error
  screens/catalog_page.dart  # FutureBuilder, cari/filter/urutkan
  screens/detail_page.dart   # halaman detail dan sinopsis
  widgets/movie_image.dart   # gambar jaringan dan placeholder
test/
  movie_service_test.dart    # 11 pengujian model/service
  widget_test.dart           # 6 pengujian interaksi UI
  fixtures/films.json        # respons nyata API untuk bukti/screenshot
 docs/
  screenshots/              # screenshot dari widget aplikasi
  assets/logo-uin.png        # lambang dari situs resmi fakultas
  PENGUJIAN.md
  PENGUMPULAN.md
output/pdf/                  # laporan tugas
 tools/
  capture_screenshots.dart   # utilitas screenshot ukuran ponsel
  generate_report.py         # sumber laporan PDF
```

## API dan alur data

`GET https://ghibliapi.vercel.app/films` mengembalikan array objek. Field yang digunakan: `id`, `title`, `original_title`, `image`, `movie_banner`, `description`, `director`, `producer`, `release_date`, `running_time`, `rt_score`. Tiga field numerik dikirim sebagai string, lalu dikonversi dengan `int.tryParse`.

`HTTP GET -> pemeriksaan status 200 -> jsonDecode -> Movie.fromJson -> Future<List<Movie>> -> FutureBuilder -> grid/detail`.

Future dibuat di `initState`, tidak dibuat ulang ketika pengguna mencari/filter. Pencarian dan pengurutan dilakukan lokal pada hasil API. Tombol muat ulang membuat Future baru. Navigasi detail meneruskan model film; tidak memerlukan permintaan ulang. Dokumentasi API: https://ghibliapi.vercel.app/.

## Validasi

Pada 20 Oktober 2026: 17 pengujian otomatis lulus; `flutter analyze` bersih; APK debug berhasil dibangun. Respons nyata API berhasil diperoleh (22 film saat pemeriksaan). Lihat [hasil pengujian](docs/PENGUJIAN.md) untuk cakupan dan batas verifikasi. Belum diuji pada ponsel fisik/emulator Android karena tidak ada perangkat Android terhubung.

Screenshot laporan dirender dari widget aplikasi pada viewport 390 x 844 dengan fixture respons API nyata, poster asli, dan respons error simulasi. Ini bukan bukti pengujian jaringan end-to-end pada perangkat Android. File fixture hanya digunakan untuk dokumentasi/pengujian, bukan fallback aplikasi.

## Laporan dan pengumpulan

[Laporan PDF](output/pdf/Laporan_UTS_Layar_Ghibli_Muhammad_Murtaqi_Yahya.pdf). Lihat [checklist pengumpulan](docs/PENGUMPULAN.md). Publikasi repositori GitHub dan unggahan Google Drive belum dilakukan.

## Regenerasi dokumentasi (opsional)

`tools/capture_screenshots.dart` membutuhkan fixture, empat poster/bannernya di `tmp/posters/<id>.jpg` dan `<id>-banner.jpg`, font Noto Sans JP di `tmp/NotoSansJP.ttf`, serta font MaterialIcons dari lokasi SDK Flutter pada script (sesuaikan dengan komputer). Poster diunduh dari URL `image`/`movie_banner` respons API. Font: https://github.com/google/fonts/tree/main/ofl/notosansjp. Jalankan `flutter test tools/capture_screenshots.dart`.

Untuk membuat laporan: instal Python `reportlab`, lalu `python tools/generate_report.py`. Pada lingkungan pengembangan ini package berada di `tmp/report_tools`; script juga mendukung instalasi Python biasa.

Logo cover diambil dari https://saintek.uin-malang.ac.id/wp-content/uploads/2025/07/uin-png-9.png (lambang universitas pada situs resmi Fakultas Sains dan Teknologi). Poster/banner dan data film merupakan milik pemegang hak masing-masing; dipakai untuk demonstrasi akademik melalui data API.
