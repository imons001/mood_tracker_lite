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

  String? aiResponse;
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

  Future<void> _getAIReflection() async {
    if (_journalController.text.trim().isEmpty) return;

    setState(() => isLoading = true);

    final feedback = await openAI.getMoodFeedback(
      mood: widget.label,
      journalText: _journalController.text,
    );

    setState(() {
      isLoading = false;

      // Append reflection to journal text
      final currentText = _journalController.text.trim();
      final formattedFeedback = "\n\n---\nAI Reflection:\n$feedback";

      _journalController.text = "$currentText$formattedFeedback";

      // Move cursor to end
      _journalController.selection = TextSelection.fromPosition(
        TextPosition(offset: _journalController.text.length),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final now = DateFormat('EEE, MMM d – h:mm a').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade200,
        title: Text(
          '${widget.label} Mood',
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          if (isRevisit)
            IconButton(
              icon: Icon(
                isEditing ? Icons.check : Icons.edit,
                color: const Color.fromARGB(255, 14, 51, 27),
              ),
              tooltip: isEditing ? 'Save Changes' : 'Edit Entry',
              onPressed: () {
                if (isEditing) {
                  final updatedLog = MoodLog(
                    emoji: widget.emoji,
                    label: widget.label,
                    dateTime: widget.existingLog!.dateTime,
                    entryText: _journalController.text,
                  );
                  Navigator.pop(context, updatedLog);
                } else {
                  setState(() => isEditing = true);
                }
              },
            ),
        ],
      ),

//for each emotion custom visuals can be built here
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Default forest background for all moods in case no custiom visuals
          // are provided by subclasses
          Image.asset(
            'assets/images/forest_begin.png',
            fit: BoxFit.cover,
          ),

          // allow custom visuals (Sadness overrides this)
          widget.buildVisuals(context),

          // Foreground UI content
          Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    'You are feeling ${widget.label} ${widget.emoji}\n$now',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    height: 250,
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Scrollbar(
                      thumbVisibility: true,
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.all(8),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(minHeight: 250),
                          child: IntrinsicHeight(
                            child: TextField(
                              controller: _journalController,
                              enabled: !isRevisit || isEditing,
                              style: const TextStyle(color: Colors.white),
                              maxLines: null,
                              decoration: InputDecoration(
                                hintText: isEditing
                                    ? 'Edit your journal entry...'
                                    : 'Write your thoughts here...',
                                hintStyle: const TextStyle(
                                  color: Colors.white70,
                                ),
                                border: InputBorder.none,
                              ),
                              showCursor: true,
                              enableInteractiveSelection: true,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  if (!isRevisit)
                    ElevatedButton.icon(
                      onPressed: _getAIReflection,
                      icon: const Icon(Icons.spa),
                      label: const Text('Reflect with AI ✨'),
                    ),
                  const SizedBox(height: 30),
                  if (!isRevisit)
                    ElevatedButton.icon(
                      onPressed: () {
                        final newLog = MoodLog(
                          emoji: widget.emoji,
                          label: widget.label,
                          dateTime: DateTime.now(),
                          entryText: _journalController.text,
                        );
                        Navigator.pop(context, newLog);
                      },
                      icon: const Icon(Icons.save),
                      label: const Text('Save Mood Entry'),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
