import { Response } from "express";
import { AuthRequest } from "../../core/middleware/auth.middleware";
import { CtfService } from "./ctf.service";

const ctfService = new CtfService();

export const getAllChallenges = async (req: AuthRequest, res: Response) => {
  try {
    const challenges = await ctfService.getAllChallenges();
    res.json({ status: "success", data: challenges });
  } catch (error: any) {
    res.status(500).json({ status: "error", message: error.message });
  }
};

export const submitFlag = async (req: AuthRequest, res: Response) => {
  try {
    const { flag } = req.body;
    const result = await ctfService.submitFlag(req.userId!, req.params.id as string, flag);
    res.json({ status: "success", message: "Correct flag! Challenge completed.", data: result });
  } catch (error: any) {
    res.status(400).json({ status: "error", message: error.message });
  }
};

export const getMyCtfProgress = async (req: AuthRequest, res: Response) => {
  try {
    const progress = await ctfService.getMyProgress(req.userId!);
    res.json({ status: "success", data: progress });
  } catch (error: any) {
    res.status(500).json({ status: "error", message: error.message });
  }
};
