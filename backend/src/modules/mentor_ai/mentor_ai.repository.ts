import { prisma } from "../../lib/prisma";

export class MentorAiRepository {
  async saveChat(userId: string, message: string, response: string) {
    return prisma.aiChat.create({
      data: { userId, message, response },
    });
  }

  async getChatHistory(userId: string) {
    return prisma.aiChat.findMany({
      where: { userId },
      orderBy: { sentAt: 'asc' },
    });
  }
}
