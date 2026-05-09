import { AchievementsRepository } from "./achievements.repository";

const achievementsRepository = new AchievementsRepository();

export class AchievementsService {
  async getAllAchievements() {
    return achievementsRepository.getAllAchievements();
  }

  async getMyAchievements(userId: string) {
    return achievementsRepository.getUserAchievements(userId);
  }
}
