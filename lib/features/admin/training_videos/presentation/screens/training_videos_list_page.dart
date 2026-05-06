// features/admin/training_videos/presentation/pages/training_videos_list_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/training_videos_bloc.dart';
import '../widgets/video_card.dart';

// ── TrainingVideosListPage ────────────────────────────────────────────────────
// The main Training Videos admin screen.
//
// What it shows (top to bottom):
//   AppBar          → "Training Videos" + "+" FAB to open Add Video
//   Category filter → "All Categories" dropdown
//   Stats row       → Total Videos card (lavender) | Total Views card (light blue)
//   Video list      → scrollable list of VideoCard widgets
//
// The page does NOT call any services directly.
// It only dispatches Events to the BLoC and reads States from it.
// ─────────────────────────────────────────────────────────────────────────────

class TrainingVideosListPage extends StatefulWidget {
  const TrainingVideosListPage({super.key});

  @override
  State<TrainingVideosListPage> createState() => _TrainingVideosListPageState();
}

class _TrainingVideosListPageState extends State<TrainingVideosListPage> {
  @override
  void initState() {
    super.initState();
    // Fire the initial load event as soon as the page mounts.
    // context.read<T>() gets the BLoC from the widget tree without subscribing to rebuilds.
    context.read<TrainingVideosBloc>().add(const LoadTrainingVideos());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ── AppBar ─────────────────────────────────────────────────────────────
      appBar: AppBar(
        title: const Text('Training Videos'),
        centerTitle: true,
        actions: [
          // "+" button in the AppBar — opens the Add Video page
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add Video',
            onPressed: () {
              // TODO: Navigate to AddVideoPage when it is implemented
              // Navigator.pushNamed(context, AppRoutes.addTrainingVideo);
            },
          ),
        ],
      ),

      // ── Body: BlocBuilder reacts to BLoC state changes ────────────────────
      // BlocBuilder wraps the body so the entire content area rebuilds
      // whenever the BLoC emits a new state.
      body: BlocBuilder<TrainingVideosBloc, TrainingVideosState>(
        builder: (context, state) {
          // Show spinner while loading
          if (state is TrainingVideosLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Show error + retry button on failure
          if (state is TrainingVideosError) {
            return _buildError(context, state.message);
          }

          // Show the actual content when data is ready
          if (state is TrainingVideosLoaded) {
            return _buildContent(context, state);
          }

          // TrainingVideosInitial — nothing to show yet (very brief)
          return const SizedBox.shrink();
        },
      ),
    );
  }

  // ── Full-page error view with a retry button ──────────────────────────────
  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              onPressed: () {
                // Dispatch LoadTrainingVideos again to retry the HTTP call
                context.read<TrainingVideosBloc>().add(const LoadTrainingVideos());
              },
            ),
          ],
        ),
      ),
    );
  }

  // ── Main content: filter + stats + video list ─────────────────────────────
  Widget _buildContent(BuildContext context, TrainingVideosLoaded state) {
    return Column(
      children: [
        // Category filter dropdown and stats row sit above the scrollable list
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Column(
            children: [
              _buildCategoryDropdown(context, state),
              const SizedBox(height: 16),
              _buildStatsRow(context, state),
              const SizedBox(height: 16),
            ],
          ),
        ),

        // Video list takes up the remaining vertical space and scrolls
        Expanded(
          child: state.videos.isEmpty
              ? _buildEmptyState()
              : ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            itemCount: state.videos.length,
            // A thin divider line between cards for visual separation
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return VideoCard(video: state.videos[index]);
            },
          ),
        ),
      ],
    );
  }

  // ── "All Categories" filter dropdown ─────────────────────────────────────
  Widget _buildCategoryDropdown(BuildContext context, TrainingVideosLoaded state) {
    // Build dropdown items: "All Categories" first, then one item per category
    final items = <DropdownMenuItem<int?>>[
      // null value = no filter (show all)
      const DropdownMenuItem<int?>(
        value: null,
        child: Text('All Categories'),
      ),
      // One item per category returned by the backend
      ...state.categories.map(
            (cat) => DropdownMenuItem<int?>(
          value: cat.categoryId,
          child: Text(cat.name),
        ),
      ),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int?>(
          isExpanded: true,
          // selectedCategoryId from the state reflects what was last picked
          value: state.selectedCategoryId,
          items: items,
          onChanged: (selectedId) {
            // Dispatch FilterByCategory — BLoC reloads the list with this filter
            context
                .read<TrainingVideosBloc>()
                .add(FilterByCategory(selectedId));
          },
        ),
      ),
    );
  }

  // ── Stats row: two side-by-side cards ────────────────────────────────────
  Widget _buildStatsRow(BuildContext context, TrainingVideosLoaded state) {
    return Row(
      children: [
        // Left card: Total Videos — lavender/purple background
        Expanded(
          child: _buildStatCard(
            label: 'Total Videos',
            value: state.stats.totalVideos.toString(),
            icon: Icons.video_library_rounded,
            backgroundColor: const Color(0xFFEDE7F6), // lavender
            iconColor: const Color(0xFF7B1FA2),        // deep purple
            textColor: const Color(0xFF4A148C),
          ),
        ),
        const SizedBox(width: 12),

        // Right card: Total Views — light blue background
        Expanded(
          child: _buildStatCard(
            label: 'Total Views',
            value: _formatLargeNumber(state.stats.totalViews),
            icon: Icons.remove_red_eye_rounded,
            backgroundColor: const Color(0xFFE3F2FD), // light blue
            iconColor: const Color(0xFF1565C0),        // dark blue
            textColor: const Color(0xFF0D47A1),
          ),
        ),
      ],
    );
  }

  // ── Individual stat card ──────────────────────────────────────────────────
  Widget _buildStatCard({
    required String label,
    required String value,
    required IconData icon,
    required Color backgroundColor,
    required Color iconColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Icon in a circular container
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // The number (e.g. "24" or "1.8K")
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              // The label (e.g. "Total Videos")
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: textColor.withOpacity(0.75),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Empty state shown when the filtered list has no results ───────────────
  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.videocam_off_rounded, size: 56, color: Colors.grey),
          SizedBox(height: 12),
          Text(
            'No videos found',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  /// Formats large view counts: 1200 → "1.2K", 1500000 → "1.5M"
  String _formatLargeNumber(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return n.toString();
  }
}