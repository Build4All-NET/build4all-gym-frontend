// features/admin/training_videos/di/training_videos_di.dart

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../data/repositories/training_video_repository_impl.dart';
import '../data/services/training_video_remote_datasource.dart';
import '../domain/repositories/training_video_repository.dart';
import '../domain/usecases/get_training_videos_usecase.dart';
import '../domain/usecases/get_video_categories_usecase.dart';
import '../presentation/bloc/training_videos_bloc.dart';

// ── What is DI (Dependency Injection)? ───────────────────────────────────────
// GetIt is a "service locator" — a global registry where we register
// objects once at startup, and then any file can fetch them with GetIt.I<T>().
//
// WHY bother?
//   Without DI, every class constructs its own dependencies:
//     var bloc = TrainingVideosBloc(
//       GetTrainingVideosUseCase(
//         TrainingVideoRepositoryImpl(
//           TrainingVideoRemoteDataSourceImpl(Dio())
//         )
//       )
//     );
//   With DI: GetIt.I<TrainingVideosBloc>() — one call, everywhere.
//
// This function is called ONCE from main.dart (or your app's init file)
// alongside other feature DI registrations.
// ─────────────────────────────────────────────────────────────────────────────

void registerTrainingVideosDependencies(GetIt sl) {
  // ── Step 1: Register the remote datasource ────────────────────────────────
  //
  // TrainingVideoRemoteDataSourceImpl needs a Dio instance.
  // We assume Dio is already registered in GetIt by your shared/core DI setup
  // (Mounir's config that sets baseUrl and the auth interceptor).
  // sl<Dio>() fetches that already-configured Dio instance.
  //
  // registerLazySingleton → created once on first use, then reused.
  sl.registerLazySingleton<TrainingVideoRemoteDataSource>(
        () => TrainingVideoRemoteDataSourceImpl(sl<Dio>()),
  );

  // ── Step 2: Register the repository implementation ────────────────────────
  //
  // The abstract TrainingVideoRepository is registered so that when anyone
  // asks for TrainingVideoRepository, they get the real Impl.
  // This is what makes "program to an interface" work in practice.
  sl.registerLazySingleton<TrainingVideoRepository>(
        () => TrainingVideoRepositoryImpl(sl<TrainingVideoRemoteDataSource>()),
  );

  // ── Step 3: Register use cases ────────────────────────────────────────────
  //
  // Each use case depends on the abstract repository (registered above).
  sl.registerLazySingleton(
        () => GetTrainingVideosUseCase(sl<TrainingVideoRepository>()),
  );

  sl.registerLazySingleton(
        () => GetVideoCategoriesUseCase(sl<TrainingVideoRepository>()),
  );

  // ── Step 4: Register the BLoC ─────────────────────────────────────────────
  //
  // registerFactory → creates a NEW BLoC instance every time one is requested.
  // This is important for BLoCs: each screen should get a fresh BLoC,
  // not share a stale one with leftover state from a previous navigation.
  sl.registerFactory(
        () => TrainingVideosBloc(
      getTrainingVideosUseCase: sl<GetTrainingVideosUseCase>(),
    ),
  );
}