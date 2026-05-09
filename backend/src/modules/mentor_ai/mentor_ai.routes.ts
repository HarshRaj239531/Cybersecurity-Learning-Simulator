import { Router } from "express";
import { authMiddleware } from "../../core/middleware/auth.middleware";
import { chat, getHistory } from "./mentor_ai.controllers";

const router = Router();

/**
 * @swagger
 * /mentor/chat:
 *   post:
 *     summary: Chat with the AI Mentor
 *     tags: [Mentor AI]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               message:
 *                 type: string
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: AI response
 */
router.post("/chat", authMiddleware, chat);

/**
 * @swagger
 * /mentor/history:
 *   get:
 *     summary: Get chat history with the AI Mentor
 *     tags: [Mentor AI]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Chat history
 */
router.get("/history", authMiddleware, getHistory);

export default router;
