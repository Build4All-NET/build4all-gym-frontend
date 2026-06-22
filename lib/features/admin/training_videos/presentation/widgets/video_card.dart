import 'package:build4allgym/common/widgets/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/network/globals.dart';
import '../../domain/entities/training_video_entity.dart';
import '../bloc/training_videos_bloc.dart';
import '../bloc/training_videos_event.dart';
import '../screens/edit_training_video_page.dart';
import '../screens/video_player_page.dart';
import '../../../../../l10n/app_localizations.dart';

class VideoCard extends StatelessWidget {
  final TrainingVideoEntity video;
  final String? categoryName;

  const VideoCard({super.key, required this.video, this.categoryName});

  String _formatDuration(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.trainingVideos_deleteTitle),
        content: Text(l10n.trainingVideos_deleteConfirm(video.title)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l10n.general_cancel)),
          FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: Theme.of(ctx).colorScheme.error),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.admin_plans_delete),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      context.read<TrainingVideosBloc>().add(DeleteVideo(video.videoId));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final payload = decodeJwtPayload();
    final role = ((payload?['role'] as String?) ?? '').toUpperCase().trim();
    final isOwner = role == 'OWNER' || role == 'ADMIN';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail with play overlay
          InkWell(
            onTap: () => _openPlayer(context),
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: video.thumbnailUrl != null
                      ? CachedNetworkImage(
                          imageUrl: video.thumbnailUrl!,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => _placeholder(context),
                          errorWidget: (_, __, ___) => _placeholder(context),
                        )
                      : _placeholder(context),
                ),
                // Duration badge
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.75),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _formatDuration(video.durationSeconds),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                // Play button
                Positioned.fill(
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.play_arrow,
                          color: Colors.white, size: 32),
                    ),
                  ),
                ),
                // Unpublished badge
                if (!video.isPublished)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade800,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(l10n.trainingVideos_draftBadge,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
              ],
            ),
          ),
          // Info row
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 4, 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        video.title,
                        style: theme.textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.w600),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          // Category chip
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              categoryName ?? video.categoryName ?? l10n.trainingVideos_categoryFallback,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Trainer name
                          Flexible(
                            child: Row(
                              children: [
                                Icon(Icons.person_outline,
                                    size: 13,
                                    color: theme.colorScheme.outline),
                                const SizedBox(width: 3),
                                Flexible(
                                  child: Text(
                                    video.trainerName,
                                    style: theme.textTheme.labelSmall?.copyWith(
                                        color: theme.colorScheme.outline),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          // View count
                          Icon(Icons.remove_red_eye_outlined,
                              size: 13, color: theme.colorScheme.outline),
                          const SizedBox(width: 3),
                          Text(
                            '${video.viewCount}',
                            style: theme.textTheme.labelSmall
                                ?.copyWith(color: theme.colorScheme.outline),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Actions menu
                PopupMenuButton<_CardAction>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (action) async {
                    if (action == _CardAction.play) {
                      _openPlayer(context);
                    } else if (action == _CardAction.edit) {
                      final refreshed = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: context.read<TrainingVideosBloc>(),
                            child: EditTrainingVideoPage(video: video),
                          ),
                        ),
                      );
                      if (refreshed == true && context.mounted) {
                        context
                            .read<TrainingVideosBloc>()
                            .add(LoadTrainingVideos());
                      }
                    } else if (action == _CardAction.delete) {
                      await _confirmDelete(context);
                    }
                  },
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      value: _CardAction.play,
                      child: ListTile(
                        leading: const Icon(Icons.play_circle_outline),
                        title: Text(l10n.trainingVideos_playAction),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    PopupMenuItem(
                      value: _CardAction.edit,
                      child: ListTile(
                        leading: const Icon(Icons.edit_outlined),
                        title: Text(l10n.trainingVideos_editAction),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    PopupMenuItem(
                      value: _CardAction.delete,
                      child: ListTile(
                        leading: Icon(Icons.delete_outline,
                            color: theme.colorScheme.error),
                        title: Text(l10n.admin_plans_delete,
                            style:
                                TextStyle(color: theme.colorScheme.error)),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openPlayer(BuildContext context) {
    if (video.videoUrl == null || video.videoUrl!.isEmpty) {
      AppToast.info(context, AppLocalizations.of(context)!.trainingVideos_noVideoUrl);
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            VideoPlayerPage(videoUrl: video.videoUrl!, title: video.title),
      ),
    );
  }

  Widget _placeholder(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceVariant,
      child:
          const Center(child: Icon(Icons.fitness_center, size: 48, color: Colors.white54)),
    );
  }
}

enum _CardAction { play, edit, delete }
