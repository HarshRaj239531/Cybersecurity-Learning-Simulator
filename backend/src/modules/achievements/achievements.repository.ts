import { prisma } from "../../lib/prisma";

export class AchievementsRepository {
  async getAllAchievements() {
    return prisma.achievement.findMany();
  }

  async getUserAchievements(userId: string) {
    return prisma.userAchievement.findMany({
      where: { userId },
      include: { achievement: true },
    });
  }

  async awardAchievement(userId: string, achievementId: string) {
    return prisma.userAchievement.create({
      data: { userId, achievementId },
    });
  }
}
