/// Class data immutable biasa. Tidak ada yang spesifik Riverpod di sini —
/// tapi immutability adalah kebiasaan kunci yang membuat state `Notifier`
/// bisa diprediksi: kita tidak pernah memutasi sebuah `Todo` atau list
/// yang menampungnya, kita selalu membuat yang baru.
class Todo {
  const Todo({required this.id, required this.title, this.completed = false});

  final String id;
  final String title;
  final bool completed;

  Todo copyWith({String? title, bool? completed}) {
    return Todo(
      id: id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
    );
  }
}
