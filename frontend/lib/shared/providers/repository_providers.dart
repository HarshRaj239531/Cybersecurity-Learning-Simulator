import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/data/auth_repository.dart';
import '../../features/labs/data/labs_repository.dart';
import '../../features/ctf/data/ctf_repository.dart';
import '../../features/leaderboard/data/leaderboard_repository.dart';
import '../../features/profile/data/profile_repository.dart';
import '../../features/mentor_ai/data/mentor_ai_repository.dart';
import '../../features/achievements/data/achievement_repository.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository());
final labsRepositoryProvider = Provider((ref) => LabsRepository());
final ctfRepositoryProvider = Provider((ref) => CtfRepository());
final leaderboardRepositoryProvider = Provider((ref) => LeaderboardRepository());
final profileRepositoryProvider = Provider((ref) => ProfileRepository());
final mentorAiRepositoryProvider = Provider((ref) => MentorAiRepository());
final achievementRepositoryProvider = Provider((ref) => AchievementRepository());
