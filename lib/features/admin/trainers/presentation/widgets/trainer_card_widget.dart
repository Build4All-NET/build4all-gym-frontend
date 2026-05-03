// PATH: lib/features/admin/trainers/presentation/widgets/trainer_card_widget.dart
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/admin_trainer_card_entity.dart';
import '../bloc/admin_trainers_bloc.dart';
import '../bloc/admin_trainers_event.dart';

class TrainerCardWidget extends StatelessWidget {
  const TrainerCardWidget({
    super.key,
    required this.trainer,
    required this.isLoading,
    required this.onEditTap,
  });

  final AdminTrainerCardEntity trainer;
  final bool isLoading;
  final VoidCallback onEditTap;

  void _showBlockConfirmation(BuildContext context) {
    final action = trainer.isBlocked ? 'Unblock' : 'Block';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          '$action Trainer',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        content: Text(
          '$action ${trainer.fullName}? '
              '${trainer.isBlocked ? 'They will be able to log in again.' : 'They will not be able to log in.'}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context
                  .read<AdminTrainersBloc>()
                  .add(TrainerBlockRequested(trainer.trainerId));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: trainer.isBlocked
                  ? const Color(0xFF4CAF50)
                  : const Color(0xFFFF9800),
            ),
            child: Text(
              action,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar + name + status
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: const Color(0xFF1A1A2E),
                  child: Text(
                    trainer.initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        trainer.fullName,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                      const SizedBox(height: 2),
                      if (trainer.specialties.isNotEmpty)
                        Wrap(
                          spacing: 4,
                          runSpacing: 0,
                          children: trainer.specialties.map((s) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 1,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xFFE0E0E0),
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                s,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF616161),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: trainer.isBlocked
                        ? const Color(0xFFFFEBEE)
                        : const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    trainer.isBlocked ? 'Blocked' : 'Active',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: trainer.isBlocked
                          ? const Color(0xFFF44336)
                          : const Color(0xFF4CAF50),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                const Icon(
                  Icons.star_rounded,
                  color: Color(0xFFFFB300),
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  '${trainer.avgRating.toStringAsFixed(1)}/5.0',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF616161),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            if (trainer.branchNames.isNotEmpty)
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 14,
                    color: Color(0xFF9E9E9E),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      trainer.branchNames.join(', '),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF9E9E9E),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

            if (trainer.availabilityDisplay.isNotEmpty) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today_outlined,
                    size: 14,
                    color: Color(0xFF9E9E9E),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      trainer.availabilityDisplay,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF9E9E9E),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 12),

            if (isLoading)
              const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            else
              Row(
                children: [
                  Expanded(
                    child: _ActionBtn(
                      icon: Icons.calendar_month_outlined,
                      label: 'Schedule',
                      color: const Color(0xFF1976D2),
                      onTap: () {
                        // TODO: navigate to trainer schedule
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _ActionBtn(
                      icon: Icons.edit_outlined,
                      label: 'Edit',
                      color: const Color(0xFF2E7D32),
                      onTap: onEditTap,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _ActionBtn(
                      icon: trainer.isBlocked
                          ? Icons.lock_open_outlined
                          : Icons.block_outlined,
                      label: trainer.isBlocked ? 'Unblock' : 'Block',
                      color: trainer.isBlocked
                          ? const Color(0xFF4CAF50)
                          : const Color(0xFFF44336),
                      onTap: () => _showBlockConfirmation(context),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  const _ActionBtn({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      icon: Icon(icon, size: 14, color: color),
      label: Text(
        label,
        style: TextStyle(fontSize: 11, color: color),
      ),
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: color.withOpacity(0.5)),
        padding: const EdgeInsets.symmetric(vertical: 8),
      ),
    );
  }
}