import { Response } from "express";
import { AuthRequest } from "../../core/middleware/auth.middleware";
import { LabsService } from "./labs.service";

const labsService = new LabsService();

export const getAllLabs = async (req: AuthRequest, res: Response) => {
  try {
    const labs = await labsService.getAllLabs();
    res.json({ status: "success", data: labs });
  } catch (error: any) {
    res.status(500).json({ status: "error", message: error.message });
  }
};

export const getLabById = async (req: AuthRequest, res: Response) => {
  try {
    const lab = await labsService.getLabById(req.params.id as string);
    res.json({ status: "success", data: lab });
  } catch (error: any) {
    res.status(404).json({ status: "error", message: error.message });
  }
};

export const completeLab = async (req: AuthRequest, res: Response) => {
  try {
    const { score } = req.body;
    const result = await labsService.completeLab(req.userId!, req.params.id as string, score);
    res.json({ status: "success", data: result });
  } catch (error: any) {
    res.status(400).json({ status: "error", message: error.message });
  }
};

export const getMyProgress = async (req: AuthRequest, res: Response) => {
  try {
    const progress = await labsService.getUserProgress(req.userId!);
    res.json({ status: "success", data: progress });
  } catch (error: any) {
    res.status(500).json({ status: "error", message: error.message });
  }
};
