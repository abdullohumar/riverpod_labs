import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/note.dart';

/// Persistence, ide yang sama seperti pola repository di Lab 06 —
/// notifier-nya (lihat providers/notes_providers.dart) tidak tahu dan
/// tidak peduli ini disimpan lewat SharedPreferences secara spesifik;
/// dia cuma memanggil loadNotes/saveNotes.
class NotesRepository {
  static const _key = 'notes_v1';

  Future<List<Note>> loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? const [];
    return raw.map((s) => Note.fromJson(jsonDecode(s) as Map<String, dynamic>)).toList();
  }

  Future<void> saveNotes(List<Note> notes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, notes.map((n) => jsonEncode(n.toJson())).toList());
  }
}
