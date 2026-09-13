import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'models/note.dart';
import 'providers/notes_providers.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber)),
      home: const NotesPage(),
    );
  }
}

class NotesPage extends ConsumerWidget {
  const NotesPage({super.key});

  Future<void> _openNoteDialog(BuildContext context, WidgetRef ref) async {
    final titleController = TextEditingController();
    final bodyController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New note'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Title')),
            TextField(controller: bodyController, decoration: const InputDecoration(labelText: 'Body'), maxLines: 3),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Save')),
        ],
      ),
    );

    if (result == true) {
      await ref.read(notesProvider.notifier).addNote(title: titleController.text, body: bodyController.text);
    }
    titleController.dispose();
    bodyController.dispose();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredAsync = ref.watch(filteredNotesProvider);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: const InputDecoration(hintText: 'Search notes...', border: InputBorder.none),
          style: const TextStyle(color: Colors.white, fontSize: 18),
          cursorColor: Colors.white,
          onChanged: (value) => ref.read(searchQueryProvider.notifier).state = value,
        ),
      ),
      body: filteredAsync.when(
        data: (notes) => notes.isEmpty
            ? const Center(child: Text('No notes yet — tap + to add one.'))
            : ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) => _NoteTile(note: notes[index]),
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Could not load notes: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openNoteDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _NoteTile extends ConsumerWidget {
  const _NoteTile({required this.note});

  final Note note;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: ValueKey(note.id),
      background: Container(color: Colors.red, alignment: Alignment.centerLeft, padding: const EdgeInsets.only(left: 16), child: const Icon(Icons.delete, color: Colors.white)),
      onDismissed: (_) => ref.read(notesProvider.notifier).deleteNote(note.id),
      child: ListTile(
        title: Text(note.title),
        subtitle: Text(note.body, maxLines: 2, overflow: TextOverflow.ellipsis),
        trailing: IconButton(
          icon: Icon(note.pinned ? Icons.push_pin : Icons.push_pin_outlined),
          onPressed: () => ref.read(notesProvider.notifier).togglePin(note.id),
        ),
      ),
    );
  }
}
