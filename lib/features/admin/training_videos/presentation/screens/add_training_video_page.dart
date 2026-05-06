import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/network/globals.dart'; // for decodeJwtPayload
import '../bloc/training_videos_bloc.dart';
import '../bloc/training_videos_event.dart';
import '../bloc/training_videos_state.dart';
import '../../data/models/create_training_video_request.dart';
import '../../domain/entities/trainer_option.dart';

class AddTrainingVideoPage extends StatefulWidget {
  const AddTrainingVideoPage({super.key});

  @override
  State<AddTrainingVideoPage> createState() => _AddTrainingVideoPageState();
}

class _AddTrainingVideoPageState extends State<AddTrainingVideoPage> {
  final _formKey = GlobalKey<FormState>();

  final _titleController       = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController    = TextEditingController(); // ✅ free text
  final _videoUrlController    = TextEditingController();
  final _thumbnailUrlController = TextEditingController();
  final _minutesController     = TextEditingController();
  final _secondsController     = TextEditingController();

  bool _isPublished = true;
  List<TrainerOption> _trainers = [];
  int? _selectedTrainerId;

  // ── Role detection from JWT ──────────────────────────────────────────────
  late final String _role;
  late final int? _jwtTrainerId;
  late final bool _isOwner;

  @override
  void initState() {
    super.initState();

    // Read role + trainer identity directly from JWT claims
    final payload = decodeJwtPayload();
    _role = ((payload?['role'] as String?) ?? '').toUpperCase().trim();
    _isOwner = _role == 'OWNER' || _role == 'ADMIN';

    // If trainer: extract their ID from JWT (sub = userId, or trainerId claim)
    if (!_isOwner) {
      final raw = payload?['trainerId'] ?? payload?['sub'];
      _jwtTrainerId = raw is int
          ? raw
          : int.tryParse(raw?.toString() ?? '');
    } else {
      _jwtTrainerId = null;
    }

    // Only owners need to load the trainer dropdown
    if (_isOwner) {
      context.read<TrainingVideosBloc>().add(LoadVideoFormOptions());
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _videoUrlController.dispose();
    _thumbnailUrlController.dispose();
    _minutesController.dispose();
    _secondsController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final minutes = int.tryParse(_minutesController.text) ?? 0;
    final seconds = int.tryParse(_secondsController.text) ?? 0;
    final totalSeconds = (minutes * 60) + seconds;

    if (totalSeconds <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Duration must be greater than 0')),
      );
      return;
    }

    // Owner uses dropdown selection; trainer uses their JWT id
    final resolvedTrainerId = _isOwner ? _selectedTrainerId : _jwtTrainerId;

    context.read<TrainingVideosBloc>().add(
      SubmitCreateVideo(
        CreateTrainingVideoRequest(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          categoryName: _categoryController.text.trim(), // ✅ free text
          videoUrl: _videoUrlController.text.trim(),
          thumbnailUrl: _thumbnailUrlController.text.trim(),
          durationSeconds: totalSeconds,
          isPublished: _isPublished,
          trainerId: resolvedTrainerId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TrainingVideosBloc, TrainingVideosState>(
      listenWhen: (_, curr) =>
      curr is CreateVideoSuccess || curr is CreateVideoError,
      listener: (context, state) {
        if (state is CreateVideoSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Video added successfully')),
          );
          Navigator.pop(context);
        } else if (state is CreateVideoError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: BlocBuilder<TrainingVideosBloc, TrainingVideosState>(
        buildWhen: (_, curr) =>
        curr is VideoFormOptionsLoaded ||
            curr is CreateVideoLoading ||
            curr is CreateVideoError ||
            curr is CreateVideoSuccess,
        builder: (context, state) {
          if (state is VideoFormOptionsLoaded) {
            _trainers = state.trainers;
          }
          final isLoading = state is CreateVideoLoading;

          return Scaffold(
            appBar: AppBar(
              title: const Text('Add Training Video'),
              centerTitle: false,
            ),
            body: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [

                  // ── Title ──────────────────────────────────────────────
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Title *'),
                    validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Title is required' : null,
                  ),
                  const SizedBox(height: 16),

                  // ── Description ────────────────────────────────────────
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                        labelText: 'Description (optional)'),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),

                  // ── Category — free text ✅ ────────────────────────────
                  TextFormField(
                    controller: _categoryController,
                    decoration: const InputDecoration(
                      labelText: 'Category *',
                      hintText: 'e.g. Cardio, Strength, Yoga...',
                      helperText: 'Type a new or existing category name',
                    ),
                    textCapitalization: TextCapitalization.words,
                    validator: (v) =>
                    (v == null || v.trim().isEmpty)
                        ? 'Category is required'
                        : null,
                  ),
                  const SizedBox(height: 16),

                  // ── Trainer assignment — role-aware ✅ ─────────────────
                  if (_isOwner) ...[
                    // Owner: pick from dropdown
                    DropdownButtonFormField<int?>(
                      value: _selectedTrainerId,
                      decoration: const InputDecoration(
                        labelText: 'Assign to Trainer *',
                      ),
                      hint: const Text('Select a trainer'),
                      items: _trainers
                          .map((t) => DropdownMenuItem<int?>(
                        value: t.trainerId,
                        child: Text(t.name),
                      ))
                          .toList(),
                      onChanged: (val) =>
                          setState(() => _selectedTrainerId = val),
                      validator: (v) =>
                      v == null ? 'Please assign a trainer' : null,
                    ),
                    const SizedBox(height: 16),
                  ] else ...[
                    // Trainer: show read-only chip — their ID auto-attached
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primaryContainer
                            .withOpacity(0.4),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.person_outline, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'Posted by you (Trainer ID: ${_jwtTrainerId ?? '—'})',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // ── Video URL ──────────────────────────────────────────
                  TextFormField(
                    controller: _videoUrlController,
                    decoration: const InputDecoration(
                        labelText: 'Video URL * (YouTube/Vimeo)'),
                    keyboardType: TextInputType.url,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'URL is required';
                      if (!v.trim().startsWith('https://')) {
                        return 'Must be a valid HTTPS URL';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // ── Thumbnail URL ──────────────────────────────────────
                  TextFormField(
                    controller: _thumbnailUrlController,
                    decoration: const InputDecoration(
                        labelText: 'Thumbnail URL (optional)'),
                    keyboardType: TextInputType.url,
                  ),
                  const SizedBox(height: 16),

                  // ── Duration ───────────────────────────────────────────
                  const Text('Duration *',
                      style: TextStyle(fontSize: 12, color: Colors.black54)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _minutesController,
                          decoration: const InputDecoration(
                              labelText: 'Minutes', suffixText: 'min'),
                          keyboardType: TextInputType.number,
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Required';
                            if (int.tryParse(v) == null) return 'Invalid';
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _secondsController,
                          decoration: const InputDecoration(
                              labelText: 'Seconds', suffixText: 'sec'),
                          keyboardType: TextInputType.number,
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Required';
                            final n = int.tryParse(v);
                            if (n == null || n < 0 || n > 59) return '0–59';
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ── Published toggle ───────────────────────────────────
                  SwitchListTile(
                    title: const Text('Published'),
                    subtitle: const Text('Visible to members immediately'),
                    value: _isPublished,
                    onChanged: (val) => setState(() => _isPublished = val),
                    contentPadding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 24),

                  // ── Submit ─────────────────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton(
                      onPressed: isLoading ? null : _submit,
                      child: isLoading
                          ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                          : const Text('Add Video'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}