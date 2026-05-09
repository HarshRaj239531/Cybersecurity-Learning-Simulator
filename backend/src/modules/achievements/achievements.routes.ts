import { Router } from "express";
import { authMiddleware } from "../../core/middleware/auth.middleware";
import {
  getAllAchievements,
  getMyAchievements,
} from "./achievements.controllers";

const router = Router();

/**
 * @swagger
 * /achievements:
 *   get:
 *     summary: Get all possible achievements
 *     tags: [Achievements]
 *     responses:
 *       200:
 *         description: List of achievements
 */
router.get("/", getAllAchievements);

/**
 * @swagger
 * /achievements/my:
 *   get:
 *     summary: Get user's earned achievements
 *     tags: [Achievements]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: List of earned achievements
 */
router.get("/my", authMiddleware, getMyAchievements);

export default router;
