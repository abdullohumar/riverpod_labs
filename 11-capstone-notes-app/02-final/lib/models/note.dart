class Note {
  const Note({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    this.pinned = false,
  });

  final String id;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool pinned;

  Note copyWith({String? title, String? body, bool? pinned}) {
    return Note(
      id: id,
      title: title ?? this.title,
      body: body ?? this.body,
      createdAt: createdAt,
      pinned: pinned ?? this.pinned,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'createdAt': createdAt.toIso8601String(),
        'pinned': pinned,
      };

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      pinned: json['pinned'] as bool? ?? false,
    );
  }
}
