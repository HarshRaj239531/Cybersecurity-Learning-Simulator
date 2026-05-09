import { prisma } from "../../lib/prisma";

export class ProfileRepository {
  async getUserProfile(userId: string) {
    const user = await prisma.user.findUnique({
      where: { id: userId },
      include: {
        progress: {
          include: { lab: true },
          where: { completed: true },
        },
        challengeProgress: {
          include: { challenge: true },
        },
        userAchievements: {
          include: { achievement: true },
        },
      },
    });

    if (!user) return null;

    // Strip password before returning to the client
    const { password, ...safeUser } = user;
    return safeUser;
  }

  async updateProfile(userId: string, data: any) {
    return prisma.user.update({
      where: { id: userId },
      data,
    });
  }
}
