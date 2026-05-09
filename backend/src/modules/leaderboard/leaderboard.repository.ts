import { prisma } from "../../lib/prisma";

export class LeaderboardRepository {
  async getTopUsers(limit: number = 10) {
    return prisma.user.findMany({
      take: limit,
      orderBy: { xp: 'desc' },
      select: {
        id: true,
        username: true,
        xp: true,
        rank: true,
        streak: true,
      },
    });
  }
}
