import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/network/globals.dart';
import '../../domain/entities/training_video_entity.dart';
import '../../domain/entities/video_category_entity.dart';
import '../../domain/entities/trainer_option.dart';
import '../bloc/training_videos_bloc.dart';
import '../bloc/training_videos_event.dart';
import '../bloc/training_videos_state.dart';
import '../../data/models/update_training_video_request.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

class EditTrainingVideoPage extends StatefulWidget {
  final TrainingVideoEntity video;
  const EditTrainingVideoPage({super.key, required this.video});

  @override
  State<EditTrainingVideoPage> createState() => _EditTrainingVideoPageState();
}

class _EditTrainingVideoPageState extends State<EditTrainingVideoPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _videoUrlController;
  late final TextEditingController _thumbnailUrlController;
  late final TextEditingController _minutesController;
  late final TextEditingController _secondsController;

  File? _selectedVideo;
  late bool _isPublished;
  List<TrainerOption> _trainers = [];
  List<VideoCategoryEntity> _categories = [];
  int? _selectedTrainerId;
  int? _selectedCategoryId; // set only once categories are loaded

  late final int _initialCategoryId;
  late final bool _isOwner;

  @override
  void initState() {
    super.initState();
    final payload = decodeJwtPayload();
    final role = ((payload?['role'] as String?) ?? '').toUpperCase().trim();
    _isOwner = role == 'OWNER' || role == 'ADMIN';

    final v = widget.video;
    _titleController        = TextEditingController(text: v.title);
    _descriptionController  = TextEditingController(text: v.description ?? '');
    _videoUrlController     = TextEditingController(text: v.videoUrl ?? '');
    _thumbnailUrlController = TextEditingController(text: v.thumbnailUrl ?? '');
    _minutesController      = TextEditingController(text: '${v.durationSeconds ~/ 60}');
    _secondsController      = TextEditingController(text: '${v.durationSeconds % 60}');
    _isPublished        = v.isPublished;
    _initialCategoryId  = v.categoryId;

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
          decoration: const InputDecoration(hintText: 'e.g. Cardio, Strength, Yoga...'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Add')),
        ],
      ),
    );
    if (confirmed == true && controller.text.trim().isNotEmpty && mounted) {
      context.read<TrainingVideosBloc>().add(AddNewCategory(controller.text.trim()));
    }
    controller.dispose();
  }

  Future<void> _pickVideo() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.video);
    if (result != null && result.files.single.path != null) {
      setState(() => _selectedVideo = File(result.files.single.path!));
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a category')),
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

    context.read<TrainingVideosBloc>().add(
      SubmitUpdateVideo(
        UpdateTrainingVideoRequest(
          videoId: widget.video.videoId,
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          categoryId: _selectedCategoryId!,
          videoUrl: _videoUrlController.text.trim(),
          thumbnailUrl: _thumbnailUrlController.text.trim(),
          durationSeconds: totalSeconds,
          isPublished: _isPublished,
          trainerId: _isOwner ? _selectedTrainerId : null,
          videoFile: _selectedVideo,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<TrainingVideosBloc, TrainingVideosState>(
          listenWhen: (_, curr) => curr is UpdateVideoSuccess || curr is UpdateVideoError,
          listener: (context, state) {
            if (state is UpdateVideoSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Video updated successfully')),
              );
              Navigator.pop(context, true);
            } else if (state is UpdateVideoError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
        ),
        BlocListener<TrainingVideosBloc, TrainingVideosState>(
          listenWhen: (_, curr) => curr is CategoryCreated || curr is CategoryCreateError,
          listener: (context, state) {
            if (state is CategoryCreated) {
              setState(() {
                _categories = [..._categories, state.category];
                _selectedCategoryId = state.category.categoryId;
              });
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
            curr is CategoryCreated ||
            curr is CategoryCreateError ||
            curr is UpdateVideoLoading,
        builder: (context, state) {
          if (state is VideoFormOptionsLoaded) {
            _trainers   = state.trainers;
            _categories = state.categories;
            // Safe to set pre-filled category now that items are available
            if (_selectedCategoryId == null &&
                _categories.any((c) => c.categoryId == _initialCategoryId)) {
              _selectedCategoryId = _initialCategoryId;
            }
          }
          final isLoading = state is UpdateVideoLoading;
          final isCategoryCreating = state is CategoryCreating;

          return Scaffold(
            appBar: AppBar(
              title: const Text('Edit Video'),
              centerTitle: false,
            ),
            body: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Title *'),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Title is required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: 'Description (optional)'),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<int?>(
                          value: _selectedCategoryId,
                          decoration: const InputDecoration(labelText: 'Category *'),
                          hint: const Text('Select a category'),
                          items: _categories
                              .map((c) => DropdownMenuItem<int?>(
                                    value: c.categoryId,
                                    child: Text(c.name),
                                  ))
                              .toList(),
                          onChanged: (val) => setState(() => _selectedCategoryId = val),
                          validator: (v) => v == null ? 'Please select a category' : null,
                        ),
                      ),
                      const SizedBox(width: 8),
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
                                    child: CircularProgressIndicator(strokeWidth: 2),
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
                  if (_isOwner) ...[
                    DropdownButtonFormField<int?>(
                      value: _selectedTrainerId,
                      decoration: const InputDecoration(labelText: 'Reassign Trainer (optional)'),
                      hint: const Text('Keep current trainer'),
                      items: _trainers
                          .map((t) => DropdownMenuItem<int?>(
                                value: t.trainerId,
                                child: Text(t.name),
                              ))
                          .toList(),
                      onChanged: (val) => setState(() => _selectedTrainerId = val),
                    ),
                    const SizedBox(height: 16),
                  ],
                  ElevatedButton.icon(
                    onPressed: _pickVideo,
                    icon: const Icon(Icons.video_library),
                    label: const Text('Replace Video File (optional)'),
                  ),
                  if (_selectedVideo != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(_selectedVideo!.path.split('/').last),
                    ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _videoUrlController,
                    decoration: const InputDecoration(labelText: 'Video URL (YouTube/Vimeo)'),
                    keyboardType: TextInputType.url,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _thumbnailUrlController,
                    decoration: const InputDecoration(labelText: 'Thumbnail URL (optional)'),
                    keyboardType: TextInputType.url,
                  ),
                  const SizedBox(height: 16),
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
                  SwitchListTile(
                    title: const Text('Published'),
                    subtitle: const Text('Visible to members immediately'),
                    value: _isPublished,
                    onChanged: (val) => setState(() => _isPublished = val),
                    contentPadding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 24),
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
                          : const Text('Save Changes'),
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
