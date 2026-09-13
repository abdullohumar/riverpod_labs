# Lab 03 — Notifier

> Level: menengah · Prasyarat: [Lab 02 — StateProvider](../02-stateprovider-counter/README.md)

## Yang akan kamu pelajari

- `Notifier<T>`: provider berbasis class untuk state yang butuh logika
  sungguhan
- Kenapa UI sebaiknya memanggil **method bernama** (`addTodo`, `toggle`,
  `remove`) alih-alih mengutak-atik `.state` langsung
- Update state yang immutable: selalu ganti `state`, jangan pernah
  memutasinya langsung
- `build()` sebagai "constructor untuk state awal"
- Memecah satu fitur menjadi `models/`, `providers/`, dan file UI —
  struktur yang akan kamu pakai lagi mulai lab ini dan seterusnya

## Kenapa harus lanjut dari `StateProvider`?

`StateProvider` sangat pas untuk satu field. Daftar todo butuh:

- banyak operasi (tambah, toggle, hapus, bersihkan) — kalau ditulis
  sebagai baris `.state = ...` satu-satu, ini cepat berantakan, dan UI
  akhirnya melakukan manipulasi list-nya sendiri, artinya logika yang
  sama bisa terduplikasi dan makin lama makin berbeda tiap kali di-copy
  paste
- menolak input yang tidak valid (judul kosong)
- satu tempat tunggal yang bisa di-test, yang benar-benar "memiliki"
  bagaimana list ini berubah

`Notifier<T>` menyelesaikan ini: dia cuma class Dart biasa, jadi kamu
menulis method biasa, dan satu-satunya syarat dari framework adalah
mutasi harus terjadi dengan meng-assign ulang `state`.

```dart
class TodoNotifier extends Notifier<List<Todo>> {
  @override
  List<Todo> build() => const []; // state awal

  void addTodo(String title) {
    state = [...state, Todo(id: ..., title: title)]; // list BARU
  }
}

final todosProvider = NotifierProvider<TodoNotifier, List<Todo>>(TodoNotifier.new);
```

## Kenapa immutability itu penting di sini

```dart
// SALAH — memutasi list yang sudah ada, Riverpod tidak akan sadar:
state.add(newTodo);

// BENAR — membuat list baru, Riverpod mendeteksi referensi baru dan
// memberi tahu setiap widget yang meng-watch todosProvider:
state = [...state, newTodo];
```

Riverpod (seperti `setState`) memutuskan apakah perlu memberi tahu
listener dengan mengecek apakah state yang *baru* berbeda dari yang
*lama*. Kalau kamu memutasi list di tempat, "lama" dan "baru" adalah
objek yang sama persis — dari sudut pandang Riverpod tidak ada yang
berubah, jadi tidak ada yang rebuild.

## Struktur project

```
lib/
  models/todo.dart          # class data immutable biasa
  providers/todo_notifier.dart  # TodoNotifier + todosProvider
  main.dart                 # UI saja — memanggil method notifier, watch state
```

Inilah bentuk yang sebaiknya kamu pakai di aplikasi nyata: model,
provider, dan UI di file/folder terpisah, supaya logika bisnis tetap bisa
di-test tanpa harus mengimpor widget Flutter.

## Instruksi

1. Mulai dari `01-start/lib/providers/todo_notifier.dart` — TODO 1 sampai
   6. Aplikasi tidak akan bisa di-compile sampai `todosProvider` ada,
   jadi kerjakan file ini dulu.
2. Lanjut ke `01-start/lib/main.dart` — TODO 7 sampai 11.
3. Jalankan dan coba-coba aplikasinya: tambah beberapa todo, toggle
   sebagian, swipe untuk hapus salah satu, bersihkan yang sudah selesai.
4. Bandingkan dengan `02-final`.

```bash
cd 01-start
flutter pub get
flutter run
```

## Checkpoint questions

- Kenapa `toggle` membuat list baru sepenuhnya, bukan cuma mengganti satu
  `Todo` yang berubah?
- Apa yang salah kalau `addTodo` tidak mengecek judul kosong/blank
  sebelum meng-update state?
- Kalau dua widget berbeda sama-sama melakukan
  `ref.watch(todosProvider)`, berapa kali `build()` (milik notifier,
  bukan widget) dijalankan?

## Jebakan umum

- **Memutasi `state` langsung** (`state.add(x)`, `state[i] = x`) — bug
  Riverpod yang paling sering terjadi. Selalu assign koleksi baru.
- **Menaruh logika di UI** (`ref.read(todosProvider.notifier).state = [...]`
  dari sebuah widget) — kalau kamu tergoda melakukan ini, sebaiknya jadi
  method bernama di notifier saja.
- **Lupa `TodoNotifier.new`** — `NotifierProvider` menerima sebuah
  *factory* yang membuat instance notifier baru, bukan instance notifier
  itu sendiri.

## Lab berikutnya

[Lab 04 — Provider turunan/komputasi](../04-computed-providers/README.md):
memformalkan pola "provider yang nilainya bergantung pada provider lain"
— filtering, kombinasi, dan `select` untuk performa.
