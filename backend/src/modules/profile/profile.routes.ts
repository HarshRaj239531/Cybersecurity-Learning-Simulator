import { Router } from "express";
import { authMiddleware } from "../../core/middleware/auth.middleware";
import { getMyProfile, updateMyProfile, changePassword } from "./profile.controllers";

const router = Router();

router.get("/", authMiddleware, getMyProfile);
router.patch("/", authMiddleware, updateMyProfile);
router.post("/change-password", authMiddleware, changePassword);

export default router;
