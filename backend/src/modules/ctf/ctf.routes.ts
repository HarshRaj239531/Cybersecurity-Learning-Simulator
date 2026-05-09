import { Router } from "express";
import { authMiddleware } from "../../core/middleware/auth.middleware";
import {
  getAllChallenges,
  submitFlag,
  getMyCtfProgress,
} from "./ctf.controllers";

const router = Router();

/**
 * @swagger
 * /ctf:
 *   get:
 *     summary: Get all CTF challenges
 *     tags: [CTF]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: List of challenges
 */
router.get("/", authMiddleware, getAllChallenges);

/**
 * @swagger
 * /ctf/my-progress:
 *   get:
 *     summary: Get current user's CTF progress
 *     tags: [CTF]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: User's CTF progress
 */
router.get("/my-progress", authMiddleware, getMyCtfProgress);

/**
 * @swagger
 * /ctf/{id}/submit:
 *   post:
 *     summary: Submit a flag for a challenge
 *     tags: [CTF]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               flag:
 *                 type: string
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Flag submission result
 */
router.post("/:id/submit", authMiddleware, submitFlag);

export default router;
