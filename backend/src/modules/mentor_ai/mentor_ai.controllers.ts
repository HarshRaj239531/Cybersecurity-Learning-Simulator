import { Response } from "express";
import { AuthRequest } from "../../core/middleware/auth.middleware";
import { MentorAiService } from "./mentor_ai.service";

const mentorAiService = new MentorAiService();

export const chat = async (req: AuthRequest, res: Response) => {
  try {
    const { message } = req.body;
    if (!message) throw new Error("Message is required");
    const result = await mentorAiService.chat(req.userId!, message);
    res.json({ status: "success", data: result });
  } catch (error: any) {
    res.status(400).json({ status: "error", message: error.message });
  }
};

export const getHistory = async (req: AuthRequest, res: Response) => {
  try {
    const history = await mentorAiService.getHistory(req.userId!);
    res.json({ status: "success", data: history });
  } catch (error: any) {
    res.status(500).json({ status: "error", message: error.message });
  }
};
