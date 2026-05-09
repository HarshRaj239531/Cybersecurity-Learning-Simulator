import { CtfRepository } from "./ctf.repository";
import { prisma } from "../../lib/prisma";

const ctfRepository = new CtfRepository();

export class CtfService {
  async getAllChallenges() {
    return ctfRepository.getAllChallenges();
  }

  async submitFlag(userId: string, challengeId: string, flag: string) {
    const challenge = await ctfRepository.getChallengeById(challengeId);
    if (!challenge) throw new Error("Challenge not found");

    if (challenge.flag !== flag) {
      throw new Error("Invalid flag");
    }

    const alreadyCompleted = await ctfRepository.checkCompletion(userId, challengeId);
    if (alreadyCompleted) throw new Error("Challenge already completed");

    // Award XP to user
    await prisma.user.update({
      where: { id: userId },
      data: { xp: { increment: challenge.xpReward } },
    });

    return ctfRepository.submitFlag(userId, challengeId);
  }

  async getMyProgress(userId: string) {
    return ctfRepository.getChallengeProgress(userId);
  }
}
