import { prisma } from "../../lib/prisma";

export class LabsRepository {
  async getAllLabs() {
    return prisma.lab.findMany();
  }

  async getLabById(id: string) {
    return prisma.lab.findUnique({ where: { id } });
  }

  async getUserProgress(userId: string) {
    return prisma.progress.findMany({
      where: { userId },
      include: { lab: true },
    });
  }

  async updateProgress(userId: string, labId: string, completed: boolean, score: number) {
    const existing = await prisma.progress.findUnique({
      where: { userId_labId: { userId, labId } },
    });

    // Only award XP if this is the first time completing
    if (!existing || !existing.completed) {
      const lab = await prisma.lab.findUnique({ where: { id: labId } });
      if (lab && completed) {
        await prisma.user.update({
          where: { id: userId },
          data: { xp: { increment: lab.xpReward } },
        });
      }
    }

    return prisma.progress.upsert({
      where: { userId_labId: { userId, labId } },
      update: { completed, score },
      create: { userId, labId, completed, score },
    });
  }
}
