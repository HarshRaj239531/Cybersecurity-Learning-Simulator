import { Response, Request } from "express";
import { LeaderboardService } from "./leaderboard.service";

const leaderboardService = new LeaderboardService();

export const getLeaderboard = async (req: Request, res: Response) => {
  try {
    const limit = req.query.limit ? parseInt(req.query.limit as string) : 10;
    const leaderboard = await leaderboardService.getLeaderboard(limit);
    res.json({ status: "success", data: leaderboard });
  } catch (error: any) {
    res.status(500).json({ status: "error", message: error.message });
  }
};
