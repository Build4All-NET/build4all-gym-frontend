import 'package:build4allgym/common/widgets/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../auth/presentation/admin_profile/admin_profile_cubit.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../navigation/presentation/widgets/admin_navigation_drawer.dart';
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
    // The BLoC is already provided by the router (app_router.dart) and
    // LoadTrainingVideos() is already dispatched there. Do NOT wrap again
    // with BlocProvider here — that would double-dispatch and risk
    // closing the shared BLoC on dispose.
    return const _TrainingVideosListView();
  }
}

class _TrainingVideosListView extends StatelessWidget {
  const _TrainingVideosListView();

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<AdminProfileCubit>().state;

    return BlocListener<TrainingVideosBloc, TrainingVideosState>(
      listenWhen: (_, curr) =>
          curr is DeleteVideoSuccess ||
          curr is DeleteVideoError ||
          curr is DeleteVideoLoading,
      listener: (context, state) {
        if (state is DeleteVideoSuccess) {
          AppToast.success(context, AppLocalizations.of(context)!.admin_trainingVideos_deleteSuccess);
          context.read<TrainingVideosBloc>().add(LoadTrainingVideos());
        } else if (state is DeleteVideoError) {
          AppToast.error(context, state.message);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.navTrainingVideos),
          centerTitle: false,
        ),
        drawer: AdminNavigationDrawer(
          gymName:    profile.gymName,
          branchName: profile.branchName,
          adminName:  profile.adminName,
          adminEmail: profile.adminEmail,
          avatarUrl:  profile.avatarUrl,
          initialActiveId: 'training_videos',
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
            context.read<TrainingVideosBloc>().add(LoadTrainingVideos());
          }),
          child: const Icon(Icons.add),
        ),
        body: BlocBuilder<TrainingVideosBloc, TrainingVideosState>(
          buildWhen: (prev, curr) =>
              curr is TrainingVideosLoading ||
              curr is TrainingVideosLoaded ||
              curr is TrainingVideosError ||
              curr is DeleteVideoLoading,
          builder: (context, state) {
            if (state is TrainingVideosLoading || state is DeleteVideoLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is TrainingVideosError) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(state.message),
                    TextButton(
                      onPressed: () => context
                          .read<TrainingVideosBloc>()
                          .add(LoadTrainingVideos()),
                      child: Text(AppLocalizations.of(context)!.retry),
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
    final l10n = AppLocalizations.of(context)!;
    return CustomScrollView(
      slivers: [
        // Stats row
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: _StatCard(
              label: l10n.admin_trainingVideos_totalVideos,
              value: '${state.stats.totalVideos}',
              backgroundColor: const Color(0xFFEDE7F6),
              iconColor: const Color(0xFF7C3AED),
              icon: Icons.video_library_outlined,
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
          SliverFillRemaining(
            child: Center(child: Text(l10n.admin_trainingVideos_noVideos)),
          )
        else
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final video = state.videos[index];
                // Look up category name from the loaded categories list
                final categoryName = state.categories
                    .where((c) => c.categoryId == video.categoryId)
                    .map((c) => c.name)
                    .firstOrNull;
                return VideoCard(video: video, categoryName: categoryName);
              },
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
    final l10n = AppLocalizations.of(context)!;
    return DropdownButtonFormField<int?>(
      value: selectedCategoryId,
      decoration: InputDecoration(
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        isDense: true,
      ),
      hint: Text(l10n.admin_trainingVideos_allCategories),
      items: [
        DropdownMenuItem<int?>(
          value: null,
          child: Text(l10n.admin_trainingVideos_allCategories),
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