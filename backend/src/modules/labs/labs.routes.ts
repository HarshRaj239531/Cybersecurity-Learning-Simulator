import { Router } from "express";
import { authMiddleware } from "../../core/middleware/auth.middleware";
import {
  getAllLabs,
  getLabById,
  completeLab,
  getMyProgress,
} from "./labs.controllers";

const router = Router();

/**
 * @swagger
 * /labs:
 *   get:
 *     summary: Get all labs
 *     tags: [Labs]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: List of labs
 */
router.get("/", authMiddleware, getAllLabs);

/**
 * @swagger
 * /labs/my-progress:
 *   get:
 *     summary: Get current user's lab progress
 *     tags: [Labs]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: User's lab progress
 */
router.get("/my-progress", authMiddleware, getMyProgress);

/**
 * @swagger
 * /labs/{id}:
 *   get:
 *     summary: Get lab by ID
 *     tags: [Labs]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Lab details
 */
router.get("/:id", authMiddleware, getLabById);

/**
 * @swagger
 * /labs/{id}/complete:
 *   post:
 *     summary: Mark lab as completed
 *     tags: [Labs]
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
 *               score:
 *                 type: number
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Lab completion status
 */
router.post("/:id/complete", authMiddleware, completeLab);

export default router;
