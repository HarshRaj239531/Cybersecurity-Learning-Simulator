import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/providers/repository_providers.dart';

final ctfChallengesProvider = FutureProvider<List<dynamic>>((ref) async {
  final repository = ref.watch(ctfRepositoryProvider);
  return repository.getAllChallenges();
});

final ctfProgressProvider = FutureProvider<List<dynamic>>((ref) async {
  final repository = ref.watch(ctfRepositoryProvider);
  return repository.getMyCtfProgress();
});
