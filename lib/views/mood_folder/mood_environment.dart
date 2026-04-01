import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/openai_service.dart';
import '../../models/mood_log.dart';

/// Base Environment — handles journaling + AI reflection
class MoodEnvironment extends StatefulWidget {
  final String emoji;
  final String label;
  final MoodLog? existingLog;

  const MoodEnvironment({
    super.key,
    required this.emoji,
    required this.label,
    this.existingLog,
  });

  // allows subclasses to override their visuals
  Widget buildVisuals(BuildContext context) => const SizedBox.shrink();

  @override
  State<MoodEnvironment> createState() => _MoodEnvironmentState();
}

class _MoodEnvironmentState extends State<MoodEnvironment> {
  final TextEditingController _journalController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final openAI = OpenAIService();

  bool isLoading = false;
  bool isEditing = false;

  bool get isRevisit => widget.existingLog != null;

  @override
  void initState() {
    super.initState();
    if (isRevisit) {
      _journalController.text = widget.existingLog!.entryText;
    }
  }

  @override
  void dispose() {
    _journalController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _getAIReflection() async {
    if (_journalController.text.trim().isEmpty) return;

    setState(() => isLoading = true);

    final feedback = await openAI.getMoodFeedback(
      mood: widget.label,
      journalText: _journalController.text,
    );

    setState(() {
      isLoading = false;

      final currentText = _journalController.text.trim();
      final formattedFeedback = "\n\n---\nAI Reflection:\n$feedback";

      _journalController.text = "$currentText$formattedFeedback";

      _journalController.selection = TextSelection.fromPosition(
        TextPosition(offset: _journalController.text.length),
      );
    });
  }

  void _toggleEditOrSave() {
    if (isEditing) {
      final updatedLog = MoodLog(
        emoji: widget.emoji,
        label: widget.label,
        timestamp: widget.existingLog!.timestamp,
        entryText: _journalController.text,
      );
      Navigator.pop(context, updatedLog);
    } else {
      setState(() => isEditing = true);
    }
  }

  void _saveNewEntry() {
    final newLog = MoodLog(
      emoji: widget.emoji,
      label: widget.label,
      timestamp: DateTime.now(),
      entryText: _journalController.text,
    );
    Navigator.pop(context, newLog);
  }

  @override
  Widget build(BuildContext context) {
    final now = DateFormat('EEE, MMM d – h:mm a').format(DateTime.now());

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '${widget.label} ${widget.emoji}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
        backgroundColor: Colors.black.withOpacity(0.35),
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (isRevisit)
            IconButton(
              icon: Icon(isEditing ? Icons.check : Icons.edit),
              tooltip: isEditing ? 'Save Changes' : 'Edit Entry',
              onPressed: _toggleEditOrSave,
            ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/forest_begin.png',
            fit: BoxFit.cover,
          ),
          widget.buildVisuals(context),
          Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 90),
                  Text(
                    now,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    height: 250,
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white24,
                        width: 1.2,
                      ),
                    ),
                    child: Scrollbar(
                      controller: _scrollController,
                      thumbVisibility: true,
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(10),
                        child: TextField(
                          controller: _journalController,
                          enabled: !isRevisit || isEditing,
                          style: const TextStyle(color: Colors.white),
                          maxLines: null,
                          decoration: InputDecoration(
                            hintText: isRevisit
                                ? (isEditing
                                    ? 'Edit your journal entry...'
                                    : 'Tap edit to make changes...')
                                : 'Write your thoughts here...',
                            hintStyle: const TextStyle(color: Colors.white70),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (!isRevisit)
                    ElevatedButton.icon(
                      onPressed: isLoading ? null : _getAIReflection,
                      icon: const Icon(Icons.spa),
                      label:
                          Text(isLoading ? 'Reflecting...' : 'Reflect with AI'),
                    ),
                  const SizedBox(height: 16),
                  if (!isRevisit)
                    ElevatedButton.icon(
                      onPressed: _saveNewEntry,
                      icon: const Icon(Icons.save),
                      label: const Text('Save Mood Entry'),
                    ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
