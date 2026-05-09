import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/providers/repository_providers.dart';

final labsProvider = FutureProvider<List<dynamic>>((ref) async {
  final repository = ref.watch(labsRepositoryProvider);
  return repository.getAllLabs();
});

final myProgressProvider = FutureProvider<List<dynamic>>((ref) async {
  // This would normally call repository.getMyProgress()
  // For now let's use the labsRepository
  final repository = ref.watch(labsRepositoryProvider);
  return []; // Placeholder for now as I didn't add getMyProgress to repository yet
});
