import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/network/globals.dart'; // for decodeJwtPayload
import '../../domain/entities/video_category_entity.dart';
import '../bloc/training_videos_bloc.dart';
import '../bloc/training_videos_event.dart';
import '../bloc/training_videos_state.dart';
import '../../data/models/create_training_video_request.dart';
import '../../domain/entities/trainer_option.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

class AddTrainingVideoPage extends StatefulWidget {
  const AddTrainingVideoPage({super.key});

  @override
  State<AddTrainingVideoPage> createState() => _AddTrainingVideoPageState();
}

class _AddTrainingVideoPageState extends State<AddTrainingVideoPage> {
  final _formKey = GlobalKey<FormState>();

  final _titleController        = TextEditingController();
  final _descriptionController  = TextEditingController();
  final _videoUrlController     = TextEditingController();
  final _thumbnailUrlController = TextEditingController();
  final _minutesController      = TextEditingController();
  final _secondsController      = TextEditingController();
  File? _selectedVideo;
  bool _isPublished = true;
  List<TrainerOption> _trainers = [];
  List<VideoCategoryEntity> _categories = []; // ✅
  int? _selectedTrainerId;
  int? _selectedCategoryId;               // ✅

  late final String _role;
  late final int? _jwtTrainerId;
  late final bool _isOwner;

  @override
  void initState() {
    super.initState();
    final payload = decodeJwtPayload();
    _role = ((payload?['role'] as String?) ?? '').toUpperCase().trim();
    _isOwner = _role == 'OWNER' || _role == 'ADMIN';

    if (!_isOwner) {
      final raw = payload?['trainerId'] ?? payload?['sub'];
      _jwtTrainerId = raw is int ? raw : int.tryParse(raw?.toString() ?? '');
    } else {
      _jwtTrainerId = null;
    }

    // Always load form options (categories needed for everyone)
    context.read<TrainingVideosBloc>().add(LoadVideoFormOptions());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _videoUrlController.dispose();
    _thumbnailUrlController.dispose();
    _minutesController.dispose();
    _secondsController.dispose();
    super.dispose();
  }

  /// Opens a dialog to type a new category name and dispatches AddNewCategory
  Future<void> _showAddCategoryDialog() async {
    final controller = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('New Category'),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            hintText: 'e.g. Cardio, Strength, Yoga...',
            labelText: 'Category name',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Add'),
          ),
        ],
      ),
    );

    if (confirmed == true && controller.text.trim().isNotEmpty) {
      if (mounted) {
        context.read<TrainingVideosBloc>().add(
          AddNewCategory(controller.text.trim()),
        );
      }
    }
    controller.dispose();
  }

  Future<void> _pickVideo() async {

    final result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedVideo = File(result.files.single.path!);
      });
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select or create a category')),
      );
      return;
    }

    final minutes = int.tryParse(_minutesController.text) ?? 0;
    final seconds = int.tryParse(_secondsController.text) ?? 0;
    final totalSeconds = (minutes * 60) + seconds;

    if (totalSeconds <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Duration must be greater than 0')),
      );
      return;
    }

    final resolvedTrainerId = _isOwner ? _selectedTrainerId : _jwtTrainerId;

    context.read<TrainingVideosBloc>().add(
      SubmitCreateVideo(
        CreateTrainingVideoRequest(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          categoryId: _selectedCategoryId!,  // ✅ int
          videoUrl: _videoUrlController.text.trim(),
          videoFile: _selectedVideo,
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
    return MultiBlocListener(
      listeners: [
        // Success/error for video submission
        BlocListener<TrainingVideosBloc, TrainingVideosState>(
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
        ),
        // Category created → add to list and auto-select
        BlocListener<TrainingVideosBloc, TrainingVideosState>(
          listenWhen: (_, curr) =>
          curr is CategoryCreated || curr is CategoryCreateError,
          listener: (context, state) {
            if (state is CategoryCreated) {
              setState(() {
                _categories = [..._categories, state.category];
                _selectedCategoryId = state.category.categoryId;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Category "${state.category.name}" created and selected',
                  ),
                ),
              );
            } else if (state is CategoryCreateError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed: ${state.message}')),
              );
            }
          },
        ),
      ],
      child: BlocBuilder<TrainingVideosBloc, TrainingVideosState>(
        buildWhen: (_, curr) =>
        curr is VideoFormOptionsLoaded ||
            curr is CategoryCreating ||
            curr is CategoryCreated ||     // clears the spinner
            curr is CategoryCreateError || // clears the spinner on failure
            curr is CreateVideoLoading,
        builder: (context, state) {
          if (state is VideoFormOptionsLoaded) {
            _trainers   = state.trainers;
            _categories = state.categories;
          }
          final isLoading = state is CreateVideoLoading;
          final isCategoryCreating = state is CategoryCreating;

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

                  // ── Category — dropdown + "+" button ✅ ───────────────
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<int?>(
                          value: _selectedCategoryId,
                          decoration: const InputDecoration(
                            labelText: 'Category *',
                          ),
                          hint: const Text('Select a category'),
                          items: _categories
                              .map((c) => DropdownMenuItem<int?>(
                            value: c.categoryId,
                            child: Text(c.name),
                          ))
                              .toList(),
                          onChanged: (val) =>
                              setState(() => _selectedCategoryId = val),
                          validator: (v) =>
                          v == null ? 'Please select a category' : null,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // "+" button to create a new category inline
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: isCategoryCreating
                            ? const SizedBox(
                          width: 48,
                          height: 48,
                          child: Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2),
                            ),
                          ),
                        )
                            : IconButton.filled(
                          onPressed: _showAddCategoryDialog,
                          icon: const Icon(Icons.add),
                          tooltip: 'Add new category',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ── Trainer — role-aware ───────────────────────────────
                  if (_isOwner) ...[
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
                            color: Theme.of(context).colorScheme.outline),
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

                  ElevatedButton.icon(
                    onPressed: _pickVideo,
                    icon: const Icon(Icons.video_library),
                    label: const Text('Pick Video From Phone'),
                  ),

                  if (_selectedVideo != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        _selectedVideo!.path.split('/').last,
                      ),
                    ),

                  // ── Video URL ──────────────────────────────────────────
                  TextFormField(
                      controller: _videoUrlController,
                      decoration: const InputDecoration(
                          labelText: 'Video URL * (YouTube/Vimeo)'),
                      keyboardType: TextInputType.url
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