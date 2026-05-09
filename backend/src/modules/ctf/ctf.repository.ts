import { prisma } from "../../lib/prisma";

export class CtfRepository {
  async getAllChallenges() {
    return prisma.challenge.findMany();
  }

  async getChallengeById(id: string) {
    return prisma.challenge.findUnique({ where: { id } });
  }

  async submitFlag(userId: string, challengeId: string) {
    return prisma.challengeProgress.create({
      data: {
        userId,
        challengeId,
      },
    });
  }

  async getChallengeProgress(userId: string) {
    return prisma.challengeProgress.findMany({
      where: { userId },
      include: { challenge: true },
    });
  }

  async checkCompletion(userId: string, challengeId: string) {
    return prisma.challengeProgress.findUnique({
      where: {
        userId_challengeId: { userId, challengeId },
      },
    });
  }
}
