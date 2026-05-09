import { Response } from "express";
import { AuthRequest } from "../../core/middleware/auth.middleware";
import { AchievementsService } from "./achievements.service";

const achievementsService = new AchievementsService();

export const getAllAchievements = async (req: AuthRequest, res: Response) => {
  try {
    const achievements = await achievementsService.getAllAchievements();
    res.json({ status: "success", data: achievements });
  } catch (error: any) {
    res.status(500).json({ status: "error", message: error.message });
  }
};

export const getMyAchievements = async (req: AuthRequest, res: Response) => {
  try {
    const achievements = await achievementsService.getMyAchievements(req.userId!);
    res.json({ status: "success", data: achievements });
  } catch (error: any) {
    res.status(500).json({ status: "error", message: error.message });
  }
};
