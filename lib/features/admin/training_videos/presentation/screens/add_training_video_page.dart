import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../../../core/network/globals.dart';
import '../../domain/entities/video_category_entity.dart';
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

  final _titleController        = TextEditingController();
  final _descriptionController  = TextEditingController();
  final _videoUrlController     = TextEditingController();
  final _thumbnailUrlController = TextEditingController();
  final _minutesController      = TextEditingController();
  final _secondsController      = TextEditingController();

  File? _selectedVideo;
  File? _thumbnailFile;
  bool  _thumbnailFromVideo   = true;
  bool  _extractingThumbnail  = false;
  bool  _extractingDuration   = false;
  bool  _durationAutoFilled   = false;

  bool _isPublished = true;
  List<TrainerOption>       _trainers   = [];
  List<VideoCategoryEntity> _categories = [];
  int? _selectedTrainerId;
  int? _selectedCategoryId;

  late final String _role;
  late final int?   _jwtTrainerId;
  late final bool   _isOwner;

  @override
  void initState() {
    super.initState();
    final payload = decodeJwtPayload();
    _role    = ((payload?['role'] as String?) ?? '').toUpperCase().trim();
    _isOwner = _role == 'OWNER' || _role == 'ADMIN';
    if (!_isOwner) {
      final raw = payload?['trainerId'] ?? payload?['sub'];
      _jwtTrainerId = raw is int ? raw : int.tryParse(raw?.toString() ?? '');
    } else {
      _jwtTrainerId = null;
    }
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
    if (confirmed == true && controller.text.trim().isNotEmpty && mounted) {
      context.read<TrainingVideosBloc>().add(AddNewCategory(controller.text.trim()));
    }
    controller.dispose();
  }

  Future<void> _pickVideo() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.video);
    if (result == null || result.files.single.path == null) return;

    final file = File(result.files.single.path!);
    setState(() {
      _selectedVideo      = file;
      _extractingDuration = true;
      _durationAutoFilled = false;
      if (_thumbnailFromVideo) _thumbnailFile = null;
    });

    // Auto-extract duration
    try {
      final vc = VideoPlayerController.file(file);
      await vc.initialize();
      final dur = vc.value.duration;
      await vc.dispose();
      if (mounted) {
        setState(() {
          _minutesController.text = dur.inMinutes.toString();
          _secondsController.text = (dur.inSeconds % 60).toString();
          _extractingDuration     = false;
          _durationAutoFilled     = true;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _extractingDuration = false);
    }

    // Auto-extract thumbnail when mode is "from video"
    if (_thumbnailFromVideo) await _doExtractThumbnail(file.path);
  }

  Future<void> _doExtractThumbnail(String videoPath) async {
    setState(() => _extractingThumbnail = true);
    try {
      final tmpDir    = await getTemporaryDirectory();
      final thumbPath = await VideoThumbnail.thumbnailFile(
        video:         videoPath,
        thumbnailPath: tmpDir.path,
        imageFormat:   ImageFormat.JPEG,
        maxWidth:      400,
        quality:       85,
      );
      if (mounted) {
        setState(() {
          _thumbnailFile      = thumbPath != null ? File(thumbPath) : null;
          _extractingThumbnail = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _extractingThumbnail = false);
    }
  }

  Future<void> _pickThumbnailFromGallery() async {
    final img = await ImagePicker().pickImage(
      source:       ImageSource.gallery,
      imageQuality: 85,
    );
    if (img != null && mounted) setState(() => _thumbnailFile = File(img.path));
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select or create a category')),
      );
      return;
    }

    final mins  = int.tryParse(_minutesController.text) ?? 0;
    final secs  = int.tryParse(_secondsController.text) ?? 0;
    final total = (mins * 60) + secs;
    if (total <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Duration must be greater than 0')),
      );
      return;
    }

    final resolvedTrainerId = _isOwner ? _selectedTrainerId : _jwtTrainerId;
    context.read<TrainingVideosBloc>().add(
      SubmitCreateVideo(
        CreateTrainingVideoRequest(
          title:           _titleController.text.trim(),
          description:     _descriptionController.text.trim(),
          categoryId:      _selectedCategoryId!,
          videoUrl:        _videoUrlController.text.trim(),
          videoFile:       _selectedVideo,
          thumbnailUrl:    _thumbnailFromVideo ? null : _thumbnailUrlController.text.trim(),
          thumbnailFile:   _thumbnailFile,
          durationSeconds: total,
          isPublished:     _isPublished,
          trainerId:       resolvedTrainerId,
        ),
      ),
    );
  }

  // ── helpers ──────────────────────────────────────────────────────────────────

  Widget _sectionLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Text(
      text,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    ),
  );

  Widget _thumbnailPreview() => Stack(
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.file(
          _thumbnailFile!,
          height: 160,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
      Positioned(
        top: 6,
        right: 6,
        child: GestureDetector(
          onTap: () => setState(() => _thumbnailFile = null),
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Colors.black54,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.close, color: Colors.white, size: 16),
          ),
        ),
      ),
    ],
  );

  // ── build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return MultiBlocListener(
      listeners: [
        BlocListener<TrainingVideosBloc, TrainingVideosState>(
          listenWhen: (_, curr) => curr is CreateVideoSuccess || curr is CreateVideoError,
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
        BlocListener<TrainingVideosBloc, TrainingVideosState>(
          listenWhen: (_, curr) => curr is CategoryCreated || curr is CategoryCreateError,
          listener: (context, state) {
            if (state is CategoryCreated) {
              setState(() {
                _categories         = [..._categories, state.category];
                _selectedCategoryId = state.category.categoryId;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Category "${state.category.name}" created and selected'),
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
            curr is CategoryCreated ||
            curr is CategoryCreateError ||
            curr is CreateVideoLoading,
        builder: (context, state) {
          if (state is VideoFormOptionsLoaded) {
            _trainers   = state.trainers;
            _categories = state.categories;
          }
          final isLoading          = state is CreateVideoLoading;
          final isCategoryCreating = state is CategoryCreating;

          return Scaffold(
            appBar: AppBar(
              title: const Text('Add Training Video'),
              centerTitle: false,
            ),
            body: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                children: [

                  // ── Basic Info ─────────────────────────────────────────
                  _sectionLabel('Basic Info'),
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title *',
                      prefixIcon: Icon(Icons.title),
                    ),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Title is required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description (optional)',
                      prefixIcon: Icon(Icons.notes),
                      alignLabelWithHint: true,
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),

                  // ── Category ───────────────────────────────────────────
                  _sectionLabel('Category'),
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
                  const SizedBox(height: 24),

                  // ── Trainer ────────────────────────────────────────────
                  _sectionLabel('Trainer'),
                  if (_isOwner) ...[
                    DropdownButtonFormField<int?>(
                      value: _selectedTrainerId,
                      decoration: const InputDecoration(
                        labelText: 'Assign to Trainer *',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      hint: const Text('Select a trainer'),
                      items: _trainers
                          .map((t) => DropdownMenuItem<int?>(
                                value: t.trainerId,
                                child: Text(t.name),
                              ))
                          .toList(),
                      onChanged: (val) => setState(() => _selectedTrainerId = val),
                      validator: (v) => v == null ? 'Please assign a trainer' : null,
                    ),
                  ] else ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: cs.primaryContainer.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: cs.outline),
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
                  ],
                  const SizedBox(height: 24),

                  // ── Video ──────────────────────────────────────────────
                  _sectionLabel('Video'),
                  OutlinedButton.icon(
                    onPressed: _pickVideo,
                    icon: const Icon(Icons.video_library_outlined),
                    label: const Text('Pick Video From Phone'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
                  ),
                  if (_selectedVideo != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle_outline, color: Colors.green, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _selectedVideo!.path.split(RegExp(r'[/\\]')).last,
                              style: Theme.of(context).textTheme.bodySmall,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _videoUrlController,
                    decoration: const InputDecoration(
                      labelText: 'Video URL (YouTube / Vimeo)',
                      prefixIcon: Icon(Icons.link),
                    ),
                    keyboardType: TextInputType.url,
                  ),
                  const SizedBox(height: 24),

                  // ── Duration ───────────────────────────────────────────
                  _sectionLabel('Duration *'),
                  if (_extractingDuration) ...[
                    Row(
                      children: [
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Reading duration from video…',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ] else if (_durationAutoFilled) ...[
                    Row(
                      children: [
                        Icon(Icons.auto_fix_high, size: 15, color: Colors.green.shade600),
                        const SizedBox(width: 6),
                        Text(
                          'Auto-filled from video — you can edit below',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.green.shade700,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _minutesController,
                          decoration: const InputDecoration(
                            labelText: 'Minutes',
                            suffixText: 'min',
                          ),
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
                            labelText: 'Seconds',
                            suffixText: 'sec',
                          ),
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
                  const SizedBox(height: 24),

                  // ── Thumbnail ──────────────────────────────────────────
                  _sectionLabel('Thumbnail (optional)'),
                  SegmentedButton<bool>(
                    segments: const [
                      ButtonSegment<bool>(
                        value: true,
                        label: Text('From Video'),
                        icon: Icon(Icons.video_call_outlined),
                      ),
                      ButtonSegment<bool>(
                        value: false,
                        label: Text('Custom'),
                        icon: Icon(Icons.image_outlined),
                      ),
                    ],
                    selected: {_thumbnailFromVideo},
                    onSelectionChanged: (s) async {
                      final fromVideo = s.first;
                      setState(() {
                        _thumbnailFromVideo = fromVideo;
                        _thumbnailFile      = null;
                      });
                      if (fromVideo && _selectedVideo != null) {
                        await _doExtractThumbnail(_selectedVideo!.path);
                      }
                    },
                  ),
                  const SizedBox(height: 12),

                  // "From Video" mode content
                  if (_thumbnailFromVideo) ...[
                    if (_selectedVideo == null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: cs.surfaceContainerHighest.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, size: 18, color: cs.onSurface.withValues(alpha: 0.6)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Pick a video above to auto-extract a thumbnail',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                          ],
                        ),
                      )
                    else if (_extractingThumbnail)
                      Row(
                        children: [
                          const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Extracting thumbnail…',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      )
                    else if (_thumbnailFile != null) ...[
                      _thumbnailPreview(),
                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        onPressed: () => _doExtractThumbnail(_selectedVideo!.path),
                        icon: const Icon(Icons.refresh, size: 18),
                        label: const Text('Re-extract'),
                      ),
                    ] else ...[
                      Row(
                        children: [
                          const Icon(Icons.warning_amber_outlined,
                              size: 18, color: Colors.orange),
                          const SizedBox(width: 8),
                          const Text('Could not extract thumbnail'),
                          const Spacer(),
                          TextButton(
                            onPressed: () => _doExtractThumbnail(_selectedVideo!.path),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ],
                  ],

                  // "Custom" mode content
                  if (!_thumbnailFromVideo) ...[
                    OutlinedButton.icon(
                      onPressed: _pickThumbnailFromGallery,
                      icon: const Icon(Icons.photo_library_outlined),
                      label: const Text('Pick from Gallery'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                      ),
                    ),
                    if (_thumbnailFile != null) ...[
                      const SizedBox(height: 10),
                      _thumbnailPreview(),
                    ] else ...[
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Expanded(child: Divider()),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              'or enter URL',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                          const Expanded(child: Divider()),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _thumbnailUrlController,
                        decoration: const InputDecoration(
                          labelText: 'Thumbnail URL',
                          prefixIcon: Icon(Icons.link),
                        ),
                        keyboardType: TextInputType.url,
                      ),
                    ],
                  ],
                  const SizedBox(height: 24),

                  // ── Published toggle ───────────────────────────────────
                  SwitchListTile(
                    title: const Text('Published'),
                    subtitle: const Text('Visible to members immediately'),
                    value: _isPublished,
                    onChanged: (val) => setState(() => _isPublished = val),
                    contentPadding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 28),

                  // ── Submit ─────────────────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: FilledButton(
                      onPressed: isLoading ? null : _submit,
                      child: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : const Text(
                              'Add Video',
                              style: TextStyle(fontSize: 16),
                            ),
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
