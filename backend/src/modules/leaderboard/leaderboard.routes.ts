import { Router } from "express";
import { getLeaderboard } from "./leaderboard.controllers";

const router = Router();

/**
 * @swagger
 * /leaderboard:
 *   get:
 *     summary: Get the leaderboard (top users by XP)
 *     tags: [Leaderboard]
 *     parameters:
 *       - in: query
 *         name: limit
 *         schema:
 *           type: integer
 *           default: 10
 *     responses:
 *       200:
 *         description: List of top users
 */
router.get("/", getLeaderboard);

export default router;
