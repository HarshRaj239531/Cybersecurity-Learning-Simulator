import { LeaderboardRepository } from "./leaderboard.repository";

const leaderboardRepository = new LeaderboardRepository();

export class LeaderboardService {
  async getLeaderboard(limit?: number) {
    return leaderboardRepository.getTopUsers(limit);
  }
}
