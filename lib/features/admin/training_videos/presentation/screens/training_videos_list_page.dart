import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/training_videos_bloc.dart';
import '../bloc/training_videos_event.dart';
import '../bloc/training_videos_state.dart';
import '../widgets/video_card.dart';
import 'add_training_video_page.dart';
import '../../domain/entities/video_category_entity.dart';

class TrainingVideosListPage extends StatelessWidget {
  const TrainingVideosListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => context.read<TrainingVideosBloc>()
        ..add(LoadTrainingVideos()),
      child: const _TrainingVideosListView(),
    );
  }
}

class _TrainingVideosListView extends StatelessWidget {
  const _TrainingVideosListView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Training Videos'),
        centerTitle: false,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: context.read<TrainingVideosBloc>(),
              child: const AddTrainingVideoPage(),
            ),
          ),
        ).then((_) {
          // Refresh list after returning from add page
          context.read<TrainingVideosBloc>().add(LoadTrainingVideos());
        }),
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<TrainingVideosBloc, TrainingVideosState>(
        buildWhen: (prev, curr) =>
        curr is TrainingVideosLoading ||
            curr is TrainingVideosLoaded ||
            curr is TrainingVideosError,
        builder: (context, state) {
          if (state is TrainingVideosLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is TrainingVideosError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.message),
                  TextButton(
                    onPressed: () =>
                        context.read<TrainingVideosBloc>().add(LoadTrainingVideos()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          if (state is TrainingVideosLoaded) {
            return _LoadedBody(state: state);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _LoadedBody extends StatelessWidget {
  final TrainingVideosLoaded state;
  const _LoadedBody({required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CustomScrollView(
      slivers: [
        // Stats row
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: _StatCard(
                    label: 'Total Videos',
                    value: '${state.stats.totalVideos}',
                    backgroundColor:
                    const Color(0xFFEDE7F6), // lavender/purple tint
                    iconColor: const Color(0xFF7C3AED),
                    icon: Icons.video_library_outlined,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    label: 'Total Views',
                    value: '${state.stats.totalViews}',
                    backgroundColor:
                    const Color(0xFFE0F2FE), // light blue tint
                    iconColor: const Color(0xFF0284C7),
                    icon: Icons.remove_red_eye_outlined,
                  ),
                ),
              ],
            ),
          ),
        ),
        // Category filter dropdown
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: _CategoryDropdown(
              categories: state.categories,
              selectedCategoryId: state.selectedCategoryId,
            ),
          ),
        ),
        // Video list
        if (state.videos.isEmpty)
          const SliverFillRemaining(
            child: Center(child: Text('No videos found.')),
          )
        else
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) => VideoCard(video: state.videos[index]),
              childCount: state.videos.length,
            ),
          ),
        const SliverToBoxAdapter(child: SizedBox(height: 80)),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color backgroundColor;
  final Color iconColor;
  final IconData icon;

  const _StatCard({
    required this.label,
    required this.value,
    required this.backgroundColor,
    required this.iconColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(label,
                  style: const TextStyle(fontSize: 12, color: Colors.black54)),
            ],
          ),
        ],
      ),
    );
  }
}

class _CategoryDropdown extends StatelessWidget {
  final List<VideoCategoryEntity> categories;
  final int? selectedCategoryId;

  const _CategoryDropdown({
    required this.categories,
    required this.selectedCategoryId,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int?>(
      value: selectedCategoryId,
      decoration: InputDecoration(
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        isDense: true,
      ),
      hint: const Text('All Categories'),
      items: [
        const DropdownMenuItem<int?>(
          value: null,
          child: Text('All Categories'),
        ),
        ...categories.map(
              (c) => DropdownMenuItem<int?>(
            value: c.categoryId,
            child: Text(c.name),
          ),
        ),
      ],
      onChanged: (val) =>
          context.read<TrainingVideosBloc>().add(FilterByCategory(val)),
    );
  }
}