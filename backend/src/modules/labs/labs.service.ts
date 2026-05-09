import { LabsRepository } from "./labs.repository";

const labsRepository = new LabsRepository();

export class LabsService {
  async getAllLabs() {
    return labsRepository.getAllLabs();
  }

  async getLabById(id: string) {
    const lab = await labsRepository.getLabById(id);
    if (!lab) throw new Error("Lab not found");
    return lab;
  }

  async completeLab(userId: string, labId: string, score: number) {
    const lab = await labsRepository.getLabById(labId);
    if (!lab) throw new Error("Lab not found");

    return labsRepository.updateProgress(userId, labId, true, score);
  }

  async getUserProgress(userId: string) {
    return labsRepository.getUserProgress(userId);
  }
}
