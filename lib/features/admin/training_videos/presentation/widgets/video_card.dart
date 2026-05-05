// features/admin/training_videos/presentation/widgets/video_card.dart

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/training_video_entity.dart';
import '../utils/duration_formatter.dart';

// ── VideoCard ─────────────────────────────────────────────────────────────────
// A reusable card widget that renders a single training video in the list.
//
// Layout (top to bottom):
//   ┌──────────────────────────────────┐
//   │  [Thumbnail image]               │
//   │      ▶ (play button, centered)   │
//   │                    [MM:SS badge] │
//   ├──────────────────────────────────┤
//   │  Title                           │
//   │  [Category chip]   👁 viewCount  │
//   └──────────────────────────────────┘
//
// If thumbnailUrl is null → shows a gym icon placeholder instead.
// ─────────────────────────────────────────────────────────────────────────────

class VideoCard extends StatelessWidget {
  final TrainingVideoEntity video;

  const VideoCard({super.key, required this.video});

  @override
  Widget build(BuildContext context) {
    return Card(
      // Slight elevation gives the card a shadow to separate it from the list bg
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias, // clips thumbnail corners to match the card radius
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Thumbnail section ─────────────────────────────────────────────
          _buildThumbnail(context),

          // ── Text section ──────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Video title
                Text(
                  video.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),

                // Bottom row: category chip on the left, view count on the right
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildCategoryChip(context),
                    _buildViewCount(context),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Thumbnail with play button overlay and duration badge ─────────────────
  Widget _buildThumbnail(BuildContext context) {
    return SizedBox(
      height: 180, // fixed thumbnail height so all cards are the same size
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // ── Actual thumbnail image (or placeholder) ─────────────────────
          video.thumbnailUrl != null
          // CachedNetworkImage: downloads + caches the image so it doesn't
          // re-download every time the widget rebuilds or the user scrolls.
              ? CachedNetworkImage(
            imageUrl: video.thumbnailUrl!,
            fit: BoxFit.cover, // fills the container, may crop edges
            // Shown while the image is downloading
            placeholder: (_, __) => _gymPlaceholder(),
            // Shown if the URL is invalid / network fails
            errorWidget: (_, __, ___) => _gymPlaceholder(),
          )
          // thumbnailUrl is null → show the placeholder directly
              : _gymPlaceholder(),

          // ── Dark gradient overlay so the play button is visible ──────────
          // Without this, a white thumbnail would make the white play icon invisible.
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.35),
                ],
              ),
            ),
          ),

          // ── Play button — centered on the thumbnail ──────────────────────
          const Center(
            child: Icon(
              Icons.play_circle_fill_rounded,
              size: 52,
              color: Colors.white,
            ),
          ),

          // ── Duration badge — top-right corner ────────────────────────────
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.65),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                // DurationFormatter converts raw seconds → "MM:SS"
                // e.g. 305 → "5:05"
                DurationFormatter.format(video.durationSeconds),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Gym icon placeholder shown when thumbnailUrl is null or fails ─────────
  Widget _gymPlaceholder() {
    return Container(
      color: Colors.grey.shade200,
      child: const Center(
        child: Icon(
          Icons.fitness_center_rounded,
          size: 48,
          color: Colors.grey,
        ),
      ),
    );
  }

  // ── Category label chip ───────────────────────────────────────────────────
  Widget _buildCategoryChip(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        // Light purple tint — matches the Total Videos stat card color family
        color: const Color(0xFFEDE7F6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        video.categoryName,
        style: const TextStyle(
          color: Color(0xFF6A1B9A), // deep purple text on lavender bg
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // ── View count with eye icon ──────────────────────────────────────────────
  Widget _buildViewCount(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.remove_red_eye_outlined, size: 16, color: Colors.grey),
        const SizedBox(width: 4),
        Text(
          _formatViewCount(video.viewCount),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  /// Formats large view counts for readability:
  ///   999     → "999"
  ///   1200    → "1.2K"
  ///   15000   → "15K"
  ///   1200000 → "1.2M"
  String _formatViewCount(int count) {
    if (count >= 1000000) {
      final m = count / 1000000;
      return '${m.toStringAsFixed(m.truncateToDouble() == m ? 0 : 1)}M';
    } else if (count >= 1000) {
      final k = count / 1000;
      return '${k.toStringAsFixed(k.truncateToDouble() == k ? 0 : 1)}K';
    }
    return count.toString();
  }
}