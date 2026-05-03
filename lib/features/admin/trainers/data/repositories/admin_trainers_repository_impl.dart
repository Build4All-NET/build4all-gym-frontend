// ─────────────────────────────────────────────────────────────────────────────
// FILE: lib/features/admin/trainers/data/repositories/admin_trainers_repository_impl.dart
// ─────────────────────────────────────────────────────────────────────────────
import '../../../../../core/error/exceptions.dart';
import '../../domain/entities/AdminTrainerDetailEntity.dart';
import '../../domain/entities/admin_trainer_card_entity.dart';
import '../../domain/entities/trainer_form_options_entity.dart';
import '../../domain/repositories/admin_trainers_repository.dart';
import '../models/create_trainer_request_model.dart';
import '../models/update_trainer_request_model.dart';
import '../services/admin_trainers_service.dart';

class AdminTrainersRepositoryImpl implements AdminTrainersRepository {
  final AdminTrainersService _service;
  AdminTrainersRepositoryImpl(this._service);

  @override
  Future<List<AdminTrainerCardEntity>> getTrainers({
    int?    branchId,
    String? search,
    String? specialtyFilter,
  }) async {
    try {
      final response = await _service.getTrainers(
        branchId:        branchId,
        search:          search,
        specialtyFilter: specialtyFilter,
      );
      // In ga370_service_repo.dart — getTrainers() mapping:
      return response.trainers.map((m) => AdminTrainerCardEntity(
        trainerId:           m.trainerId,
        fullName:            m.fullName,
        email:               m.email,        // ← ADD
        phone:               m.phone,        // ← ADD
        profileFileId:       m.profileFileId,
        specialties:         m.specialties,
        avgRating:           m.avgRating,
        branchNames:         m.branches,     // ← was 'branches', now 'branchNames'
        availabilityDisplay: m.availabilityDisplay,
        status:              m.status,
      )).toList();
    } on UnauthorizedException {
      throw Exception('Session expired. Please log in again.');
    } on ForbiddenException {
      throw Exception('You do not have permission to view trainers.');
    } on ServerException catch (e) {
      throw Exception(e.message);
    } on NetworkException {
      throw Exception('No internet connection. Please try again.');
    }
  }

  @override
  Future<TrainerFormOptionsEntity> getFormOptions() async {
    try {
      final m = await _service.getFormOptions();
      return TrainerFormOptionsEntity(
        specialties: m.specialties,
        branches:    m.branches
            .map((b) => ClassFormOptionItemEntity(id: b.id, name: b.name))
            .toList(),
      );
    } on UnauthorizedException {
      throw Exception('Session expired. Please log in again.');
    } on ServerException catch (e) {
      throw Exception(e.message);
    } on NetworkException {
      throw Exception('No internet connection. Please try again.');
    }
  }

  @override
  Future<int> createTrainer(CreateTrainerRequestModel request) async {
    try {
      return await _service.createTrainer(request);
    } on UnauthorizedException {
      throw Exception('Session expired. Please log in again.');
    } on ServerException catch (e) {
      throw Exception(e.message);
    } on NetworkException {
      throw Exception('No internet connection. Please try again.');
    }
  }

  @override
  Future<void> updateTrainer(int trainerId, UpdateTrainerRequestModel request) async {
    try {
      await _service.updateTrainer(trainerId, request);
    } on UnauthorizedException {
      throw Exception('Session expired. Please log in again.');
    } on ServerException catch (e) {
      throw Exception(e.message);
    } on NetworkException {
      throw Exception('No internet connection. Please try again.');
    }
  }

  @override
  Future<String> blockTrainer(int trainerId) async {
    try {
      return await _service.blockTrainer(trainerId);
    } on UnauthorizedException {
      throw Exception('Session expired. Please log in again.');
    } on ServerException catch (e) {
      throw Exception(e.message);
    } on NetworkException {
      throw Exception('No internet connection. Please try again.');
    }
  }
  @override
  Future<AdminTrainerDetailEntity> getTrainerDetail(int trainerId) async {
    try {
      final model = await _service.getTrainerDetail(trainerId);
      return model.toEntity();
    } on UnauthorizedException {
      throw Exception('Session expired. Please log in again.');
    } on ServerException catch (e) {
      throw Exception(e.message);
    } on NetworkException {
      throw Exception('No internet connection. Please try again.');
    }
  }

}